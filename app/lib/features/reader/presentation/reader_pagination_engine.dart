part of 'reader_page.dart';

class _ReaderPaginationEngine {
  static const int _maxChapterPaginationCacheEntries = 24;
  static final Map<String, List<_ReaderPageEntry>> _chapterPaginationCache =
      <String, List<_ReaderPageEntry>>{};

  static List<_ReaderPageEntry> buildChapterPages({
    required ReaderChapterModel chapter,
    required String text,
    required int globalReadableOffset,
    required _ReaderPageLayout layout,
    required TextStyle bodyStyle,
    required TextScaler textScaler,
  }) {
    final String readableText = text.trim();
    if (readableText.isEmpty) {
      return <_ReaderPageEntry>[
        _ReaderPageEntry(
          chapter: chapter,
          pageInChapter: 0,
          pageCountInChapter: 1,
          chapterTextStart: 0,
          chapterTextEnd: 6,
          globalReadableOffset: 0,
          content: '本章暂无正文内容',
          showsTitle: true,
        ),
      ];
    }

    final List<_ReaderTextSlice> slices = <_ReaderTextSlice>[];
    int start = 0;
    bool firstPage = true;

    while (start < readableText.length) {
      final double availableHeight = firstPage
          ? layout.firstPageBodyHeight
          : layout.followingPageBodyHeight;
      final int end = _findPageEnd(
        text: readableText,
        start: start,
        maxWidth: layout.contentWidth,
        maxHeight: availableHeight,
        style: bodyStyle,
        textScaler: textScaler,
      );
      slices.add(_ReaderTextSlice(start: start, end: end));
      start = _skipLeadingBreaks(readableText, end);
      firstPage = false;
    }

    final int pageCount = math.max(1, slices.length);
    return List<_ReaderPageEntry>.generate(pageCount, (int index) {
      final _ReaderTextSlice slice = slices[index];
      return _ReaderPageEntry(
        chapter: chapter,
        pageInChapter: index,
        pageCountInChapter: pageCount,
        chapterTextStart: slice.start,
        chapterTextEnd: slice.end,
        globalReadableOffset: globalReadableOffset,
        content: readableText.substring(slice.start, slice.end),
        showsTitle: index == 0,
      );
    }, growable: false);
  }

  static int pageIndexForChapterOffset(
    List<_ReaderPageEntry> pages,
    int chapterIndex,
    int chapterOffset,
  ) {
    final int index = pages.indexWhere((_ReaderPageEntry entry) {
      return entry.chapter.chapterIndex == chapterIndex &&
          chapterOffset >= entry.chapterTextStart &&
          chapterOffset < entry.chapterTextEnd;
    });
    if (index >= 0) {
      return index;
    }
    final int firstIndex = pages.indexWhere(
      (_ReaderPageEntry entry) => entry.chapter.chapterIndex == chapterIndex,
    );
    if (firstIndex < 0) {
      return -1;
    }
    final int lastIndex = pages.lastIndexWhere(
      (_ReaderPageEntry entry) => entry.chapter.chapterIndex == chapterIndex,
    );
    return chapterOffset <= pages[firstIndex].chapterTextStart
        ? firstIndex
        : lastIndex;
  }

  static List<_ReaderPageEntry>? cachedChapterPages(String cacheKey) {
    final List<_ReaderPageEntry>? cachedPages =
        _chapterPaginationCache[cacheKey];
    if (cachedPages == null) {
      return null;
    }
    touchChapterPagination(cacheKey, cachedPages);
    return cachedPages;
  }

  static bool hasCachedChapterPages(String cacheKey) {
    return _chapterPaginationCache.containsKey(cacheKey);
  }

  static void touchChapterPagination(
    String cacheKey,
    List<_ReaderPageEntry> pages,
  ) {
    _chapterPaginationCache.remove(cacheKey);
    _chapterPaginationCache[cacheKey] = pages;
    while (_chapterPaginationCache.length > _maxChapterPaginationCacheEntries) {
      _chapterPaginationCache.remove(_chapterPaginationCache.keys.first);
    }
  }

  static String paginationKey({
    required Size viewportSize,
    required _ReaderUiSettings settings,
    required TextScaler textScaler,
    required String bookId,
    required int chapterCount,
    required int totalReadableLength,
  }) {
    return <Object>[
      bookId,
      chapterCount,
      totalReadableLength,
      viewportSize.width.round(),
      viewportSize.height.round(),
      textScaler.scale(100).round(),
      settings.fontSize,
      settings.lineHeight,
      settings.pageMarginId,
      settings.fontId,
    ].join('|');
  }

  static String chapterPaginationKey(String signature, int chapterIndex) {
    return '$signature#$chapterIndex';
  }

  static List<int> availableWindowChapterIndices({
    required ReaderBookDetail detail,
    required int centerChapterIndex,
    required int lookAheadChapters,
  }) {
    final List<int> orderedIndices = <int>[];
    for (
      int chapterIndex = centerChapterIndex - 1;
      chapterIndex <= centerChapterIndex + lookAheadChapters;
      chapterIndex += 1
    ) {
      if (chapterIndex >= 0 && chapterIndex < detail.chapters.length) {
        orderedIndices.add(chapterIndex);
      }
    }
    return orderedIndices;
  }

  static List<int> missingWindowChapterIndices({
    required ReaderBookDetail detail,
    required List<_ReaderPageEntry> currentPages,
    required int centerChapterIndex,
    required int lookAheadChapters,
  }) {
    final Set<int> currentChapterIndices = windowChapterIndices(
      currentPages,
    ).toSet();
    return availableWindowChapterIndices(
          detail: detail,
          centerChapterIndex: centerChapterIndex,
          lookAheadChapters: lookAheadChapters,
        )
        .where((int chapterIndex) {
          return !currentChapterIndices.contains(chapterIndex);
        })
        .toList(growable: false);
  }

  static List<int> windowChapterIndices(List<_ReaderPageEntry> pages) {
    final List<int> chapterIndices = <int>[];
    int? previous;
    for (final _ReaderPageEntry entry in pages) {
      final int chapterIndex = entry.chapter.chapterIndex;
      if (previous == chapterIndex) {
        continue;
      }
      chapterIndices.add(chapterIndex);
      previous = chapterIndex;
    }
    return chapterIndices;
  }

  static String displayText(String value) {
    final List<String> lines = value
        .split('\n')
        .map((String item) => item.trimRight())
        .where((String item) => item.isNotEmpty)
        .toList(growable: false);
    if (lines.isEmpty) {
      return value;
    }
    return lines.join('\n');
  }

  static int _findPageEnd({
    required String text,
    required int start,
    required double maxWidth,
    required double maxHeight,
    required TextStyle style,
    required TextScaler textScaler,
  }) {
    int low = start + 1;
    int high = text.length;
    int best = low;
    while (low <= high) {
      final int middle = low + ((high - low) >> 1);
      if (_fitsPage(
        text.substring(start, middle),
        maxWidth,
        maxHeight,
        style,
        textScaler,
      )) {
        best = middle;
        low = middle + 1;
      } else {
        high = middle - 1;
      }
    }

    if (best >= text.length) {
      return text.length;
    }

    final int softBreak = _lastSoftBreak(text, start, best);
    if (softBreak > start) {
      return softBreak;
    }
    return best;
  }

  static bool _fitsPage(
    String value,
    double maxWidth,
    double maxHeight,
    TextStyle style,
    TextScaler textScaler,
  ) {
    final TextPainter painter = TextPainter(
      text: TextSpan(text: displayText(value), style: style),
      textAlign: TextAlign.justify,
      textDirection: TextDirection.ltr,
      textScaler: textScaler,
    )..layout(maxWidth: maxWidth);
    return painter.height <= maxHeight;
  }

  static int _lastSoftBreak(String text, int start, int best) {
    final int lowerBound = math.max(start, best - 80);
    for (int index = best; index > lowerBound; index -= 1) {
      final String char = text[index - 1];
      if (char == '\n' ||
          char == '。' ||
          char == '！' ||
          char == '？' ||
          char == '；' ||
          char == '，' ||
          char == '、' ||
          char == ' ' ||
          char == '.') {
        return index;
      }
    }
    return best;
  }

  static int _skipLeadingBreaks(String text, int offset) {
    int next = offset;
    while (next < text.length && text.codeUnitAt(next) <= 32) {
      next += 1;
    }
    return next;
  }
}
