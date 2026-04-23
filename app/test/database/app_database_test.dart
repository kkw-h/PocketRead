import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pocketread/data/database/app_database.dart';

void main() {
  late AppDatabase database;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await database.close();
  });

  test('creates default reader preferences row', () async {
    final List<ReaderPreference> preferences = await database
        .select(database.readerPreferences)
        .get();

    expect(preferences, hasLength(1));
    expect(preferences.single.id, 1);
    expect(preferences.single.themeMode, 'system');
    expect(preferences.single.backgroundColor, '#F6F1E9');
    expect(preferences.single.fontSize, 18);
    expect(preferences.single.lineHeight, 1.6);
  });

  test(
    'persists core book chapter progress settings and import entities',
    () async {
      final int now = DateTime(2026, 1, 1).millisecondsSinceEpoch;
      await _insertBook(database, now: now);

      await database
          .into(database.bookChapters)
          .insert(
            BookChaptersCompanion.insert(
              id: 'chapter-1',
              bookId: 'book-1',
              chapterIndex: 0,
              title: '第一章',
              sourceType: 'txt',
              plainText: const Value<String>('正文'),
              createdAt: now,
              updatedAt: now,
            ),
          );
      await database
          .into(database.readingProgress)
          .insert(
            ReadingProgressCompanion.insert(
              id: 'progress-1',
              bookId: 'book-1',
              currentChapterIndex: const Value<int>(0),
              chapterOffset: const Value<int>(2),
              progressPercent: const Value<double>(0.25),
              lastReadAt: now,
              updatedAt: now,
            ),
          );
      await database
          .into(database.bookReaderOverrides)
          .insert(
            BookReaderOverridesCompanion.insert(
              id: 'override-1',
              bookId: 'book-1',
              fontSize: const Value<double>(20),
              backgroundColor: const Value<String>('#FFFFFF'),
              updatedAt: now,
            ),
          );
      await database
          .into(database.importRecords)
          .insert(
            ImportRecordsCompanion.insert(
              id: 'record-1',
              sourcePath: '/source/book.txt',
              fileName: 'book.txt',
              fileHash: const Value<String>('hash-1'),
              detectedFormat: const Value<String>('txt'),
              result: 'success',
              createdBookId: const Value<String>('book-1'),
              createdAt: now,
            ),
          );

      expect(await database.select(database.books).get(), hasLength(1));
      expect(await database.select(database.bookChapters).get(), hasLength(1));
      expect(
        await database.select(database.readingProgress).get(),
        hasLength(1),
      );
      expect(
        await database.select(database.bookReaderOverrides).get(),
        hasLength(1),
      );
      expect(await database.select(database.importRecords).get(), hasLength(1));
    },
  );

  test('enforces chapter and progress uniqueness constraints', () async {
    final int now = DateTime(2026, 1, 1).millisecondsSinceEpoch;
    await _insertBook(database, now: now);

    final BookChaptersCompanion chapter = BookChaptersCompanion.insert(
      id: 'chapter-1',
      bookId: 'book-1',
      chapterIndex: 0,
      title: '第一章',
      sourceType: 'txt',
      createdAt: now,
      updatedAt: now,
    );
    await database.into(database.bookChapters).insert(chapter);

    expect(
      database
          .into(database.bookChapters)
          .insert(chapter.copyWith(id: const Value<String>('chapter-2'))),
      throwsA(anything),
    );

    final ReadingProgressCompanion progress = ReadingProgressCompanion.insert(
      id: 'progress-1',
      bookId: 'book-1',
      lastReadAt: now,
      updatedAt: now,
    );
    await database.into(database.readingProgress).insert(progress);

    expect(
      database
          .into(database.readingProgress)
          .insert(progress.copyWith(id: const Value<String>('progress-2'))),
      throwsA(anything),
    );
  });

  test('enforces foreign keys for dependent tables', () async {
    final int now = DateTime(2026, 1, 1).millisecondsSinceEpoch;

    expect(
      database
          .into(database.bookChapters)
          .insert(
            BookChaptersCompanion.insert(
              id: 'orphan-chapter',
              bookId: 'missing-book',
              chapterIndex: 0,
              title: '孤章',
              sourceType: 'txt',
              createdAt: now,
              updatedAt: now,
            ),
          ),
      throwsA(anything),
    );

    expect(
      database
          .into(database.readingProgress)
          .insert(
            ReadingProgressCompanion.insert(
              id: 'orphan-progress',
              bookId: 'missing-book',
              lastReadAt: now,
              updatedAt: now,
            ),
          ),
      throwsA(anything),
    );
  });

  test('creates v1 query indexes', () async {
    await database.customSelect('SELECT 1').get();

    final List<String> expectedIndexes = <String>[
      'idx_books_file_hash',
      'idx_books_last_read_at',
      'idx_books_pinned_at',
      'idx_books_title',
      'idx_book_chapters_book_id_index',
      'idx_book_chapters_book_id_parent_id',
      'idx_import_records_file_hash',
      'idx_import_records_created_at',
      'idx_import_records_created_book_id',
      'idx_import_records_duplicate_book_id',
    ];
    final String placeholders = expectedIndexes.map((_) => '?').join(', ');
    final List<QueryRow> rows = await database
        .customSelect(
          'SELECT name FROM sqlite_master '
          'WHERE type = ? AND name IN ($placeholders)',
          variables: <Variable<Object>>[
            const Variable<String>('index'),
            ...expectedIndexes.map(Variable<String>.new),
          ],
        )
        .get();

    final Set<String> actualIndexes = rows
        .map((QueryRow row) => row.read<String>('name'))
        .toSet();
    expect(actualIndexes, containsAll(expectedIndexes));
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
          createdAt: now,
          updatedAt: now,
        ),
      );
}
