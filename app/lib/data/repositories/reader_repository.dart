import 'package:drift/drift.dart';
import 'package:pocketread/data/database/app_database.dart';
import 'package:pocketread/features/reader/domain/reader_models.dart';

class ReaderRepository {
  const ReaderRepository({required AppDatabase database})
    : _database = database;

  final AppDatabase _database;

  Future<ReaderBookDetail?> getBookDetail(String bookId) async {
    final Book? book =
        await (_database.select(_database.books)..where((Books table) {
              return table.id.equals(bookId) & table.deletedAt.isNull();
            }))
            .getSingleOrNull();
    if (book == null) {
      return null;
    }

    final List<BookChapter> chapters =
        await (_database.select(_database.bookChapters)
              ..where((BookChapters table) => table.bookId.equals(bookId))
              ..orderBy(<OrderingTerm Function(BookChapters)>[
                (BookChapters table) => OrderingTerm.asc(table.chapterIndex),
              ]))
            .get();
    final ReadingProgressData? progress =
        await (_database.select(_database.readingProgress)
              ..where((ReadingProgress table) => table.bookId.equals(bookId)))
            .getSingleOrNull();

    return ReaderBookDetail(
      book: ReaderBookModel(
        id: book.id,
        title: book.title,
        author: book.author,
        format: book.format,
        totalChapters: book.totalChapters,
        coverImagePath: book.coverImagePath,
      ),
      chapters: chapters
          .map(
            (BookChapter chapter) => ReaderChapterModel(
              id: chapter.id,
              chapterIndex: chapter.chapterIndex,
              title: chapter.title,
              sourceType: chapter.sourceType,
              href: chapter.href,
              anchor: chapter.anchor,
              startOffset: chapter.startOffset,
              endOffset: chapter.endOffset,
              plainText: chapter.plainText,
              htmlContent: chapter.htmlContent,
              wordCount: chapter.wordCount,
              level: chapter.level,
              parentId: chapter.parentId,
            ),
          )
          .toList(growable: false),
      progress: progress == null ? null : _mapProgress(progress),
    );
  }

  Future<ReaderSettingsModel> getReaderSettings() async {
    final ReaderPreference preference =
        await (_database.select(_database.readerPreferences)
              ..where((ReaderPreferences table) => table.id.equals(1)))
            .getSingle();

    return ReaderSettingsModel(
      themeMode: _mapThemeMode(preference.themeMode),
      backgroundStyleId: _mapBackgroundStyle(preference.backgroundColor),
      fontFamilyId: _mapFontFamily(preference.fontFamily),
      fontSize: preference.fontSize,
      lineHeight: preference.lineHeight,
      horizontalPadding: preference.horizontalPadding,
    );
  }

  Future<void> saveReaderSettings(ReaderSettingsModel settings) async {
    final int now = DateTime.now().millisecondsSinceEpoch;
    await _database
        .into(_database.readerPreferences)
        .insertOnConflictUpdate(
          ReaderPreferencesCompanion(
            id: const Value<int>(1),
            themeMode: Value<String>(_storageThemeMode(settings.themeMode)),
            backgroundColor: Value<String>(
              _storageBackgroundColor(settings.backgroundStyleId),
            ),
            fontFamily: Value<String>(_storageFontFamily(settings.fontFamilyId)),
            fontSize: Value<double>(settings.fontSize),
            lineHeight: Value<double>(settings.lineHeight),
            horizontalPadding: Value<double>(settings.horizontalPadding),
            updatedAt: Value<int>(now),
          ),
        );
  }

  Future<void> saveProgress({
    required String bookId,
    required int currentChapterIndex,
    required double progressPercent,
    required String locatorType,
    required int lastReadAtMillis,
    required int updatedAtMillis,
    int? chapterOffset,
    double? scrollOffset,
    String? locatorValue,
    int? startedAtMillis,
    int? totalReadingMinutes,
  }) async {
    final ReadingProgressData? existing =
        await (_database.select(_database.readingProgress)
              ..where((ReadingProgress table) => table.bookId.equals(bookId)))
            .getSingleOrNull();

    final int effectiveStartedAt =
        existing?.startedAt ?? startedAtMillis ?? lastReadAtMillis;
    final int effectiveMinutes =
        totalReadingMinutes ?? existing?.totalReadingMinutes ?? 0;

    await _database
        .into(_database.readingProgress)
        .insertOnConflictUpdate(
          ReadingProgressCompanion(
            id: Value<String>(existing?.id ?? 'progress_$bookId'),
            bookId: Value<String>(bookId),
            currentChapterIndex: Value<int>(currentChapterIndex),
            chapterOffset: Value<int?>(chapterOffset),
            scrollOffset: Value<double?>(scrollOffset),
            progressPercent: Value<double>(progressPercent),
            locatorType: Value<String>(locatorType),
            locatorValue: Value<String?>(locatorValue),
            startedAt: Value<int?>(effectiveStartedAt),
            lastReadAt: Value<int>(lastReadAtMillis),
            totalReadingMinutes: Value<int>(effectiveMinutes),
            updatedAt: Value<int>(updatedAtMillis),
          ),
        );

    await (_database.update(
      _database.books,
    )..where((Books table) => table.id.equals(bookId))).write(
      BooksCompanion(
        lastReadAt: Value<int>(lastReadAtMillis),
        updatedAt: Value<int>(updatedAtMillis),
      ),
    );
  }

  ReaderProgressModel _mapProgress(ReadingProgressData progress) {
    return ReaderProgressModel(
      currentChapterIndex: progress.currentChapterIndex,
      chapterOffset: progress.chapterOffset,
      scrollOffset: progress.scrollOffset,
      progressPercent: progress.progressPercent,
      locatorType: progress.locatorType,
      locatorValue: progress.locatorValue,
      startedAt: progress.startedAt == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(progress.startedAt!),
      lastReadAt: DateTime.fromMillisecondsSinceEpoch(progress.lastReadAt),
      totalReadingMinutes: progress.totalReadingMinutes,
      updatedAt: DateTime.fromMillisecondsSinceEpoch(progress.updatedAt),
    );
  }

  String _mapThemeMode(String value) {
    return switch (value) {
      'light' => 'day',
      'dark' => 'night',
      'system' => 'system',
      _ => 'day',
    };
  }

  String _storageThemeMode(String value) {
    return switch (value) {
      'day' => 'light',
      'night' => 'dark',
      'system' => 'system',
      _ => 'light',
    };
  }

  String _mapBackgroundStyle(String value) {
    return switch (value.toUpperCase()) {
      '#F6F1E9' => 'paper',
      '#F5F5F3' => 'mist',
      '#F3E2C5' => 'wheat',
      '#DCE6D5' => 'sage',
      '#D9D9DD' => 'fog',
      '#6B6B6D' => 'charcoal',
      '#111111' => 'midnight',
      _ => 'paper',
    };
  }

  String _storageBackgroundColor(String value) {
    return switch (value) {
      'paper' => '#F6F1E9',
      'mist' => '#F5F5F3',
      'wheat' => '#F3E2C5',
      'sage' => '#DCE6D5',
      'fog' => '#D9D9DD',
      'charcoal' => '#6B6B6D',
      'midnight' => '#111111',
      _ => '#F6F1E9',
    };
  }

  String _mapFontFamily(String value) {
    return switch (value) {
      'serif' => 'song',
      'sans-serif' => 'sans',
      'monospace' => 'mono',
      'system' => 'system',
      'source_song' => 'song',
      'lxgw' => 'wenkai',
      'zcool' => 'sans',
      'more' => 'mono',
      'song' => 'song',
      'kai' => 'wenkai',
      'wenkai' => 'wenkai',
      'sans' => 'sans',
      'mono' => 'mono',
      _ => 'system',
    };
  }

  String _storageFontFamily(String value) {
    return switch (value) {
      'system' => 'system',
      'song' => 'serif',
      'wenkai' => 'serif',
      'sans' => 'sans-serif',
      'mono' => 'monospace',
      _ => 'system',
    };
  }
}
