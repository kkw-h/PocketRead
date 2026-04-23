import 'package:drift/drift.dart' hide isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pocketread/data/database/app_database.dart';
import 'package:pocketread/data/repositories/reader_repository.dart';
import 'package:pocketread/features/reader/domain/reader_models.dart';

void main() {
  late AppDatabase database;
  late ReaderRepository repository;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    repository = ReaderRepository(database: database);
  });

  tearDown(() async {
    await database.close();
  });

  test('loads reader detail with ordered chapters and progress', () async {
    final int now = DateTime(2026, 4, 23).millisecondsSinceEpoch;
    await _insertBook(database, now: now);
    await database.batch((Batch batch) {
      batch.insertAll(database.bookChapters, <BookChaptersCompanion>[
        BookChaptersCompanion.insert(
          id: 'chapter-2',
          bookId: 'book-1',
          chapterIndex: 1,
          title: '第二章',
          sourceType: 'txt',
          plainText: const Value<String>('第二章正文'),
          createdAt: now,
          updatedAt: now,
        ),
        BookChaptersCompanion.insert(
          id: 'chapter-1',
          bookId: 'book-1',
          chapterIndex: 0,
          title: '第一章',
          sourceType: 'txt',
          plainText: const Value<String>('第一章正文'),
          createdAt: now,
          updatedAt: now,
        ),
      ]);
    });
    await repository.saveProgress(
      bookId: 'book-1',
      currentChapterIndex: 1,
      chapterOffset: 120,
      scrollOffset: 240,
      progressPercent: 0.66,
      locatorType: 'txt_offset',
      locatorValue: '120',
      lastReadAtMillis: now + 2000,
      updatedAtMillis: now + 2000,
      totalReadingMinutes: 8,
    );

    final detail = await repository.getBookDetail('book-1');

    expect(detail, isNotNull);
    expect(detail!.chapters.map((chapter) => chapter.title), <String>[
      '第一章',
      '第二章',
    ]);
    expect(detail.progress, isNotNull);
    expect(detail.progress!.currentChapterIndex, 1);
    expect(detail.progress!.scrollOffset, 240);
    expect(detail.progress!.locatorType, 'txt_offset');
  });

  test(
    'save progress upserts reading progress and updates book last read',
    () async {
      final int now = DateTime(2026, 4, 23).millisecondsSinceEpoch;
      await _insertBook(database, now: now);

      await repository.saveProgress(
        bookId: 'book-1',
        currentChapterIndex: 0,
        chapterOffset: 30,
        scrollOffset: 40,
        progressPercent: 0.2,
        locatorType: 'txt_offset',
        locatorValue: '30',
        lastReadAtMillis: now + 1000,
        updatedAtMillis: now + 1000,
        totalReadingMinutes: 2,
      );
      await repository.saveProgress(
        bookId: 'book-1',
        currentChapterIndex: 1,
        chapterOffset: 80,
        scrollOffset: 120,
        progressPercent: 0.5,
        locatorType: 'txt_offset',
        locatorValue: '80',
        lastReadAtMillis: now + 3000,
        updatedAtMillis: now + 3000,
        totalReadingMinutes: 6,
      );

      final progressList = await database
          .select(database.readingProgress)
          .get();
      final book = await (database.select(
        database.books,
      )..where((Books table) => table.id.equals('book-1'))).getSingle();

      expect(progressList, hasLength(1));
      expect(progressList.single.currentChapterIndex, 1);
      expect(progressList.single.scrollOffset, 120);
      expect(progressList.single.totalReadingMinutes, 6);
      expect(book.lastReadAt, now + 3000);
    },
  );

  test('saves and reloads reader settings', () async {
    final ReaderSettingsModel defaults = await repository.getReaderSettings();

    expect(defaults.themeMode, 'system');
    expect(defaults.backgroundStyleId, 'paper');
    expect(defaults.fontFamilyId, 'system');

    await repository.saveReaderSettings(
      const ReaderSettingsModel(
        themeMode: 'night',
        backgroundStyleId: 'midnight',
        fontFamilyId: 'mono',
        fontSize: 22,
        lineHeight: 2,
        horizontalPadding: 38,
      ),
    );

    final ReaderSettingsModel saved = await repository.getReaderSettings();

    expect(saved.themeMode, 'night');
    expect(saved.backgroundStyleId, 'midnight');
    expect(saved.fontFamilyId, 'mono');
    expect(saved.fontSize, 22);
    expect(saved.lineHeight, 2);
    expect(saved.horizontalPadding, 38);
  });
}

Future<void> _insertBook(AppDatabase database, {required int now}) {
  return database
      .into(database.books)
      .insert(
        BooksCompanion.insert(
          id: 'book-1',
          format: 'txt',
          title: '测试书籍',
          sourceFilePath: '/source/book.txt',
          localFilePath: '/local/book.txt',
          fileName: 'book.txt',
          fileExt: '.txt',
          fileSize: 12,
          fileHash: 'hash-1',
          totalChapters: const Value<int>(2),
          createdAt: now,
          updatedAt: now,
        ),
      );
}
