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
    tempDir = await Directory.systemTemp.createTemp(
      'pocketread_epub_import_test',
    );
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

  test('imports epub sample with metadata cover and chapters', () async {
    final BookImportItemResult result = await repository.importFile(
      '../电影教师_青城无忌.epub',
    );

    expect(result.status, BookImportItemStatus.imported);
    final Book book = (await database.select(database.books).get()).single;
    expect(book.title, '电影教师');
    expect(book.author, '青城无忌');
    expect(book.language, 'zh');
    expect(book.coverImagePath, isNotNull);
    expect(book.coverSourceType, 'epub_embedded');
    expect(book.totalChapters, greaterThan(100));
    expect(await File(book.coverImagePath!).exists(), isTrue);

    final List<BookChapter> chapters = await database
        .select(database.bookChapters)
        .get();
    expect(chapters.length, book.totalChapters);
    expect(chapters.first.sourceType, 'epub');
    expect(chapters.first.htmlContent, isNotNull);
    expect(
      chapters.any((BookChapter chapter) => chapter.title == '第1章 我成老师了'),
      isTrue,
    );
  });
}
