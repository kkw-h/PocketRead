import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:pocketread/data/repositories/reader_repository.dart';
import 'package:pocketread/features/reader/domain/reader_models.dart';

const double _readerWarmupTopPadding = 44;
const double _readerWarmupBottomPadding = 48;
const double _readerWarmupHeaderGap = 12;
const double _readerWarmupDisplayTitleGap = 20;

class ReaderLaunchWarmupService {
  ReaderLaunchWarmupService({required ReaderRepository repository})
    : _repository = repository;

  final ReaderRepository _repository;
  final Map<String, ReaderWarmupResult> _preparedLaunches =
      <String, ReaderWarmupResult>{};

  Future<ReaderWarmupResult?> warmUpBook({
    required String bookId,
    required Size viewportSize,
    required TextScaler textScaler,
  }) async {
    final ReaderSettingsModel settings = await _repository.getReaderSettings();
    final ReaderBookDetail? detail = await _repository.getBookDetail(bookId);
    if (detail == null || detail.chapters.isEmpty) {
      return null;
    }

    final int chapterIndex = _restoreChapterIndex(detail.progress);
    final ReaderChapterModel chapter =
        detail.chapters.firstWhere(
          (ReaderChapterModel item) => item.chapterIndex == chapterIndex,
          orElse: () => detail.chapters.first,
        );
    final int chapterTextOffset = _restoreChapterTextOffset(
      detail.progress,
      chapter,
    );
    final String signature = buildPaginationSignature(
      viewportSize: viewportSize,
      textScaler: textScaler,
      bookId: detail.book.id,
      chapterCount: detail.chapters.length,
      totalReadableLength: _totalReadableLength(detail.chapters),
      settings: settings,
    );
    final List<ReaderWarmupPageData> pages = _buildChapterPages(
      chapter: chapter,
      settings: settings,
      viewportSize: viewportSize,
      textScaler: textScaler,
      globalReadableOffset: _readableOffsetBeforeChapter(
        detail.chapters,
        chapter.chapterIndex,
      ),
    );
    final int initialPageIndex = _pageIndexForChapterOffset(
      pages,
      chapterTextOffset,
    );

    final ReaderWarmupResult result = ReaderWarmupResult(
      bookId: bookId,
      signature: signature,
      chapterIndex: chapter.chapterIndex,
      initialPageIndex: initialPageIndex,
      pages: pages,
    );
    _preparedLaunches[bookId] = result;
    return result;
  }

  ReaderWarmupResult? takePreparedLaunch({
    required String bookId,
    required String signature,
  }) {
    final ReaderWarmupResult? result = _preparedLaunches[bookId];
    if (result == null || result.signature != signature) {
      return null;
    }
    _preparedLaunches.remove(bookId);
    return result;
  }

  static String buildPaginationSignature({
    required Size viewportSize,
    required TextScaler textScaler,
    required String bookId,
    required int chapterCount,
    required int totalReadableLength,
    required ReaderSettingsModel settings,
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
      _pageMarginIdForPadding(settings.horizontalPadding),
      settings.fontFamilyId,
    ].join('|');
  }

  static String _pageMarginIdForPadding(double horizontalPadding) {
    if (horizontalPadding <= 20) {
      return 'compact';
    }
    if (horizontalPadding <= 26) {
      return 'comfort';
    }
    if (horizontalPadding <= 32) {
      return 'relaxed';
    }
    if (horizontalPadding <= 38) {
      return 'wide';
    }
    return 'extra';
  }

  int _restoreChapterIndex(ReaderProgressModel? progress) {
    final String? locatorValue = progress?.locatorValue;
    if (locatorValue != null) {
      final RegExpMatch? offsetMatch = RegExp(
        r'^offset:(\d+):(\d+)$',
      ).firstMatch(locatorValue);
      if (offsetMatch != null) {
        return int.tryParse(offsetMatch.group(1) ?? '') ?? 0;
      }
    }
    return progress?.currentChapterIndex ?? 0;
  }

  int _restoreChapterTextOffset(
    ReaderProgressModel? progress,
    ReaderChapterModel chapter,
  ) {
    final String? locatorValue = progress?.locatorValue;
    if (locatorValue != null) {
      final RegExpMatch? offsetMatch = RegExp(
        r'^offset:(\d+):(\d+)$',
      ).firstMatch(locatorValue);
      if (offsetMatch != null) {
        return int.tryParse(offsetMatch.group(2) ?? '') ?? 0;
      }
    }

    final int? chapterOffset = progress?.chapterOffset;
    if (chapterOffset == null) {
      return 0;
    }
    return (chapterOffset - (chapter.startOffset ?? 0)).clamp(
      0,
      _readableText(chapter).length,
    );
  }

  int _totalReadableLength(List<ReaderChapterModel> chapters) {
    int total = 0;
    for (final ReaderChapterModel chapter in chapters) {
      total += _readableText(chapter).trim().length;
    }
    return total;
  }

  int _readableOffsetBeforeChapter(
    List<ReaderChapterModel> chapters,
    int chapterIndex,
  ) {
    int total = 0;
    for (final ReaderChapterModel chapter in chapters) {
      if (chapter.chapterIndex == chapterIndex) {
        return total;
      }
      total += _readableText(chapter).trim().length;
    }
    return total;
  }

  List<ReaderWarmupPageData> _buildChapterPages({
    required ReaderChapterModel chapter,
    required ReaderSettingsModel settings,
    required Size viewportSize,
    required TextScaler textScaler,
    required int globalReadableOffset,
  }) {
    final String text = _readableText(chapter).trim();
    if (text.isEmpty) {
      return <ReaderWarmupPageData>[
        ReaderWarmupPageData(
          pageInChapter: 0,
          pageCountInChapter: 1,
          chapterTextStart: 0,
          chapterTextEnd: 0,
          globalReadableOffset: globalReadableOffset,
          content: '本章暂无正文内容',
          showsTitle: true,
        ),
      ];
    }

    final _WarmupLayout layout = _pageLayoutFor(
      settings: settings,
      viewportSize: viewportSize,
      textScaler: textScaler,
    );
    final TextStyle bodyStyle = _bodyTextStyle(settings);
    final List<_WarmupSlice> slices = <_WarmupSlice>[];
    int start = 0;
    bool firstPage = true;

    while (start < text.length) {
      final double availableHeight = firstPage
          ? layout.firstPageBodyHeight
          : layout.followingPageBodyHeight;
      final int end = _findPageEnd(
        text: text,
        start: start,
        maxWidth: layout.contentWidth,
        maxHeight: availableHeight,
        style: bodyStyle,
        textScaler: textScaler,
      );
      slices.add(_WarmupSlice(start: start, end: end));
      start = _skipLeadingBreaks(text, end);
      firstPage = false;
    }

    final int pageCount = math.max(1, slices.length);
    return List<ReaderWarmupPageData>.generate(pageCount, (int index) {
      final _WarmupSlice slice = slices[index];
      return ReaderWarmupPageData(
        pageInChapter: index,
        pageCountInChapter: pageCount,
        chapterTextStart: slice.start,
        chapterTextEnd: slice.end,
        globalReadableOffset: globalReadableOffset,
        content: text.substring(slice.start, slice.end),
        showsTitle: index == 0,
      );
    });
  }

  _WarmupLayout _pageLayoutFor({
    required ReaderSettingsModel settings,
    required Size viewportSize,
    required TextScaler textScaler,
  }) {
    final double contentWidth = math.max(
      80,
      viewportSize.width - settings.horizontalPadding * 2,
    );
    final TextPainter headerPainter = TextPainter(
      text: const TextSpan(
        text: '章节标题',
        style: TextStyle(fontSize: 15, height: 1.2, fontWeight: FontWeight.w500),
      ),
      maxLines: 1,
      textDirection: TextDirection.ltr,
      textScaler: textScaler,
    )..layout(maxWidth: contentWidth);
    final TextPainter displayTitlePainter = TextPainter(
      text: const TextSpan(
        text: '章节标题',
        style: TextStyle(fontSize: 26, height: 1.28, fontWeight: FontWeight.w700),
      ),
      maxLines: 2,
      textDirection: TextDirection.ltr,
      textScaler: textScaler,
    )..layout(maxWidth: contentWidth);
    final double availableHeight = math.max(
      80,
      viewportSize.height -
          _readerWarmupTopPadding -
          _readerWarmupBottomPadding,
    );
    final double followingPageBodyHeight = math.max(
      80,
      availableHeight - headerPainter.height - _readerWarmupHeaderGap,
    );
    return _WarmupLayout(
      contentWidth: contentWidth,
      firstPageBodyHeight: math.max(
        80,
        followingPageBodyHeight -
            displayTitlePainter.height -
            _readerWarmupDisplayTitleGap,
      ),
      followingPageBodyHeight: followingPageBodyHeight,
    );
  }

  TextStyle _bodyTextStyle(ReaderSettingsModel settings) {
    final _WarmupFont font = _fontFor(settings.fontFamilyId);
    return TextStyle(
      fontSize: settings.fontSize + 12,
      height: settings.lineHeight,
      color: Colors.black,
      letterSpacing: 0.6,
      fontWeight: FontWeight.w400,
      fontFamily: font.fontFamily,
      fontFamilyFallback: font.fontFamilyFallback,
    );
  }

  _WarmupFont _fontFor(String fontId) {
    return switch (fontId) {
      'sans' => const _WarmupFont(
        fontFamily: 'ReaderNotoSansSC',
        fontFamilyFallback: <String>[
          'PingFang SC',
          'Noto Sans CJK SC',
          'Microsoft YaHei',
          'sans-serif',
        ],
      ),
      'song' => const _WarmupFont(
        fontFamily: 'ReaderNotoSerifSC',
        fontFamilyFallback: <String>[
          'Songti SC',
          'STSong',
          'Noto Serif CJK SC',
          'serif',
        ],
      ),
      'wenkai' => const _WarmupFont(
        fontFamily: 'ReaderLXGWWenKai',
        fontFamilyFallback: <String>['Kaiti SC', 'STKaiti', 'KaiTi', 'serif'],
      ),
      'mono' => const _WarmupFont(
        fontFamily: 'Menlo',
        fontFamilyFallback: <String>['SF Mono', 'Roboto Mono', 'monospace'],
      ),
      _ => const _WarmupFont(
        fontFamily: null,
        fontFamilyFallback: <String>[
          'PingFang SC',
          'Noto Sans CJK SC',
          'Microsoft YaHei',
        ],
      ),
    };
  }

  int _findPageEnd({
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

  bool _fitsPage(
    String value,
    double maxWidth,
    double maxHeight,
    TextStyle style,
    TextScaler textScaler,
  ) {
    final TextPainter painter = TextPainter(
      text: TextSpan(text: _displayText(value), style: style),
      textAlign: TextAlign.justify,
      textDirection: TextDirection.ltr,
      textScaler: textScaler,
    )..layout(maxWidth: maxWidth);
    return painter.height <= maxHeight;
  }

  int _lastSoftBreak(String text, int start, int best) {
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

  int _skipLeadingBreaks(String text, int offset) {
    int next = offset;
    while (next < text.length && text.codeUnitAt(next) <= 32) {
      next += 1;
    }
    return next;
  }

  int _pageIndexForChapterOffset(
    List<ReaderWarmupPageData> pages,
    int chapterOffset,
  ) {
    final int index = pages.indexWhere((ReaderWarmupPageData page) {
      return chapterOffset >= page.chapterTextStart &&
          chapterOffset < page.chapterTextEnd;
    });
    if (index >= 0) {
      return index;
    }
    return 0;
  }

  String _displayText(String value) {
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

  String _readableText(ReaderChapterModel chapter) {
    final String? text = chapter.plainText;
    if (text == null || text.trim().isEmpty) {
      return '本章暂无正文内容';
    }
    return text;
  }
}

class ReaderWarmupResult {
  const ReaderWarmupResult({
    required this.bookId,
    required this.signature,
    required this.chapterIndex,
    required this.initialPageIndex,
    required this.pages,
  });

  final String bookId;
  final String signature;
  final int chapterIndex;
  final int initialPageIndex;
  final List<ReaderWarmupPageData> pages;
}

class ReaderWarmupPageData {
  const ReaderWarmupPageData({
    required this.pageInChapter,
    required this.pageCountInChapter,
    required this.chapterTextStart,
    required this.chapterTextEnd,
    required this.globalReadableOffset,
    required this.content,
    required this.showsTitle,
  });

  final int pageInChapter;
  final int pageCountInChapter;
  final int chapterTextStart;
  final int chapterTextEnd;
  final int globalReadableOffset;
  final String content;
  final bool showsTitle;
}

class _WarmupLayout {
  const _WarmupLayout({
    required this.contentWidth,
    required this.firstPageBodyHeight,
    required this.followingPageBodyHeight,
  });

  final double contentWidth;
  final double firstPageBodyHeight;
  final double followingPageBodyHeight;
}

class _WarmupSlice {
  const _WarmupSlice({required this.start, required this.end});

  final int start;
  final int end;
}

class _WarmupFont {
  const _WarmupFont({
    required this.fontFamily,
    required this.fontFamilyFallback,
  });

  final String? fontFamily;
  final List<String> fontFamilyFallback;
}
