import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pocketread/data/database/app_database.dart';
import 'package:pocketread/data/parsers/book_file_metadata_parser.dart';
import 'package:pocketread/data/parsers/epub_book_parser.dart';
import 'package:pocketread/data/parsers/txt_book_parser.dart';
import 'package:pocketread/data/parsers/txt_chapter_splitter.dart';
import 'package:pocketread/data/parsers/txt_encoding_decoder.dart';
import 'package:pocketread/data/parsers/txt_text_normalizer.dart';
import 'package:pocketread/data/repositories/book_import_repository.dart';
import 'package:pocketread/data/services/book_file_storage_service.dart';
import 'package:pocketread/data/services/file_hash_service.dart';
import 'package:pocketread/features/importer/domain/import_job.dart';

void main() {
  late Directory tempDir;
  late AppDatabase database;
  late BookImportRepository repository;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('pocketread_import_test');
    database = AppDatabase(NativeDatabase.memory());
    repository = BookImportRepository(
      database: database,
      metadataParser: const BookFileMetadataParser(),
      hashService: const FileHashService(),
      storageService: BookFileStorageService(
        rootDirectoryProvider: () async => tempDir,
      ),
      txtBookParser: const TxtBookParser(
        decoder: TxtEncodingDecoder(),
        normalizer: TxtTextNormalizer(),
        chapterSplitter: TxtChapterSplitter(),
      ),
      epubBookParser: const EpubBookParser(),
    );
  });

  tearDown(() async {
    await database.close();
    await tempDir.delete(recursive: true);
  });

  test('imports supported book and writes book plus import record', () async {
    final File sourceFile = File('${tempDir.path}/《唐砖》作者：孑与2.txt');
    await sourceFile.writeAsString('第一章 测试');

    final BookImportItemResult result = await repository.importFile(
      sourceFile.path,
    );

    expect(result.status, BookImportItemStatus.imported);
    final List<Book> books = await database.select(database.books).get();
    final List<ImportRecord> records = await database
        .select(database.importRecords)
        .get();
    expect(books, hasLength(1));
    expect(books.single.title, '唐砖');
    expect(books.single.author, '孑与2');
    expect(books.single.format, 'txt');
    expect(books.single.charsetName, 'utf-8');
    expect(books.single.totalChapters, 1);
    expect(await File(books.single.localFilePath).exists(), isTrue);
    final List<BookChapter> chapters = await database
        .select(database.bookChapters)
        .get();
    expect(chapters, hasLength(1));
    expect(chapters.single.title, '第一章 测试');
    expect(records.single.result, 'success');
  });

  test('detects duplicate by file hash and records duplicate result', () async {
    final File sourceFile = File('${tempDir.path}/book.txt');
    final File duplicateFile = File('${tempDir.path}/book_copy.txt');
    await sourceFile.writeAsString('same content');
    await duplicateFile.writeAsString('same content');

    final BookImportItemResult first = await repository.importFile(
      sourceFile.path,
    );
    final BookImportItemResult second = await repository.importFile(
      duplicateFile.path,
    );

    expect(first.status, BookImportItemStatus.imported);
    expect(second.status, BookImportItemStatus.duplicate);
    expect(second.duplicateBookId, first.bookId);
    final List<Book> books = await database.select(database.books).get();
    final List<ImportRecord> records = await database
        .select(database.importRecords)
        .get();
    expect(books, hasLength(1));
    expect(
      records.map((ImportRecord record) => record.result),
      containsAll(<String>['success', 'duplicate']),
    );
  });
}
