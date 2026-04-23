import 'dart:io';

import 'package:drift/drift.dart';
import 'package:pocketread/data/database/app_database.dart';
import 'package:pocketread/features/bookshelf/domain/bookshelf_book.dart';

class BookshelfRepository {
  const BookshelfRepository({required AppDatabase database})
    : _database = database;

  final AppDatabase _database;

  Stream<List<BookshelfBook>> watchBooks() {
    return _database
        .customSelect(
          '''
          SELECT
            b.id,
            b.title,
            b.author,
            b.format,
            b.cover_image_path,
            b.total_chapters,
            b.is_favorite,
            b.pinned_at,
            b.created_at,
            b.updated_at,
            b.last_read_at AS book_last_read_at,
            p.current_chapter_index,
            p.progress_percent,
            p.last_read_at AS progress_last_read_at
          FROM books b
          LEFT JOIN reading_progress p ON p.book_id = b.id
          WHERE b.deleted_at IS NULL AND b.import_status = ?
          ORDER BY
            CASE WHEN b.pinned_at IS NULL THEN 1 ELSE 0 END ASC,
            b.pinned_at DESC,
            COALESCE(p.last_read_at, b.last_read_at, b.created_at) DESC
          ''',
          variables: <Variable<Object>>[const Variable<String>('ready')],
          readsFrom: <ResultSetImplementation<Table, Object?>>{
            _database.books,
            _database.readingProgress,
          },
        )
        .watch()
        .map(
          (List<QueryRow> rows) =>
              rows.map(_mapBookshelfBook).toList(growable: false),
        );
  }

  Future<void> setFavorite(String bookId, {required bool isFavorite}) async {
    await (_database.update(
      _database.books,
    )..where((Books table) => table.id.equals(bookId))).write(
      BooksCompanion(
        isFavorite: Value<bool>(isFavorite),
        updatedAt: Value<int>(_nowMillis()),
      ),
    );
  }

  Future<void> setPinned(String bookId, {required bool isPinned}) async {
    final int now = _nowMillis();
    await (_database.update(
      _database.books,
    )..where((Books table) => table.id.equals(bookId))).write(
      BooksCompanion(
        pinnedAt: Value<int?>(isPinned ? now : null),
        updatedAt: Value<int>(now),
      ),
    );
  }

  Future<void> markReadIntent(String bookId) async {
    final int now = _nowMillis();
    await (_database.update(
      _database.books,
    )..where((Books table) => table.id.equals(bookId))).write(
      BooksCompanion(lastReadAt: Value<int>(now), updatedAt: Value<int>(now)),
    );
  }

  Future<void> deleteBook(String bookId) async {
    final Book? book = await (_database.select(
      _database.books,
    )..where((Books table) => table.id.equals(bookId))).getSingleOrNull();
    if (book == null) {
      return;
    }

    final int now = _nowMillis();
    await _database.transaction(() async {
      await (_database.delete(
        _database.bookChapters,
      )..where((BookChapters table) => table.bookId.equals(bookId))).go();
      await (_database.delete(
        _database.readingProgress,
      )..where((ReadingProgress table) => table.bookId.equals(bookId))).go();
      await (_database.delete(_database.bookReaderOverrides)
            ..where((BookReaderOverrides table) => table.bookId.equals(bookId)))
          .go();
      await (_database.update(
        _database.books,
      )..where((Books table) => table.id.equals(bookId))).write(
        BooksCompanion(deletedAt: Value<int>(now), updatedAt: Value<int>(now)),
      );
    });

    await _deleteFileIfExists(book.localFilePath);
    await _deleteFileIfExists(book.coverImagePath);
  }

  BookshelfBook _mapBookshelfBook(QueryRow row) {
    final int? progressLastReadAt = row.readNullable<int>(
      'progress_last_read_at',
    );
    final int? bookLastReadAt = row.readNullable<int>('book_last_read_at');
    return BookshelfBook(
      id: row.read<String>('id'),
      title: row.read<String>('title'),
      author: row.read<String>('author'),
      format: row.read<String>('format'),
      coverImagePath: row.readNullable<String>('cover_image_path'),
      progressPercent: row.readNullable<double>('progress_percent') ?? 0,
      currentChapterIndex: row.readNullable<int>('current_chapter_index') ?? 0,
      totalChapters: row.read<int>('total_chapters'),
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        row.read<int>('created_at'),
      ),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(
        row.read<int>('updated_at'),
      ),
      lastReadAt: _dateTimeFromMillis(progressLastReadAt ?? bookLastReadAt),
      isFavorite: row.read<bool>('is_favorite'),
      isPinned: row.readNullable<int>('pinned_at') != null,
    );
  }

  DateTime? _dateTimeFromMillis(int? millis) {
    if (millis == null) {
      return null;
    }
    return DateTime.fromMillisecondsSinceEpoch(millis);
  }

  int _nowMillis() => DateTime.now().millisecondsSinceEpoch;

  Future<void> _deleteFileIfExists(String? path) async {
    if (path == null || path.isEmpty) {
      return;
    }
    final File file = File(path);
    if (await file.exists()) {
      await file.delete();
    }
  }
}
