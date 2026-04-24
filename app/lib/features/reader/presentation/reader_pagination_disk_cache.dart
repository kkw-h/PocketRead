part of 'reader_page.dart';

class _ReaderPaginationDiskCache {
  const _ReaderPaginationDiskCache._();

  static const int _version = 1;
  static Directory? _rootDirectory;

  static Future<void> initialize(String bookId) async {
    try {
      final Directory cacheDirectory = await getTemporaryDirectory();
      final Directory rootDirectory = Directory(
        p.join(
          cacheDirectory.path,
          'reader_page_cache',
          _safePathSegment(bookId),
        ),
      );
      if (!rootDirectory.existsSync()) {
        await rootDirectory.create(recursive: true);
      }
      _rootDirectory = rootDirectory;
      _ReaderPerformanceLog.log(
        'pagination_disk_cache_ready',
        fields: <String, Object?>{'path': rootDirectory.path},
      );
    } catch (error) {
      _rootDirectory = null;
      _ReaderPerformanceLog.log(
        'pagination_disk_cache_unavailable',
        fields: <String, Object?>{'error': error.runtimeType},
      );
    }
  }

  static List<_ReaderPageEntry>? load({
    required String cacheKey,
    required ReaderChapterModel chapter,
    required int textLength,
  }) {
    final Directory? rootDirectory = _rootDirectory;
    if (rootDirectory == null) {
      return null;
    }
    final File file = File(_cacheFilePath(rootDirectory, cacheKey));
    if (!file.existsSync()) {
      return null;
    }

    return _ReaderPerformanceLog.track(
      'pagination_disk_cache_read',
      () {
        try {
          final Object? decoded = jsonDecode(file.readAsStringSync());
          if (decoded is! Map<String, Object?>) {
            return null;
          }
          if (decoded['version'] != _version ||
              decoded['cacheKey'] != cacheKey ||
              decoded['chapterId'] != chapter.id ||
              decoded['textLength'] != textLength) {
            return null;
          }
          final Object? pagesJson = decoded['pages'];
          if (pagesJson is! List<Object?> || pagesJson.isEmpty) {
            return null;
          }
          final List<_ReaderPageEntry> pages = <_ReaderPageEntry>[];
          for (final Object? pageJson in pagesJson) {
            if (pageJson is! Map<String, Object?>) {
              return null;
            }
            final int pageCount =
                (pageJson['pageCountInChapter'] as int?) ?? pagesJson.length;
            pages.add(
              _ReaderPageEntry(
                chapter: chapter,
                pageInChapter: pageJson['pageInChapter'] as int,
                pageCountInChapter: pageCount,
                chapterTextStart: pageJson['chapterTextStart'] as int,
                chapterTextEnd: pageJson['chapterTextEnd'] as int,
                globalReadableOffset: pageJson['globalReadableOffset'] as int,
                content: pageJson['content'] as String,
                showsTitle: pageJson['showsTitle'] as bool,
              ),
            );
          }
          return pages;
        } catch (error) {
          _ReaderPerformanceLog.log(
            'pagination_disk_cache_read_failed',
            fields: <String, Object?>{
              'chapterIndex': chapter.chapterIndex,
              'error': error.runtimeType,
            },
          );
          return null;
        }
      },
      fields: <String, Object?>{'chapterIndex': chapter.chapterIndex},
    );
  }

  static void store({
    required String cacheKey,
    required ReaderChapterModel chapter,
    required int textLength,
    required List<_ReaderPageEntry> pages,
  }) {
    final Directory? rootDirectory = _rootDirectory;
    if (rootDirectory == null || pages.isEmpty) {
      return;
    }
    final File file = File(_cacheFilePath(rootDirectory, cacheKey));
    final Map<String, Object?> payload = <String, Object?>{
      'version': _version,
      'cacheKey': cacheKey,
      'chapterId': chapter.id,
      'chapterIndex': chapter.chapterIndex,
      'textLength': textLength,
      'pages': pages
          .map((_ReaderPageEntry page) {
            return <String, Object?>{
              'pageInChapter': page.pageInChapter,
              'pageCountInChapter': page.pageCountInChapter,
              'chapterTextStart': page.chapterTextStart,
              'chapterTextEnd': page.chapterTextEnd,
              'globalReadableOffset': page.globalReadableOffset,
              'content': page.content,
              'showsTitle': page.showsTitle,
            };
          })
          .toList(growable: false),
    };

    unawaited(
      file
          .writeAsString(jsonEncode(payload), flush: false)
          .then((_) {
            _ReaderPerformanceLog.log(
              'pagination_disk_cache_write',
              fields: <String, Object?>{
                'chapterIndex': chapter.chapterIndex,
                'pages': pages.length,
              },
            );
          })
          .catchError((Object error) {
            _ReaderPerformanceLog.log(
              'pagination_disk_cache_write_failed',
              fields: <String, Object?>{
                'chapterIndex': chapter.chapterIndex,
                'error': error.runtimeType,
              },
            );
          }),
    );
  }

  static String _cacheFilePath(Directory rootDirectory, String cacheKey) {
    final String digest = sha1.convert(utf8.encode(cacheKey)).toString();
    return p.join(rootDirectory.path, '$digest.json');
  }

  static String _safePathSegment(String value) {
    return value.replaceAll(RegExp(r'[^a-zA-Z0-9_.-]'), '_');
  }
}
