import 'package:drift/drift.dart';
import 'package:intl/intl.dart';
import 'package:pocketread/data/database/app_database.dart';
import 'package:pocketread/features/book_detail/domain/book_detail_model.dart';

class BookDetailRepository {
  BookDetailRepository({required AppDatabase database}) : _database = database;

  final AppDatabase _database;
  final DateFormat _dateFormat = DateFormat('yyyy/MM/dd HH:mm');

  Future<BookDetailModel?> getBookDetail(String bookId) async {
    final QueryRow? row = await _database
        .customSelect(
          '''
          SELECT
            b.id,
            b.title,
            b.author,
            b.format,
            b.source_file_path,
            b.local_file_path,
            b.file_name,
            b.file_size,
            b.file_hash,
            b.cover_image_path,
            b.cover_source_type,
            b.charset_name,
            b.language,
            b.total_chapters,
            b.total_words,
            b.is_favorite,
            b.pinned_at,
            b.import_status,
            b.created_at,
            b.updated_at,
            b.last_read_at,
            b.description,
            p.current_chapter_index,
            p.progress_percent
          FROM books b
          LEFT JOIN reading_progress p ON p.book_id = b.id
          WHERE b.id = ? AND b.deleted_at IS NULL
          LIMIT 1
          ''',
          variables: <Variable<Object>>[Variable<String>(bookId)],
          readsFrom: <ResultSetImplementation<Table, Object?>>{
            _database.books,
            _database.readingProgress,
          },
        )
        .getSingleOrNull();
    if (row == null) {
      return null;
    }

    final double progressPercent = row.readNullable<double>('progress_percent') ?? 0;
    final int? currentChapterIndex = row.readNullable<int>('current_chapter_index');
    final BookChapter? currentChapter = currentChapterIndex == null
        ? null
        : await (_database.select(_database.bookChapters)
                ..where((BookChapters table) {
                  return table.bookId.equals(bookId) &
                      table.chapterIndex.equals(currentChapterIndex);
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

    final String progressLabel = progressPercent <= 0
        ? '未读'
        : '已读 ${(progressPercent * 100).round()}%';

    return BookDetailModel(
      id: row.read<String>('id'),
      title: row.read<String>('title'),
      author: row.read<String>('author'),
      format: row.read<String>('format').toUpperCase(),
      sourceFilePath: row.read<String>('source_file_path'),
      localFilePath: row.read<String>('local_file_path'),
      fileName: row.read<String>('file_name'),
      fileSizeLabel: _formatFileSize(row.read<int>('file_size')),
      fileHash: row.read<String>('file_hash'),
      coverImagePath: row.readNullable<String>('cover_image_path'),
      coverSourceType: row.readNullable<String>('cover_source_type'),
      charsetName: row.readNullable<String>('charset_name'),
      language: row.readNullable<String>('language'),
      totalChapters: row.read<int>('total_chapters'),
      totalWords: row.readNullable<int>('total_words'),
      isFavorite: row.read<bool>('is_favorite'),
      isPinned: row.readNullable<int>('pinned_at') != null,
      importStatus: row.read<String>('import_status'),
      createdAtLabel: _formatMillis(row.read<int>('created_at')),
      updatedAtLabel: _formatMillis(row.read<int>('updated_at')),
      lastReadAtLabel: _formatNullableMillis(row.readNullable<int>('last_read_at')),
      progressPercent: progressPercent,
      progressLabel: progressLabel,
      lastReadChapterLabel: currentChapter?.title,
      importRecordLabel: importRecord == null
          ? '暂无导入记录'
          : '${importRecord.result} · ${_formatMillis(importRecord.createdAt)}',
      description: row.readNullable<String>('description')?.trim().isNotEmpty == true
          ? row.readNullable<String>('description')
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
