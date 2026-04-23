import 'dart:io';

import 'package:drift/drift.dart' hide isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pocketread/data/database/app_database.dart';
import 'package:pocketread/data/repositories/bookshelf_repository.dart';
import 'package:pocketread/features/bookshelf/domain/bookshelf_book.dart';

void main() {
  late AppDatabase database;
  late BookshelfRepository repository;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    repository = BookshelfRepository(database: database);
  });

  tearDown(() async {
    await database.close();
  });

  test('watches ready non-deleted books with progress', () async {
    final int now = DateTime(2026, 4, 23).millisecondsSinceEpoch;
    await _insertBook(
      database,
      id: 'book-1',
      title: '测试书',
      author: '作者',
      now: now,
    );
    await database
        .into(database.readingProgress)
        .insert(
          ReadingProgressCompanion.insert(
            id: 'progress-1',
            bookId: 'book-1',
            currentChapterIndex: const Value<int>(2),
            progressPercent: const Value<double>(0.42),
            lastReadAt: now + 1000,
            updatedAt: now + 1000,
          ),
        );

    final List<BookshelfBook> books = await repository.watchBooks().first;

    expect(books, hasLength(1));
    expect(books.single.title, '测试书');
    expect(books.single.progressPercent, 0.42);
    expect(books.single.currentChapterIndex, 2);
    expect(books.single.progressLabel, '已读 42%');
  });

  test('persists favorite pinned read intent and delete actions', () async {
    final int now = DateTime(2026, 4, 23).millisecondsSinceEpoch;
    final Directory tempDir = await Directory.systemTemp.createTemp(
      'pocketread_delete_test',
    );
    addTearDown(() => tempDir.delete(recursive: true));
    final File localFile = File('${tempDir.path}/book.txt');
    final File coverFile = File('${tempDir.path}/cover.jpg');
    await localFile.writeAsString('book');
    await coverFile.writeAsString('cover');
    await _insertBook(
      database,
      id: 'book-1',
      title: '测试书',
      author: '作者',
      now: now,
      localFilePath: localFile.path,
      coverImagePath: coverFile.path,
    );
    await database
        .into(database.bookChapters)
        .insert(
          BookChaptersCompanion.insert(
            id: 'chapter-1',
            bookId: 'book-1',
            chapterIndex: 0,
            title: '第一章',
            sourceType: 'txt',
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
            updatedAt: now,
          ),
        );

    await repository.setFavorite('book-1', isFavorite: true);
    await repository.setPinned('book-1', isPinned: true);
    await repository.markReadIntent('book-1');

    Book book = await (database.select(
      database.books,
    )..where((Books table) => table.id.equals('book-1'))).getSingle();
    expect(book.isFavorite, isTrue);
    expect(book.pinnedAt, isNotNull);
    expect(book.lastReadAt, isNotNull);

    await repository.deleteBook('book-1');

    book = await (database.select(
      database.books,
    )..where((Books table) => table.id.equals('book-1'))).getSingle();
    expect(book.deletedAt, isNotNull);
    expect(await repository.watchBooks().first, isEmpty);
    expect(await database.select(database.bookChapters).get(), isEmpty);
    expect(await database.select(database.readingProgress).get(), isEmpty);
    expect(await database.select(database.bookReaderOverrides).get(), isEmpty);
    expect(await localFile.exists(), isFalse);
    expect(await coverFile.exists(), isFalse);
  });

  test('orders pinned books before recently read books', () async {
    final int now = DateTime(2026, 4, 23).millisecondsSinceEpoch;
    await _insertBook(
      database,
      id: 'book-old-pinned',
      title: '置顶书',
      author: '',
      now: now,
      pinnedAt: now - 1000,
    );
    await _insertBook(
      database,
      id: 'book-recent',
      title: '最近阅读',
      author: '',
      now: now + 2000,
      lastReadAt: now + 3000,
    );

    final List<BookshelfBook> books = await repository.watchBooks().first;

    expect(books.map((BookshelfBook book) => book.id), <String>[
      'book-old-pinned',
      'book-recent',
    ]);
  });
}

Future<void> _insertBook(
  AppDatabase database, {
  required String id,
  required String title,
  required String author,
  required int now,
  String? localFilePath,
  String? coverImagePath,
  int? pinnedAt,
  int? lastReadAt,
}) {
  return database
      .into(database.books)
      .insert(
        BooksCompanion.insert(
          id: id,
          format: 'txt',
          title: title,
          author: Value<String>(author),
          sourceFilePath: '/source/$id.txt',
          localFilePath: localFilePath ?? '/local/$id.txt',
          fileName: '$id.txt',
          fileExt: '.txt',
          fileSize: 10,
          fileHash: 'hash-$id',
          coverImagePath: Value<String?>(coverImagePath),
          totalChapters: const Value<int>(5),
          importStatus: const Value<String>('ready'),
          pinnedAt: Value<int?>(pinnedAt),
          lastReadAt: Value<int?>(lastReadAt),
          createdAt: now,
          updatedAt: now,
        ),
      );
}
