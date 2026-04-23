import 'dart:io';

import 'package:drift/drift.dart';
import 'package:pocketread/data/database/app_database.dart';
import 'package:pocketread/data/parsers/book_file_metadata_parser.dart';
import 'package:pocketread/data/parsers/epub_book_parser.dart';
import 'package:pocketread/data/parsers/txt_book_parser.dart';
import 'package:pocketread/data/services/book_file_storage_service.dart';
import 'package:pocketread/data/services/file_hash_service.dart';
import 'package:pocketread/features/importer/domain/book_file_format.dart';
import 'package:pocketread/features/importer/domain/epub_book.dart';
import 'package:pocketread/features/importer/domain/import_job.dart';
import 'package:pocketread/features/importer/domain/txt_book.dart';

class BookImportRepository {
  const BookImportRepository({
    required AppDatabase database,
    required BookFileMetadataParser metadataParser,
    required FileHashService hashService,
    required BookFileStorageService storageService,
    required TxtBookParser txtBookParser,
    required EpubBookParser epubBookParser,
  }) : _database = database,
       _metadataParser = metadataParser,
       _hashService = hashService,
       _storageService = storageService,
       _txtBookParser = txtBookParser,
       _epubBookParser = epubBookParser;

  final AppDatabase _database;
  final BookFileMetadataParser _metadataParser;
  final FileHashService _hashService;
  final BookFileStorageService _storageService;
  final TxtBookParser _txtBookParser;
  final EpubBookParser _epubBookParser;

  Future<BookImportItemResult> importFile(String sourcePath) async {
    final int now = DateTime.now().millisecondsSinceEpoch;
    final File sourceFile = File(sourcePath);
    final String fallbackFileName = sourcePath
        .split(Platform.pathSeparator)
        .last;

    try {
      if (!await sourceFile.exists()) {
        await _insertImportRecord(
          sourcePath: sourcePath,
          fileName: fallbackFileName,
          result: 'failed',
          errorCode: 'file_not_found',
          errorMessage: '文件不存在或无法读取',
          createdAt: now,
        );
        return BookImportItemResult(
          sourcePath: sourcePath,
          fileName: fallbackFileName,
          status: BookImportItemStatus.failed,
          message: '文件不存在或无法读取',
        );
      }

      final BookFileMetadata metadata = _metadataParser.parse(sourcePath);
      final int fileSize = await sourceFile.length();
      final String fileHash = await _hashService.sha256OfFile(sourceFile);
      final Book? duplicateBook = await _findDuplicateByHash(fileHash);
      if (duplicateBook != null) {
        await _insertImportRecord(
          sourcePath: sourcePath,
          fileName: metadata.fileName,
          fileHash: fileHash,
          detectedFormat: metadata.format.value,
          duplicateBookId: duplicateBook.id,
          result: 'duplicate',
          errorCode: 'duplicate_file',
          errorMessage: '检测到重复导入',
          createdAt: now,
        );
        return BookImportItemResult(
          sourcePath: sourcePath,
          fileName: metadata.fileName,
          status: BookImportItemStatus.duplicate,
          message: '检测到重复导入',
          format: metadata.format,
          duplicateBookId: duplicateBook.id,
        );
      }

      final String bookId = _createBookId(fileHash);
      final String localFilePath = await _storageService.copyIntoLibrary(
        sourceFile: sourceFile,
        bookId: bookId,
        fileName: metadata.fileName,
      );
      final TxtParsedBook? parsedTxt = metadata.format == BookFileFormat.txt
          ? await _txtBookParser.parseFile(File(localFilePath))
          : null;
      final EpubParsedBook? parsedEpub = metadata.format == BookFileFormat.epub
          ? await _epubBookParser.parseFile(File(localFilePath))
          : null;
      final EpubCover? epubCover = parsedEpub?.cover;
      final String? coverImagePath = epubCover == null
          ? null
          : await _storageService.writeCoverImage(
              bookId: bookId,
              fileName: epubCover.fileName,
              bytes: epubCover.bytes,
            );
      await _database
          .into(_database.books)
          .insert(
            BooksCompanion.insert(
              id: bookId,
              format: metadata.format.value,
              title: _effectiveTitle(metadata, parsedEpub),
              author: Value<String>(_effectiveAuthor(metadata, parsedEpub)),
              sourceFilePath: sourcePath,
              localFilePath: localFilePath,
              fileName: metadata.fileName,
              fileExt: metadata.fileExt,
              fileSize: fileSize,
              fileHash: fileHash,
              mimeType: Value<String>(metadata.format.mimeType),
              coverImagePath: Value<String?>(coverImagePath),
              coverSourceType: Value<String>(
                coverImagePath == null ? 'none' : 'epub_embedded',
              ),
              charsetName: Value<String?>(parsedTxt?.charsetName),
              language: Value<String?>(_emptyToNull(parsedEpub?.language)),
              totalChapters: Value<int>(
                parsedTxt?.chapters.length ?? parsedEpub?.chapters.length ?? 0,
              ),
              totalWords: Value<int?>(
                parsedTxt?.totalWords ??
                    parsedEpub?.chapters.fold<int>(
                      0,
                      (int sum, EpubChapter chapter) => sum + chapter.wordCount,
                    ),
              ),
              importStatus: const Value<String>('ready'),
              createdAt: now,
              updatedAt: now,
            ),
          );
      if (parsedTxt != null) {
        await _insertTxtChapters(
          bookId: bookId,
          chapters: parsedTxt.chapters,
          createdAt: now,
        );
      }
      if (parsedEpub != null) {
        await _insertEpubChapters(
          bookId: bookId,
          chapters: parsedEpub.chapters,
          createdAt: now,
        );
      }
      await _insertImportRecord(
        sourcePath: sourcePath,
        fileName: metadata.fileName,
        fileHash: fileHash,
        detectedFormat: metadata.format.value,
        charsetName: parsedTxt?.charsetName,
        createdBookId: bookId,
        result: 'success',
        createdAt: now,
      );
      return BookImportItemResult(
        sourcePath: sourcePath,
        fileName: metadata.fileName,
        status: BookImportItemStatus.imported,
        message: '导入成功',
        format: metadata.format,
        bookId: bookId,
      );
    } on UnsupportedBookFormatException catch (error) {
      await _insertImportRecord(
        sourcePath: sourcePath,
        fileName: fallbackFileName,
        result: 'failed',
        errorCode: 'unsupported_format',
        errorMessage: '仅支持 TXT / EPUB：${error.fileName}',
        createdAt: now,
      );
      return BookImportItemResult(
        sourcePath: sourcePath,
        fileName: fallbackFileName,
        status: BookImportItemStatus.failed,
        message: '仅支持 TXT / EPUB',
      );
    } on Exception catch (error) {
      await _insertImportRecord(
        sourcePath: sourcePath,
        fileName: fallbackFileName,
        result: 'failed',
        errorCode: 'import_failed',
        errorMessage: error.toString(),
        createdAt: now,
      );
      return BookImportItemResult(
        sourcePath: sourcePath,
        fileName: fallbackFileName,
        status: BookImportItemStatus.failed,
        message: '导入失败',
      );
    }
  }

  Future<Book?> _findDuplicateByHash(String fileHash) {
    return (_database.select(_database.books)
          ..where((Books table) {
            return table.fileHash.equals(fileHash) & table.deletedAt.isNull();
          })
          ..limit(1))
        .getSingleOrNull();
  }

  Future<void> _insertImportRecord({
    required String sourcePath,
    required String fileName,
    required String result,
    required int createdAt,
    String? fileHash,
    String? detectedFormat,
    String? charsetName,
    String? duplicateBookId,
    String? errorCode,
    String? errorMessage,
    String? createdBookId,
  }) async {
    final String recordId = _hashService.compactId(
      '$createdAt|$sourcePath|$result|$createdBookId',
    );
    await _database
        .into(_database.importRecords)
        .insert(
          ImportRecordsCompanion.insert(
            id: recordId,
            sourcePath: sourcePath,
            fileName: fileName,
            fileHash: Value<String?>(fileHash),
            detectedFormat: Value<String?>(detectedFormat),
            charsetName: Value<String?>(charsetName),
            duplicateBookId: Value<String?>(duplicateBookId),
            result: result,
            errorCode: Value<String?>(errorCode),
            errorMessage: Value<String?>(errorMessage),
            createdBookId: Value<String?>(createdBookId),
            createdAt: createdAt,
          ),
        );
  }

  String _createBookId(String fileHash) {
    return 'book_${fileHash.substring(0, 20)}';
  }

  String _effectiveTitle(BookFileMetadata metadata, EpubParsedBook? epub) {
    return _emptyToNull(epub?.title) ?? metadata.title;
  }

  String _effectiveAuthor(BookFileMetadata metadata, EpubParsedBook? epub) {
    return _emptyToNull(epub?.author) ?? metadata.author;
  }

  String? _emptyToNull(String? value) {
    final String? trimmed = value?.trim();
    if (trimmed == null || trimmed.isEmpty) {
      return null;
    }
    return trimmed;
  }

  Future<void> _insertTxtChapters({
    required String bookId,
    required List<TxtChapter> chapters,
    required int createdAt,
  }) async {
    await _database.batch((Batch batch) {
      batch.insertAll(
        _database.bookChapters,
        chapters
            .map((TxtChapter chapter) {
              return BookChaptersCompanion.insert(
                id: '$bookId-chapter-${chapter.index}',
                bookId: bookId,
                chapterIndex: chapter.index,
                title: chapter.title,
                sourceType: 'txt',
                startOffset: Value<int>(chapter.startOffset),
                endOffset: Value<int>(chapter.endOffset),
                plainText: Value<String>(chapter.plainText),
                wordCount: Value<int>(chapter.wordCount),
                level: Value<int>(chapter.level),
                createdAt: createdAt,
                updatedAt: createdAt,
              );
            })
            .toList(growable: false),
      );
    });
  }

  Future<void> _insertEpubChapters({
    required String bookId,
    required List<EpubChapter> chapters,
    required int createdAt,
  }) async {
    await _database.batch((Batch batch) {
      batch.insertAll(
        _database.bookChapters,
        chapters
            .map((EpubChapter chapter) {
              return BookChaptersCompanion.insert(
                id: '$bookId-chapter-${chapter.index}',
                bookId: bookId,
                chapterIndex: chapter.index,
                title: chapter.title,
                sourceType: 'epub',
                href: Value<String>(chapter.href),
                anchor: Value<String?>(chapter.anchor),
                plainText: Value<String>(chapter.plainText),
                htmlContent: Value<String>(chapter.htmlContent),
                wordCount: Value<int>(chapter.wordCount),
                level: Value<int>(chapter.level),
                createdAt: createdAt,
                updatedAt: createdAt,
              );
            })
            .toList(growable: false),
      );
    });
  }
}
