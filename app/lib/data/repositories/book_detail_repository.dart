import 'package:drift/drift.dart';
import 'package:intl/intl.dart';
import 'package:pocketread/data/database/app_database.dart';
import 'package:pocketread/features/book_detail/domain/book_detail_model.dart';

class BookDetailRepository {
  BookDetailRepository({required AppDatabase database}) : _database = database;

  final AppDatabase _database;
  final DateFormat _dateFormat = DateFormat('yyyy/MM/dd HH:mm');

  Future<BookDetailModel?> getBookDetail(String bookId) async {
    final Book? book =
        await (_database.select(_database.books)..where((Books table) {
              return table.id.equals(bookId) & table.deletedAt.isNull();
            }))
            .getSingleOrNull();
    if (book == null) {
      return null;
    }

    final ReadingProgressData? progress =
        await (_database.select(_database.readingProgress)
              ..where((ReadingProgress table) => table.bookId.equals(bookId)))
            .getSingleOrNull();
    final BookChapter? currentChapter = progress == null
        ? null
        : await (_database.select(_database.bookChapters)
                ..where((BookChapters table) {
                  return table.bookId.equals(bookId) &
                      table.chapterIndex.equals(progress.currentChapterIndex);
                }))
              .getSingleOrNull();
    final ImportRecord? importRecord =
        await (_database.select(_database.importRecords)
              ..where(
                (ImportRecords table) => table.createdBookId.equals(bookId),
              )
              ..orderBy(<OrderingTerm Function(ImportRecords)>[
                (ImportRecords table) => OrderingTerm.desc(table.createdAt),
              ])
              ..limit(1))
            .getSingleOrNull();

    final String progressLabel = progress == null
        ? '未读'
        : '已读 ${(progress.progressPercent * 100).round()}%';

    return BookDetailModel(
      id: book.id,
      title: book.title,
      author: book.author,
      format: book.format.toUpperCase(),
      sourceFilePath: book.sourceFilePath,
      localFilePath: book.localFilePath,
      fileName: book.fileName,
      fileSizeLabel: _formatFileSize(book.fileSize),
      fileHash: book.fileHash,
      coverImagePath: book.coverImagePath,
      coverSourceType: book.coverSourceType,
      charsetName: book.charsetName,
      language: book.language,
      totalChapters: book.totalChapters,
      totalWords: book.totalWords,
      isFavorite: book.isFavorite,
      isPinned: book.pinnedAt != null,
      importStatus: book.importStatus,
      createdAtLabel: _formatMillis(book.createdAt),
      updatedAtLabel: _formatMillis(book.updatedAt),
      lastReadAtLabel: _formatNullableMillis(book.lastReadAt),
      progressPercent: progress?.progressPercent ?? 0,
      progressLabel: progressLabel,
      lastReadChapterLabel: currentChapter?.title,
      importRecordLabel: importRecord == null
          ? '暂无导入记录'
          : '${importRecord.result} · ${_formatMillis(importRecord.createdAt)}',
      description: book.description?.trim().isNotEmpty == true
          ? book.description
          : null,
    );
  }

  String _formatMillis(int millis) {
    return _dateFormat.format(DateTime.fromMillisecondsSinceEpoch(millis));
  }

  String? _formatNullableMillis(int? millis) {
    if (millis == null) {
      return null;
    }
    return _formatMillis(millis);
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    }
    if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    }
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}
