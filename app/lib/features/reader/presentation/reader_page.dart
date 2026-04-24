import 'dart:async';
import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketread/core/widgets/ux_state_view.dart';
import 'package:pocketread/data/repositories/reader_repository.dart';
import 'package:pocketread/features/reader/application/reader_launch_warmup_service.dart';
import 'package:pocketread/features/reader/application/reader_providers.dart';
import 'package:pocketread/features/reader/domain/reader_models.dart';

const double _readerPageTopPadding = 44;
const double _readerPageBottomPadding = 48;
const double _readerHeaderGap = 12;
const double _readerDisplayTitleGap = 20;

class ReaderPage extends ConsumerStatefulWidget {
  const ReaderPage({required this.bookId, super.key});

  final String bookId;

  @override
  ConsumerState<ReaderPage> createState() => _ReaderPageState();
}

class _ReaderPageState extends ConsumerState<ReaderPage>
    with WidgetsBindingObserver {
  static const Color _paper = Color(0xFFF6F1E9);
  static const Color _ink = Color(0xFF111111);
  static const Color _muted = Color(0xFF8C918B);
  static const Color _line = Color(0x66FFFFFF);
  static const Color _accent = Color(0xFF2E9D62);
  static const Color _overlaySurface = Color(0xFFFFFCF7);
  static const Color _overlayChipSurface = Color(0xFFF7F3EC);
  static const int _maxChapterPaginationCacheEntries = 24;
  static final Map<String, List<_ReaderPageEntry>> _chapterPaginationCache =
      <String, List<_ReaderPageEntry>>{};

  final PageController _pageController = PageController();

  late final ReaderRepository _readerRepository;
  ReaderBookDetail? _detail;
  List<_ReaderPageEntry> _pages = const <_ReaderPageEntry>[];
  _ReaderUiSettings _settings = _ReaderUiSettings.defaults();
  int _globalPageIndex = 0;
  bool _chromeVisible = false;
  bool _loading = true;
  String? _errorMessage;
  String? _paginationSignature;
  _ReaderPageEntry? _paginationAnchor;
  _ReaderLayoutSnapshot? _layoutSnapshot;
  final Set<String> _queuedPrepaginationKeys = <String>{};
  Timer? _saveDebounce;
  Timer? _settingsSaveDebounce;
  DateTime _openedAt = DateTime.now();

  @override
  void initState() {
    super.initState();
    _readerRepository = ref.read(readerRepositoryProvider);
    WidgetsBinding.instance.addObserver(this);
    _loadReader();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _saveDebounce?.cancel();
    _settingsSaveDebounce?.cancel();
    unawaited(_readerRepository.saveReaderSettings(_settings.toModel()));
    _saveProgress();
    _pageController.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached) {
      _saveProgress();
    }
  }

  Future<void> _loadReader() async {
    setState(() {
      _loading = true;
      _errorMessage = null;
    });

    try {
      final ReaderSettingsModel savedSettings = await _readerRepository
          .getReaderSettings();
      final ReaderBookDetail? detail = await _readerRepository.getBookDetail(
        widget.bookId,
      );
      if (!mounted) {
        return;
      }
      if (detail == null) {
        setState(() {
          _loading = false;
          _errorMessage = '书籍不存在或已被删除';
        });
        return;
      }
      if (detail.chapters.isEmpty) {
        setState(() {
          _detail = detail;
          _loading = false;
          _errorMessage = '这本书还没有可阅读章节';
        });
        return;
      }

      final _ReaderUiSettings loadedSettings = _ReaderUiSettings.fromModel(
        savedSettings,
      );
      final ReaderLaunchWarmupService warmupService = ref.read(
        readerLaunchWarmupServiceProvider,
      );
      final ReaderWarmupResult? preparedLaunch = _layoutSnapshot == null
          ? null
          : warmupService.takePreparedLaunch(
              bookId: widget.bookId,
              signature: ReaderLaunchWarmupService.buildPaginationSignature(
                viewportSize: _layoutSnapshot!.viewportSize,
                textScaler: _layoutSnapshot!.textScaler,
                bookId: detail.book.id,
                chapterCount: detail.chapters.length,
                totalReadableLength: _totalReadableLength(detail),
                settings: savedSettings,
              ),
            );
      setState(() {
        _settings = loadedSettings;
        _detail = detail;
        _pages = preparedLaunch == null
            ? const <_ReaderPageEntry>[]
            : _pageEntriesFromWarmup(detail, preparedLaunch);
        _globalPageIndex = preparedLaunch?.initialPageIndex ?? 0;
        _paginationSignature = preparedLaunch?.signature;
        _loading = false;
      });
    } on Exception catch (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _loading = false;
        _errorMessage = '阅读器加载失败';
      });
    }
  }

  List<_ReaderPageEntry> _buildChapterPages(
    ReaderChapterModel chapter,
    _ReaderUiSettings settings,
    Size viewportSize,
    TextScaler textScaler,
    BuildContext context,
  ) {
    final String text = _readableText(chapter).trim();
    if (text.isEmpty) {
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

    final _ReaderPageLayout layout = _pageLayoutFor(
      settings,
      viewportSize,
      context,
    );
    final TextStyle bodyStyle = _bodyTextStyle(settings, context);
    final List<_ReaderTextSlice> slices = <_ReaderTextSlice>[];
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
      slices.add(_ReaderTextSlice(start: start, end: end));
      start = _skipLeadingBreaks(text, end);
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
        globalReadableOffset: _readableOffsetBeforeChapter(
          chapter.chapterIndex,
        ),
        content: text.substring(slice.start, slice.end),
        showsTitle: index == 0,
      );
    }, growable: false);
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

  int _restoreChapterIndex(ReaderProgressModel? progress) {
    final String? locatorValue = progress?.locatorValue;
    if (locatorValue != null) {
      final RegExpMatch? offsetMatch = RegExp(
        r'^offset:(\d+):(\d+)$',
      ).firstMatch(locatorValue);
      if (offsetMatch != null) {
        return int.tryParse(offsetMatch.group(1) ?? '') ?? 0;
      }
      final RegExpMatch? pageMatch = RegExp(
        r'^page:(\d+):(\d+)$',
      ).firstMatch(locatorValue);
      if (pageMatch != null) {
        return int.tryParse(pageMatch.group(1) ?? '') ?? 0;
      }
    }
    return progress?.currentChapterIndex ?? 0;
  }

  int _restoreChapterTextOffset(
    ReaderProgressModel? progress,
    int chapterIndex,
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
    if (chapterOffset != null) {
      final ReaderChapterModel? chapter = _chapterByIndex(chapterIndex);
      if (chapter == null) {
        return chapterOffset;
      }
      return (chapterOffset - (chapter.startOffset ?? 0)).clamp(
        0,
        _readableText(chapter).length,
      );
    }
    return 0;
  }

  int _pageIndexForChapterOffset(
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

  ReaderChapterModel? _chapterByIndex(int chapterIndex) {
    final ReaderBookDetail? detail = _detail;
    if (detail == null) {
      return null;
    }
    for (final ReaderChapterModel chapter in detail.chapters) {
      if (chapter.chapterIndex == chapterIndex) {
        return chapter;
      }
    }
    return null;
  }

  void _onPageChanged(int index) {
    _globalPageIndex = index;
    _saveDebounce?.cancel();
    _saveDebounce = Timer(const Duration(milliseconds: 700), _saveProgress);
    _prepaginateAroundCurrentPage();
    if (mounted) {
      setState(() {
        _chromeVisible = false;
      });
    }
  }

  Future<void> _saveProgress() async {
    final ReaderBookDetail? detail = _detail;
    if (detail == null || _pages.isEmpty) {
      return;
    }

    final _ReaderPageEntry entry =
        _pages[_globalPageIndex.clamp(0, math.max(0, _pages.length - 1))];
    final ReaderChapterModel chapter = entry.chapter;
    final int globalOffset =
        entry.globalReadableOffset + entry.chapterTextStart;
    final int totalReadableLength = _totalReadableLength(detail);
    final double progressPercent = totalReadableLength <= 0
        ? 0
        : (globalOffset / totalReadableLength).clamp(0, 1);
    final int now = DateTime.now().millisecondsSinceEpoch;
    final int totalMinutes =
        (detail.progress?.totalReadingMinutes ?? 0) +
        DateTime.now().difference(_openedAt).inMinutes;

    await _readerRepository.saveProgress(
      bookId: widget.bookId,
      currentChapterIndex: chapter.chapterIndex,
      chapterOffset: _chapterOffsetForPage(chapter, entry),
      scrollOffset: entry.pageInChapter.toDouble(),
      progressPercent: progressPercent,
      locatorType: 'chapter_offset',
      locatorValue: 'offset:${chapter.chapterIndex}:${entry.chapterTextStart}',
      lastReadAtMillis: now,
      updatedAtMillis: now,
      totalReadingMinutes: totalMinutes,
    );
    _openedAt = DateTime.now();
  }

  int _totalReadableLength(ReaderBookDetail detail) {
    int total = 0;
    for (final ReaderChapterModel chapter in detail.chapters) {
      total += _readableText(chapter).trim().length;
    }
    return total;
  }

  int _readableOffsetBeforeChapter(int chapterIndex) {
    final ReaderBookDetail? detail = _detail;
    if (detail == null) {
      return 0;
    }
    int total = 0;
    for (final ReaderChapterModel chapter in detail.chapters) {
      if (chapter.chapterIndex == chapterIndex) {
        return total;
      }
      total += _readableText(chapter).trim().length;
    }
    return total;
  }

  int? _chapterOffsetForPage(
    ReaderChapterModel chapter,
    _ReaderPageEntry entry,
  ) {
    final int? startOffset = chapter.startOffset;
    if (startOffset == null) {
      return entry.chapterTextStart;
    }
    return startOffset + entry.chapterTextStart;
  }

  Future<void> _goToChapter(int chapterIndex) async {
    await _saveProgress();
    final ReaderChapterModel? chapter = _chapterByIndex(chapterIndex);
    if (chapter == null) {
      return;
    }
    _paginationAnchor = _ReaderPageEntry.anchor(chapter: chapter);
    _paginationSignature = null;
    _ensurePaginationFromLastLayout();
  }

  void _handleTapUp(TapUpDetails details, BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double dx = details.localPosition.dx;
    final double leftBound = width * 0.33;
    final double rightBound = width * 0.67;
    if (dx < leftBound) {
      _goToAdjacentPage(-1);
      return;
    }
    if (dx > rightBound) {
      _goToAdjacentPage(1);
      return;
    }
    setState(() {
      _chromeVisible = !_chromeVisible;
    });
  }

  void _goToAdjacentPage(int delta) {
    if (_pages.isEmpty) {
      return;
    }
    final int targetIndex = _globalPageIndex + delta;
    if (targetIndex < 0 || targetIndex >= _pages.length) {
      if (_goToAdjacentChapter(delta)) {
        return;
      }
      _showPageBoundary(delta < 0 ? '已经是第一页' : '已经是最后一页');
      return;
    }
    setState(() {
      _chromeVisible = false;
      _globalPageIndex = targetIndex;
    });
    if (_pageController.hasClients) {
      _pageController.animateToPage(
        targetIndex,
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
      );
    }
    _prepaginateAroundCurrentPage();
  }

  bool _goToAdjacentChapter(int delta) {
    final ReaderBookDetail? detail = _detail;
    final String? signature = _paginationSignature;
    final _ReaderLayoutSnapshot? snapshot = _layoutSnapshot;
    if (detail == null ||
        signature == null ||
        snapshot == null ||
        _pages.isEmpty) {
      return false;
    }
    final _ReaderPageEntry currentEntry =
        _pages[_globalPageIndex.clamp(0, math.max(0, _pages.length - 1))];
    final int targetChapterIndex = currentEntry.chapter.chapterIndex + delta;
    if (targetChapterIndex < 0 ||
        targetChapterIndex >= detail.chapters.length) {
      return false;
    }
    final List<_ReaderPageEntry> nextPages = _composeChapterWindow(
      detail: detail,
      centerChapterIndex: targetChapterIndex,
      signature: signature,
      settings: _settings,
      viewportSize: snapshot.viewportSize,
      textScaler: snapshot.textScaler,
      context: context,
    );
    final int targetOffset = delta > 0 ? 0 : 1 << 30;
    final int nextIndex = _pageIndexForChapterOffset(
      nextPages,
      targetChapterIndex,
      targetOffset,
    ).clamp(0, math.max(0, nextPages.length - 1));
    final int currentIndexInNextPages = _pageIndexForChapterOffset(
      nextPages,
      currentEntry.chapter.chapterIndex,
      currentEntry.chapterTextStart,
    ).clamp(0, math.max(0, nextPages.length - 1));
    setState(() {
      _pages = nextPages;
      _globalPageIndex = currentIndexInNextPages;
      _chromeVisible = false;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_pageController.hasClients && nextPages.isNotEmpty) {
        _pageController.jumpToPage(currentIndexInNextPages);
        _pageController.animateToPage(
          nextIndex,
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
        );
      }
      _prepaginateAroundCurrentPage();
    });
    return true;
  }

  void _showPageBoundary(String message) {
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          duration: const Duration(milliseconds: 900),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  void _openToc() {
    Scaffold.maybeOf(context)?.openEndDrawer();
  }

  void _updateSettings(_ReaderUiSettings settings) {
    _rebuildPagesForSettings(settings);
  }

  void _restoreDefaultSettings() {
    _rebuildPagesForSettings(_ReaderUiSettings.defaults());
  }

  void _setThemeMode(_ReaderThemeMode mode) {
    final _ReaderUiSettings nextSettings = switch (mode) {
      _ReaderThemeMode.day => _settings.copyWith(
        themeMode: mode,
        backgroundId: _ReaderBackgroundStyle.paper.id,
      ),
      _ReaderThemeMode.night => _settings.copyWith(
        themeMode: mode,
        backgroundId: _ReaderBackgroundStyle.midnight.id,
      ),
      _ReaderThemeMode.system => _settings.copyWith(themeMode: mode),
    };
    _rebuildPagesForSettings(nextSettings);
  }

  void _rebuildPagesForSettings(_ReaderUiSettings nextSettings) {
    final _ReaderPageEntry? currentEntry = _pages.isEmpty
        ? null
        : _pages[_globalPageIndex.clamp(0, _pages.length - 1)];
    setState(() {
      _settings = nextSettings;
      _paginationSignature = null;
      _paginationAnchor = currentEntry;
      if (currentEntry != null) {
        _globalPageIndex = 0;
      }
    });
    _scheduleSettingsSave(nextSettings);
  }

  void _ensurePagination(
    BuildContext context,
    BoxConstraints constraints,
    _ReaderPageEntry? anchorEntry,
  ) {
    final ReaderBookDetail? detail = _detail;
    if (detail == null || _loading || constraints.maxWidth <= 0) {
      return;
    }
    final Size viewportSize = Size(constraints.maxWidth, constraints.maxHeight);
    final TextScaler textScaler = MediaQuery.textScalerOf(context);
    _layoutSnapshot = _ReaderLayoutSnapshot(
      viewportSize: viewportSize,
      textScaler: textScaler,
    );
    final String signature = _paginationKey(
      viewportSize,
      _settings,
      textScaler,
      detail.book.id,
      detail.chapters.length,
      _totalReadableLength(detail),
    );
    final ReaderWarmupResult? preparedLaunch = ref
        .read(readerLaunchWarmupServiceProvider)
        .takePreparedLaunch(bookId: widget.bookId, signature: signature);
    if (preparedLaunch != null && _pages.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || _paginationSignature == signature) {
          return;
        }
        final List<_ReaderPageEntry> pages = _pageEntriesFromWarmup(
          detail,
          preparedLaunch,
        );
        setState(() {
          _pages = pages;
          _globalPageIndex = preparedLaunch.initialPageIndex.clamp(
            0,
            math.max(0, pages.length - 1),
          );
          _paginationSignature = signature;
          _paginationAnchor = null;
        });
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_pageController.hasClients && pages.isNotEmpty) {
            _pageController.jumpToPage(_globalPageIndex);
          }
          _prepaginateAroundCurrentPage();
        });
      });
      return;
    }
    if (_paginationSignature == signature && _pages.isNotEmpty) {
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _paginationSignature == signature) {
        return;
      }
      final _ReaderPageEntry? effectiveAnchor =
          anchorEntry ??
          (_pages.isEmpty
              ? null
              : _pages[_globalPageIndex.clamp(0, _pages.length - 1)]);
      final int targetChapterIndex =
          effectiveAnchor?.chapter.chapterIndex ??
          _restoreChapterIndex(detail.progress);
      final int targetOffset =
          effectiveAnchor?.chapterTextStart ??
          _restoreChapterTextOffset(detail.progress, targetChapterIndex);
      final List<_ReaderPageEntry> pages = _composeChapterWindow(
        detail: detail,
        centerChapterIndex: targetChapterIndex,
        signature: signature,
        settings: _settings,
        viewportSize: viewportSize,
        textScaler: textScaler,
        context: context,
      );
      final int nextIndex = _pageIndexForChapterOffset(
        pages,
        targetChapterIndex,
        targetOffset,
      ).clamp(0, math.max(0, pages.length - 1));
      if (!mounted) {
        return;
      }
      setState(() {
        _pages = pages;
        _globalPageIndex = nextIndex;
        _paginationSignature = signature;
        _paginationAnchor = null;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_pageController.hasClients && pages.isNotEmpty) {
          _pageController.jumpToPage(nextIndex);
        }
        _prepaginateAroundCurrentPage();
      });
    });
  }

  List<_ReaderPageEntry> _composeChapterWindow({
    required ReaderBookDetail detail,
    required int centerChapterIndex,
    required String signature,
    required _ReaderUiSettings settings,
    required Size viewportSize,
    required TextScaler textScaler,
    required BuildContext context,
  }) {
    final List<int> orderedIndices = _availableWindowChapterIndices(
      detail,
      centerChapterIndex,
      signature,
    );
    final List<_ReaderPageEntry> pages = <_ReaderPageEntry>[];
    for (final int chapterIndex in orderedIndices) {
      final ReaderChapterModel? chapter = _chapterByIndex(chapterIndex);
      if (chapter == null) {
        continue;
      }
      pages.addAll(
        _chapterPagesFor(
          chapter: chapter,
          signature: signature,
          settings: settings,
          viewportSize: viewportSize,
          textScaler: textScaler,
          context: context,
        ),
      );
    }
    return pages;
  }

  List<int> _availableWindowChapterIndices(
    ReaderBookDetail detail,
    int centerChapterIndex,
    String signature,
  ) {
    final List<int> orderedIndices = <int>[];
    final int previousChapter = centerChapterIndex - 1;
    if (previousChapter >= 0 &&
        _chapterPaginationCache.containsKey(
          _chapterPaginationKey(signature, previousChapter),
        )) {
      orderedIndices.add(previousChapter);
    }
    orderedIndices.add(centerChapterIndex);
    final int nextChapter = centerChapterIndex + 1;
    if (nextChapter < detail.chapters.length &&
        _chapterPaginationCache.containsKey(
          _chapterPaginationKey(signature, nextChapter),
        )) {
      orderedIndices.add(nextChapter);
    }
    return orderedIndices;
  }

  List<_ReaderPageEntry> _chapterPagesFor({
    required ReaderChapterModel chapter,
    required String signature,
    required _ReaderUiSettings settings,
    required Size viewportSize,
    required TextScaler textScaler,
    required BuildContext context,
  }) {
    final String cacheKey = _chapterPaginationKey(
      signature,
      chapter.chapterIndex,
    );
    final List<_ReaderPageEntry>? cachedPages =
        _chapterPaginationCache[cacheKey];
    if (cachedPages != null) {
      _touchChapterPagination(cacheKey, cachedPages);
      return cachedPages;
    }
    final List<_ReaderPageEntry> pages = _buildChapterPages(
      chapter,
      settings,
      viewportSize,
      textScaler,
      context,
    );
    _touchChapterPagination(cacheKey, pages);
    return pages;
  }

  void _prepaginateAroundCurrentPage() {
    final ReaderBookDetail? detail = _detail;
    if (detail == null || _pages.isEmpty || _paginationSignature == null) {
      return;
    }
    final _ReaderPageEntry entry =
        _pages[_globalPageIndex.clamp(0, math.max(0, _pages.length - 1))];
    final int chapterIndex = entry.chapter.chapterIndex;
    final List<int> targets = <int>[
      if (chapterIndex > 0) chapterIndex - 1,
      if (chapterIndex < detail.chapters.length - 1) chapterIndex + 1,
    ];
    for (final int target in targets) {
      final String cacheKey = _chapterPaginationKey(
        _paginationSignature!,
        target,
      );
      if (_chapterPaginationCache.containsKey(cacheKey) ||
          _queuedPrepaginationKeys.contains(cacheKey)) {
        continue;
      }
      _queuedPrepaginationKeys.add(cacheKey);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || _paginationSignature == null) {
          _queuedPrepaginationKeys.remove(cacheKey);
          return;
        }
        final ReaderChapterModel? chapter = _chapterByIndex(target);
        final _ReaderLayoutSnapshot? snapshot = _layoutSnapshot;
        if (chapter == null || snapshot == null) {
          _queuedPrepaginationKeys.remove(cacheKey);
          return;
        }
        _chapterPagesFor(
          chapter: chapter,
          signature: _paginationSignature!,
          settings: _settings,
          viewportSize: snapshot.viewportSize,
          textScaler: snapshot.textScaler,
          context: context,
        );
        _queuedPrepaginationKeys.remove(cacheKey);
      });
    }
  }

  void _ensurePaginationFromLastLayout() {
    setState(() {
      _pages = const <_ReaderPageEntry>[];
      _globalPageIndex = 0;
    });
  }

  String _paginationKey(
    Size viewportSize,
    _ReaderUiSettings settings,
    TextScaler textScaler,
    String bookId,
    int chapterCount,
    int totalReadableLength,
  ) {
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

  List<_ReaderPageEntry> _pageEntriesFromWarmup(
    ReaderBookDetail detail,
    ReaderWarmupResult preparedLaunch,
  ) {
    final ReaderChapterModel? chapter = _chapterByIndex(
      preparedLaunch.chapterIndex,
    );
    if (chapter == null) {
      return const <_ReaderPageEntry>[];
    }
    return preparedLaunch.pages
        .map((ReaderWarmupPageData page) {
          return _ReaderPageEntry(
            chapter: chapter,
            pageInChapter: page.pageInChapter,
            pageCountInChapter: page.pageCountInChapter,
            chapterTextStart: page.chapterTextStart,
            chapterTextEnd: page.chapterTextEnd,
            globalReadableOffset: page.globalReadableOffset,
            content: page.content,
            showsTitle: page.showsTitle,
          );
        })
        .toList(growable: false);
  }

  String _chapterPaginationKey(String signature, int chapterIndex) {
    return '$signature#$chapterIndex';
  }

  void _touchChapterPagination(String cacheKey, List<_ReaderPageEntry> pages) {
    _chapterPaginationCache.remove(cacheKey);
    _chapterPaginationCache[cacheKey] = pages;
    while (_chapterPaginationCache.length > _maxChapterPaginationCacheEntries) {
      _chapterPaginationCache.remove(_chapterPaginationCache.keys.first);
    }
  }

  _ReaderPageLayout _pageLayoutFor(
    _ReaderUiSettings settings,
    Size viewportSize,
    BuildContext context,
  ) {
    final _ReaderPageMargin margin = _ReaderPageMargin.values.firstWhere(
      (_ReaderPageMargin item) => item.id == settings.pageMarginId,
      orElse: () => _ReaderPageMargin.comfort,
    );
    final double contentWidth = math.max(
      80,
      viewportSize.width - margin.horizontalPadding * 2,
    );
    final TextPainter headerPainter = TextPainter(
      text: TextSpan(text: '章节标题', style: _titleTextStyle(context)),
      maxLines: 1,
      textDirection: TextDirection.ltr,
      textScaler: MediaQuery.textScalerOf(context),
    )..layout(maxWidth: contentWidth);
    final TextPainter displayTitlePainter = TextPainter(
      text: TextSpan(text: '章节标题', style: _displayTitleTextStyle(context)),
      maxLines: 2,
      textDirection: TextDirection.ltr,
      textScaler: MediaQuery.textScalerOf(context),
    )..layout(maxWidth: contentWidth);
    final double availableHeight = math.max(
      80,
      viewportSize.height - _readerPageTopPadding - _readerPageBottomPadding,
    );
    final double followingPageBodyHeight = math.max(
      80,
      availableHeight - headerPainter.height - _readerHeaderGap,
    );
    final double firstPageBodyHeight = math.max(
      80,
      followingPageBodyHeight -
          displayTitlePainter.height -
          _readerDisplayTitleGap,
    );
    return _ReaderPageLayout(
      contentWidth: contentWidth,
      firstPageBodyHeight: firstPageBodyHeight,
      followingPageBodyHeight: followingPageBodyHeight,
    );
  }

  TextStyle _bodyTextStyle(_ReaderUiSettings settings, BuildContext context) {
    final _ReaderBackgroundStyle backgroundStyle = _resolvedBackgroundStyle(
      context,
    );
    final _ReaderFontOption font = _ReaderFontOption.values.firstWhere(
      (_ReaderFontOption item) => item.id == settings.fontId,
      orElse: () => _ReaderFontOption.system,
    );
    return TextStyle(
      fontSize: settings.renderFontSize,
      height: settings.lineHeight,
      color: backgroundStyle.textColor,
      letterSpacing: 0.6,
      fontWeight: FontWeight.w400,
      fontFamily: font.fontFamily,
      fontFamilyFallback: font.fontFamilyFallback,
    );
  }

  TextStyle _titleTextStyle(BuildContext context) {
    final _ReaderBackgroundStyle backgroundStyle = _resolvedBackgroundStyle(
      context,
    );
    return TextStyle(
      fontSize: 15,
      height: 1.2,
      fontWeight: FontWeight.w500,
      color: backgroundStyle.mutedColor,
      letterSpacing: 0.3,
    );
  }

  TextStyle _displayTitleTextStyle(BuildContext context) {
    final _ReaderBackgroundStyle backgroundStyle = _resolvedBackgroundStyle(
      context,
    );
    return TextStyle(
      fontSize: 26,
      height: 1.28,
      fontWeight: FontWeight.w700,
      color: backgroundStyle.textColor,
      letterSpacing: 0.2,
    );
  }

  void _scheduleSettingsSave(_ReaderUiSettings settings) {
    _settingsSaveDebounce?.cancel();
    _settingsSaveDebounce = Timer(const Duration(milliseconds: 250), () async {
      await _readerRepository.saveReaderSettings(settings.toModel());
    });
  }

  Brightness _resolvedBrightness(BuildContext context) {
    return switch (_settings.themeMode) {
      _ReaderThemeMode.day => Brightness.light,
      _ReaderThemeMode.night => Brightness.dark,
      _ReaderThemeMode.system => MediaQuery.platformBrightnessOf(context),
    };
  }

  _ReaderBackgroundStyle _resolvedBackgroundStyle(BuildContext context) {
    final Brightness brightness = _resolvedBrightness(context);
    if (brightness == Brightness.dark &&
        _settings.themeMode != _ReaderThemeMode.day) {
      return _ReaderBackgroundStyle.midnight;
    }
    return _ReaderBackgroundStyle.values.firstWhere(
      (_ReaderBackgroundStyle style) => style.id == _settings.backgroundId,
      orElse: () => _ReaderBackgroundStyle.paper,
    );
  }

  Color _resolvedTextColor(BuildContext context) {
    final _ReaderBackgroundStyle style = _resolvedBackgroundStyle(context);
    return style.textColor;
  }

  Color _resolvedMutedColor(BuildContext context) {
    final _ReaderBackgroundStyle style = _resolvedBackgroundStyle(context);
    return style.mutedColor;
  }

  Color _resolvedDividerColor(BuildContext context) {
    final Brightness brightness = _resolvedBrightness(context);
    return brightness == Brightness.dark
        ? const Color(0x26FFFFFF)
        : const Color(0x12111111);
  }

  @override
  Widget build(BuildContext context) {
    final _ReaderPageEntry? currentEntry = _pages.isEmpty
        ? null
        : _pages[_globalPageIndex.clamp(0, math.max(0, _pages.length - 1))];
    final _ReaderBackgroundStyle backgroundStyle = _resolvedBackgroundStyle(
      context,
    );
    final Color textColor = _resolvedTextColor(context);
    final Color mutedColor = _resolvedMutedColor(context);
    final Color dividerColor = _resolvedDividerColor(context);

    return PopScope(
      onPopInvokedWithResult: (bool didPop, Object? result) {
        _saveProgress();
      },
      child: Scaffold(
        backgroundColor: backgroundStyle.color,
        endDrawer: _detail == null
            ? null
            : _ReaderTocDrawer(
                chapters: _detail!.chapters,
                currentChapterIndex: currentEntry?.chapter.chapterIndex ?? 0,
                onSelectChapter: (int chapterIndex) {
                  Navigator.of(context).pop();
                  _goToChapter(chapterIndex);
                },
              ),
        body: Stack(
          children: <Widget>[
            Positioned.fill(child: _buildBody()),
            if (_chromeVisible &&
                _detail != null &&
                currentEntry != null) ...<Widget>[
              _ReaderTopBar(
                title: currentEntry.chapter.title,
                textColor: textColor,
                dividerColor: dividerColor,
                onBack: () => Navigator.of(context).maybePop(),
                onToc: _openToc,
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: _ReaderSettingsPanel(
                  settings: _settings,
                  textColor: textColor,
                  accentColor: _accent,
                  panelColor: _overlaySurface,
                  chipColor: _overlayChipSurface,
                  onRestoreDefaults: _restoreDefaultSettings,
                  onFontSizeChanged: (double value) {
                    _updateSettings(_settings.copyWith(fontSize: value));
                  },
                  onLineHeightChanged: (double value) {
                    _updateSettings(_settings.copyWith(lineHeight: value));
                  },
                  onPageMarginChanged: (_ReaderPageMargin margin) {
                    _updateSettings(
                      _settings.copyWith(pageMarginId: margin.id),
                    );
                  },
                  onFontChanged: (_ReaderFontOption font) {
                    _updateSettings(_settings.copyWith(fontId: font.id));
                  },
                  onBackgroundChanged: (_ReaderBackgroundStyle style) {
                    _updateSettings(_settings.copyWith(backgroundId: style.id));
                  },
                  onThemeModeChanged: _setThemeMode,
                ),
              ),
            ],
            if (_detail != null && currentEntry != null && !_chromeVisible)
              _ReaderPageProgress(
                currentPage: currentEntry.pageInChapter + 1,
                totalPages: currentEntry.pageCountInChapter,
                color: mutedColor,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return _ReaderPreparingState(detail: _detail);
    }
    if (_errorMessage != null) {
      final bool missingBook = _errorMessage == '书籍不存在或已被删除';
      final bool emptyContent = _errorMessage == '这本书还没有可阅读章节';
      return _ReaderMessageState(
        title: missingBook ? '书籍已不可用' : '加载失败',
        message: emptyContent ? '当前文件没有解析出可阅读正文，请重新导入后再试。' : _errorMessage!,
        primaryLabel: missingBook ? '返回书架' : '重新加载',
        onPrimaryAction: missingBook
            ? () {
                Navigator.of(context).maybePop();
              }
            : _loadReader,
      );
    }
    if (_detail == null || _pages.isEmpty) {
      return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          _ensurePagination(context, constraints, _paginationAnchor);
          return _ReaderPreparingState(detail: _detail);
        },
      );
    }

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final _ReaderPageEntry? currentEntry = _pages.isEmpty
            ? null
            : _pages[_globalPageIndex.clamp(0, _pages.length - 1)];
        _ensurePagination(
          context,
          constraints,
          _paginationAnchor ?? currentEntry,
        );
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapUp: (TapUpDetails details) => _handleTapUp(details, context),
          child: PageView.builder(
            key: ValueKey<String>(_paginationSignature ?? '${_pages.length}'),
            controller: _pageController,
            itemCount: _pages.length,
            onPageChanged: _onPageChanged,
            itemBuilder: (BuildContext context, int index) {
              final _ReaderPageEntry entry = _pages[index];
              return _ReaderTextPage(
                chapterTitle: entry.chapter.title,
                text: entry.content,
                showTitle: entry.showsTitle,
                settings: _settings,
                backgroundStyle: _resolvedBackgroundStyle(context),
              );
            },
          ),
        );
      },
    );
  }

  String _readableText(ReaderChapterModel chapter) {
    final String? text = chapter.plainText;
    if (text == null || text.trim().isEmpty) {
      return '本章暂无正文内容';
    }
    return text;
  }
}

class _ReaderTextPage extends StatelessWidget {
  const _ReaderTextPage({
    required this.chapterTitle,
    required this.text,
    required this.showTitle,
    required this.settings,
    required this.backgroundStyle,
  });

  final String chapterTitle;
  final String text;
  final bool showTitle;
  final _ReaderUiSettings settings;
  final _ReaderBackgroundStyle backgroundStyle;

  @override
  Widget build(BuildContext context) {
    final _ReaderPageMargin margin = _ReaderPageMargin.values.firstWhere(
      (_ReaderPageMargin item) => item.id == settings.pageMarginId,
      orElse: () => _ReaderPageMargin.comfort,
    );
    final _ReaderFontOption font = _ReaderFontOption.values.firstWhere(
      (_ReaderFontOption item) => item.id == settings.fontId,
      orElse: () => _ReaderFontOption.system,
    );
    final TextStyle bodyStyle = TextStyle(
      fontSize: settings.renderFontSize,
      height: settings.lineHeight,
      color: backgroundStyle.textColor,
      letterSpacing: 0.6,
      fontWeight: FontWeight.w400,
      fontFamily: font.fontFamily,
      fontFamilyFallback: font.fontFamilyFallback,
    );
    final TextStyle headerStyle = TextStyle(
      fontSize: 15,
      height: 1.2,
      fontWeight: FontWeight.w500,
      color: backgroundStyle.mutedColor,
      letterSpacing: 0.3,
    );
    final TextStyle displayTitleStyle = TextStyle(
      fontSize: 26,
      height: 1.28,
      fontWeight: FontWeight.w700,
      color: backgroundStyle.textColor,
      letterSpacing: 0.2,
    );
    return Padding(
      padding: EdgeInsets.fromLTRB(
        margin.horizontalPadding,
        _readerPageTopPadding,
        margin.horizontalPadding,
        _readerPageBottomPadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            chapterTitle,
            maxLines: 1,
            overflow: TextOverflow.fade,
            softWrap: false,
            style: headerStyle,
          ),
          const SizedBox(height: _readerHeaderGap),
          if (showTitle) ...<Widget>[
            Text(
              chapterTitle,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: displayTitleStyle,
            ),
            const SizedBox(height: _readerDisplayTitleGap),
          ],
          Expanded(
            child: ClipRect(
              child: Text(
                _displayText(
                  showTitle
                      ? _stripLeadingDuplicateTitle(text, chapterTitle)
                      : text,
                ),
                textAlign: TextAlign.justify,
                style: bodyStyle,
              ),
            ),
          ),
        ],
      ),
    );
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

  String _stripLeadingDuplicateTitle(String body, String title) {
    final String normalizedBody = body.trimLeft();
    final String normalizedTitle = title.trim();
    if (normalizedTitle.isEmpty ||
        !normalizedBody.startsWith(normalizedTitle)) {
      return body;
    }

    String remaining = normalizedBody.substring(normalizedTitle.length);
    remaining = remaining.replaceFirst(RegExp(r'^[\s:：\-—_·.]+'), '');
    return remaining.trimLeft();
  }
}

class _ReaderTopBar extends StatelessWidget {
  const _ReaderTopBar({
    required this.title,
    required this.textColor,
    required this.dividerColor,
    required this.onBack,
    required this.onToc,
  });

  final String title;
  final Color textColor;
  final Color dividerColor;
  final VoidCallback onBack;
  final VoidCallback onToc;

  @override
  Widget build(BuildContext context) {
    final double topInset = MediaQuery.of(context).padding.top;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: _ReaderPageState._overlaySurface,
        border: Border(bottom: BorderSide(color: dividerColor)),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(8, topInset + 6, 8, 8),
        child: Row(
          children: <Widget>[
            _ReaderTopIconButton(
              icon: Icons.arrow_back_ios_new_rounded,
              color: textColor,
              onTap: onBack,
            ),
            Expanded(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: textColor,
                ),
              ),
            ),
            _ReaderTopIconButton(
              icon: Icons.redeem_outlined,
              color: textColor,
              onTap: () {},
            ),
            _ReaderTopIconButton(
              icon: Icons.bookmark_border_rounded,
              color: textColor,
              onTap: () {},
            ),
            _ReaderTopIconButton(
              icon: Icons.more_horiz_rounded,
              color: textColor,
              onTap: onToc,
            ),
          ],
        ),
      ),
    );
  }
}

class _ReaderTopIconButton extends StatelessWidget {
  const _ReaderTopIconButton({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: onTap,
      radius: 22,
      child: SizedBox(
        width: 40,
        height: 40,
        child: Icon(icon, color: color, size: 26),
      ),
    );
  }
}

class _ReaderPageProgress extends StatelessWidget {
  const _ReaderPageProgress({
    required this.currentPage,
    required this.totalPages,
    required this.color,
  });

  final int currentPage;
  final int totalPages;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 18,
      bottom: 16,
      child: Text(
        '$currentPage / $totalPages',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: color,
          letterSpacing: 0.6,
        ),
      ),
    );
  }
}

class _ReaderTocDrawer extends StatelessWidget {
  const _ReaderTocDrawer({
    required this.chapters,
    required this.currentChapterIndex,
    required this.onSelectChapter,
  });

  final List<ReaderChapterModel> chapters;
  final int currentChapterIndex;
  final ValueChanged<int> onSelectChapter;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: _ReaderPageState._paper,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 12),
              child: Text(
                '目录',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: _ReaderPageState._ink,
                ),
              ),
            ),
            const Divider(height: 1, color: _ReaderPageState._line),
            Expanded(
              child: ListView.builder(
                itemCount: chapters.length,
                itemBuilder: (BuildContext context, int index) {
                  final ReaderChapterModel chapter = chapters[index];
                  final bool selected = index == currentChapterIndex;
                  return ListTile(
                    selected: selected,
                    selectedColor: const Color(0xFF6B573F),
                    contentPadding: EdgeInsets.only(
                      left: 20 + (chapter.level - 1).clamp(0, 4) * 14,
                      right: 16,
                    ),
                    title: Text(
                      chapter.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text('第 ${chapter.chapterIndex + 1} 章'),
                    onTap: () => onSelectChapter(chapter.chapterIndex),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReaderSettingsPanel extends StatelessWidget {
  const _ReaderSettingsPanel({
    required this.settings,
    required this.textColor,
    required this.accentColor,
    required this.panelColor,
    required this.chipColor,
    required this.onRestoreDefaults,
    required this.onFontSizeChanged,
    required this.onLineHeightChanged,
    required this.onPageMarginChanged,
    required this.onFontChanged,
    required this.onBackgroundChanged,
    required this.onThemeModeChanged,
  });

  final _ReaderUiSettings settings;
  final Color textColor;
  final Color accentColor;
  final Color panelColor;
  final Color chipColor;
  final VoidCallback onRestoreDefaults;
  final ValueChanged<double> onFontSizeChanged;
  final ValueChanged<double> onLineHeightChanged;
  final ValueChanged<_ReaderPageMargin> onPageMarginChanged;
  final ValueChanged<_ReaderFontOption> onFontChanged;
  final ValueChanged<_ReaderBackgroundStyle> onBackgroundChanged;
  final ValueChanged<_ReaderThemeMode> onThemeModeChanged;

  @override
  Widget build(BuildContext context) {
    final double bottomInset = MediaQuery.of(context).padding.bottom;
    final _ReaderPageMargin currentMargin = _ReaderPageMargin.values.firstWhere(
      (_ReaderPageMargin item) => item.id == settings.pageMarginId,
      orElse: () => _ReaderPageMargin.comfort,
    );
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.5,
      ),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: panelColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 28,
            offset: Offset(0, -10),
          ),
        ],
      ),
      child: ColoredBox(
        color: panelColor,
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(18, 10, 18, 18 + bottomInset),
          child: Column(
            children: <Widget>[
              Container(
                width: 54,
                height: 6,
                decoration: BoxDecoration(
                  color: const Color(0xFFD9D9D9),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: <Widget>[
                  const Spacer(),
                  Text(
                    '阅读设置',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w700,
                      color: textColor,
                    ),
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: onRestoreDefaults,
                    borderRadius: BorderRadius.circular(999),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 6,
                      ),
                      child: Text(
                        '恢复默认',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: accentColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              _ReaderSettingStepperRow(
                label: '字号',
                textColor: textColor,
                valueLabel: '${settings.fontSize.round()}',
                onDecrease: () =>
                    onFontSizeChanged((settings.fontSize - 1).clamp(14, 26)),
                onIncrease: () =>
                    onFontSizeChanged((settings.fontSize + 1).clamp(14, 26)),
                chipColor: chipColor,
              ),
              const SizedBox(height: 16),
              _ReaderSettingStepperRow(
                label: '行高',
                textColor: textColor,
                valueLabel: settings.lineHeight.toStringAsFixed(2),
                onDecrease: () => onLineHeightChanged(
                  (settings.lineHeight - 0.1).clamp(1.4, 2.2),
                ),
                onIncrease: () => onLineHeightChanged(
                  (settings.lineHeight + 0.1).clamp(1.4, 2.2),
                ),
                chipColor: chipColor,
              ),
              const SizedBox(height: 18),
              _ReaderSettingStepperRow(
                label: '边距',
                textColor: textColor,
                valueLabel: currentMargin.label,
                onDecrease: () =>
                    onPageMarginChanged(_adjacentMargin(currentMargin, -1)),
                onIncrease: () =>
                    onPageMarginChanged(_adjacentMargin(currentMargin, 1)),
                chipColor: chipColor,
              ),
              const SizedBox(height: 18),
              _ReaderSettingGroupRow(
                label: '字体',
                textColor: textColor,
                child: Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: _ReaderFontOption.values
                      .map((_ReaderFontOption font) {
                        final bool selected = font.id == settings.fontId;
                        return _ReaderChoiceChip(
                          label: font.label,
                          selected: selected,
                          accentColor: accentColor,
                          chipColor: chipColor,
                          onTap: () => onFontChanged(font),
                        );
                      })
                      .toList(growable: false),
                ),
              ),
              const SizedBox(height: 18),
              _ReaderSettingGroupRow(
                label: '背景',
                textColor: textColor,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _ReaderBackgroundStyle.values
                        .map((_ReaderBackgroundStyle style) {
                          final bool selected =
                              style.id == settings.backgroundId;
                          return Padding(
                            padding: EdgeInsets.only(
                              right: style == _ReaderBackgroundStyle.values.last
                                  ? 0
                                  : 10,
                            ),
                            child: _ReaderBackgroundChip(
                              style: style,
                              selected: selected,
                              accentColor: accentColor,
                              onTap: () => onBackgroundChanged(style),
                            ),
                          );
                        })
                        .toList(growable: false),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              _ReaderSettingGroupRow(
                label: '主题模式',
                textColor: textColor,
                child: Row(
                  children: _ReaderThemeMode.values
                      .map((_ReaderThemeMode mode) {
                        final bool selected = mode == settings.themeMode;
                        return Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(
                              right: mode == _ReaderThemeMode.values.last
                                  ? 0
                                  : 10,
                            ),
                            child: _ReaderThemeModeChip(
                              mode: mode,
                              selected: selected,
                              accentColor: accentColor,
                              chipColor: chipColor,
                              onTap: () => onThemeModeChanged(mode),
                            ),
                          ),
                        );
                      })
                      .toList(growable: false),
                ),
              ),
              const SizedBox(height: 22),
              const Divider(height: 1, color: Color(0xFFEDEAE4)),
              const SizedBox(height: 12),
              InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(16),
                child: SizedBox(
                  height: 52,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        '更多设置',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Icon(
                        Icons.chevron_right_rounded,
                        color: textColor,
                        size: 22,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _ReaderPageMargin _adjacentMargin(_ReaderPageMargin current, int step) {
    final int currentIndex = _ReaderPageMargin.values.indexOf(current);
    final int nextIndex = (currentIndex + step).clamp(
      0,
      _ReaderPageMargin.values.length - 1,
    );
    return _ReaderPageMargin.values[nextIndex];
  }
}

class _ReaderSettingStepperRow extends StatelessWidget {
  const _ReaderSettingStepperRow({
    required this.label,
    required this.textColor,
    required this.valueLabel,
    required this.onDecrease,
    required this.onIncrease,
    required this.chipColor,
  });

  final String label;
  final Color textColor;
  final String valueLabel;
  final VoidCallback onDecrease;
  final VoidCallback onIncrease;
  final Color chipColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        SizedBox(
          width: 54,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: textColor,
            ),
          ),
        ),
        const SizedBox(width: 10),
        _ReaderStepButton(label: '-', chipColor: chipColor, onTap: onDecrease),
        const SizedBox(width: 10),
        Expanded(
          child: Container(
            height: 48,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: chipColor,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(
              valueLabel,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        _ReaderStepButton(label: '+', chipColor: chipColor, onTap: onIncrease),
      ],
    );
  }
}

class _ReaderSettingGroupRow extends StatelessWidget {
  const _ReaderSettingGroupRow({
    required this.label,
    required this.textColor,
    required this.child,
  });

  final String label;
  final Color textColor;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          width: 54,
          child: Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: textColor,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(child: child),
      ],
    );
  }
}

class _ReaderStepButton extends StatelessWidget {
  const _ReaderStepButton({
    required this.label,
    required this.chipColor,
    required this.onTap,
  });

  final String label;
  final Color chipColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return _ReaderChoiceSurface(
      width: 52,
      height: 48,
      onTap: onTap,
      chipColor: chipColor,
      child: Text(
        label,
        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
      ),
    );
  }
}

class _ReaderChoiceChip extends StatelessWidget {
  const _ReaderChoiceChip({
    required this.label,
    required this.selected,
    required this.accentColor,
    required this.chipColor,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final Color accentColor;
  final Color chipColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return _ReaderChoiceSurface(
      width: 104,
      height: 48,
      onTap: onTap,
      selected: selected,
      accentColor: accentColor,
      chipColor: chipColor,
      child: Text(
        label,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: selected ? accentColor : const Color(0xFF222222),
        ),
      ),
    );
  }
}

class _ReaderThemeModeChip extends StatelessWidget {
  const _ReaderThemeModeChip({
    required this.mode,
    required this.selected,
    required this.accentColor,
    required this.chipColor,
    required this.onTap,
  });

  final _ReaderThemeMode mode;
  final bool selected;
  final Color accentColor;
  final Color chipColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return _ReaderChoiceSurface(
      width: double.infinity,
      height: 52,
      onTap: onTap,
      selected: selected,
      accentColor: accentColor,
      chipColor: chipColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(mode.icon, size: 22, color: selected ? accentColor : null),
          const SizedBox(width: 8),
          Text(
            mode.label,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: selected ? accentColor : const Color(0xFF222222),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReaderBackgroundChip extends StatelessWidget {
  const _ReaderBackgroundChip({
    required this.style,
    required this.selected,
    required this.accentColor,
    required this.onTap,
  });

  final _ReaderBackgroundStyle style;
  final bool selected;
  final Color accentColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final bool isDark = style.color.computeLuminance() < 0.25;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: style.color,
          border: Border.all(
            color: selected ? accentColor : Colors.transparent,
            width: 2,
          ),
        ),
        child: style.id == _ReaderBackgroundStyle.midnight.id
            ? Icon(Icons.dark_mode_rounded, color: isDark ? Colors.white : null)
            : null,
      ),
    );
  }
}

class _ReaderChoiceSurface extends StatelessWidget {
  const _ReaderChoiceSurface({
    required this.width,
    required this.height,
    required this.onTap,
    required this.child,
    this.selected = false,
    this.accentColor = const Color(0xFF2E9D62),
    this.chipColor = _ReaderPageState._overlayChipSurface,
  });

  final double width;
  final double height;
  final VoidCallback onTap;
  final Widget child;
  final bool selected;
  final Color accentColor;
  final Color chipColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: width,
        height: height,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: chipColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? accentColor : Colors.transparent,
          ),
        ),
        child: child,
      ),
    );
  }
}

class _ReaderUiSettings {
  const _ReaderUiSettings({
    required this.fontSize,
    required this.lineHeight,
    required this.pageMarginId,
    required this.fontId,
    required this.backgroundId,
    required this.themeMode,
  });

  factory _ReaderUiSettings.defaults() {
    return const _ReaderUiSettings(
      fontSize: 18,
      lineHeight: 1.78,
      pageMarginId: 'comfort',
      fontId: 'system',
      backgroundId: 'paper',
      themeMode: _ReaderThemeMode.day,
    );
  }

  factory _ReaderUiSettings.fromModel(ReaderSettingsModel model) {
    return _ReaderUiSettings(
      fontSize: model.fontSize,
      lineHeight: model.lineHeight,
      pageMarginId:
          _ReaderPageMargin.values.any(
            (_ReaderPageMargin margin) =>
                margin.horizontalPadding == model.horizontalPadding,
          )
          ? _ReaderPageMargin.values
                .firstWhere(
                  (_ReaderPageMargin margin) =>
                      margin.horizontalPadding == model.horizontalPadding,
                )
                .id
          : 'comfort',
      fontId:
          _ReaderFontOption.values.any(
            (_ReaderFontOption font) => font.id == model.fontFamilyId,
          )
          ? model.fontFamilyId
          : 'system',
      backgroundId:
          _ReaderBackgroundStyle.values.any(
            (_ReaderBackgroundStyle background) =>
                background.id == model.backgroundStyleId,
          )
          ? model.backgroundStyleId
          : 'paper',
      themeMode: _ReaderThemeMode.values.firstWhere(
        (_ReaderThemeMode mode) => mode.name == model.themeMode,
        orElse: () => _ReaderThemeMode.day,
      ),
    );
  }

  final double fontSize;
  final double lineHeight;
  final String pageMarginId;
  final String fontId;
  final String backgroundId;
  final _ReaderThemeMode themeMode;

  double get renderFontSize => fontSize + 12;

  int get firstPageCharLimit {
    final _ReaderPageMargin margin = _ReaderPageMargin.values.firstWhere(
      (_ReaderPageMargin item) => item.id == pageMarginId,
      orElse: () => _ReaderPageMargin.comfort,
    );
    final double density =
        ((26 - fontSize) / 8).clamp(0.55, 1.5) *
        (1.9 / lineHeight).clamp(0.75, 1.2) *
        (26 / margin.horizontalPadding).clamp(0.72, 1.18);
    return (900 * density).round().clamp(420, 1300);
  }

  int get followingPageCharLimit {
    final double following = firstPageCharLimit * 1.18;
    return following.round().clamp(520, 1480);
  }

  ReaderSettingsModel toModel() {
    final _ReaderPageMargin margin = _ReaderPageMargin.values.firstWhere(
      (_ReaderPageMargin item) => item.id == pageMarginId,
      orElse: () => _ReaderPageMargin.comfort,
    );
    return ReaderSettingsModel(
      themeMode: themeMode.name,
      backgroundStyleId: backgroundId,
      fontFamilyId: fontId,
      fontSize: fontSize,
      lineHeight: lineHeight,
      horizontalPadding: margin.horizontalPadding,
    );
  }

  _ReaderUiSettings copyWith({
    double? fontSize,
    double? lineHeight,
    String? pageMarginId,
    String? fontId,
    String? backgroundId,
    _ReaderThemeMode? themeMode,
  }) {
    return _ReaderUiSettings(
      fontSize: fontSize ?? this.fontSize,
      lineHeight: lineHeight ?? this.lineHeight,
      pageMarginId: pageMarginId ?? this.pageMarginId,
      fontId: fontId ?? this.fontId,
      backgroundId: backgroundId ?? this.backgroundId,
      themeMode: themeMode ?? this.themeMode,
    );
  }
}

enum _ReaderThemeMode {
  day('日间', Icons.light_mode_outlined),
  night('夜间', Icons.dark_mode_outlined),
  system('跟随系统', Icons.desktop_windows_outlined);

  const _ReaderThemeMode(this.label, this.icon);

  final String label;
  final IconData icon;
}

enum _ReaderFontOption {
  system('system', '系统默认', null, <String>[
    'PingFang SC',
    'Noto Sans CJK SC',
    'Microsoft YaHei',
  ]),
  sans('sans', '思源黑体', 'ReaderNotoSansSC', <String>[
    'PingFang SC',
    'Noto Sans CJK SC',
    'Microsoft YaHei',
    'sans-serif',
  ]),
  song('song', '思源宋体', 'ReaderNotoSerifSC', <String>[
    'Songti SC',
    'STSong',
    'Noto Serif CJK SC',
    'serif',
  ]),
  wenkai('wenkai', '霞鹜文楷', 'ReaderLXGWWenKai', <String>[
    'Kaiti SC',
    'STKaiti',
    'KaiTi',
    'serif',
  ]),
  mono('mono', '等宽', 'Menlo', <String>['SF Mono', 'Roboto Mono', 'monospace']);

  const _ReaderFontOption(
    this.id,
    this.label,
    this.fontFamily,
    this.fontFamilyFallback,
  );

  final String id;
  final String label;
  final String? fontFamily;
  final List<String> fontFamilyFallback;
}

enum _ReaderPageMargin {
  compact('compact', '紧凑', 20),
  comfort('comfort', '适中', 26),
  relaxed('relaxed', '舒适', 32),
  wide('wide', '宽松', 38),
  extra('extra', '极宽', 44);

  const _ReaderPageMargin(this.id, this.label, this.horizontalPadding);

  final String id;
  final String label;
  final double horizontalPadding;
}

enum _ReaderBackgroundStyle {
  paper('paper', Color(0xFFF6F1E9), Color(0xFF111111), Color(0xFF8C918B)),
  mist('mist', Color(0xFFF5F5F3), Color(0xFF1D1D1D), Color(0xFF898989)),
  wheat('wheat', Color(0xFFF3E2C5), Color(0xFF251E14), Color(0xFF85705A)),
  sage('sage', Color(0xFFDCE6D5), Color(0xFF1D281F), Color(0xFF647065)),
  fog('fog', Color(0xFFD9D9DD), Color(0xFF212121), Color(0xFF666872)),
  charcoal('charcoal', Color(0xFF6B6B6D), Color(0xFFF7F7F7), Color(0xFFD4D4D4)),
  midnight('midnight', Color(0xFF111111), Color(0xFFF5F5F5), Color(0xFFBBBBBB));

  const _ReaderBackgroundStyle(
    this.id,
    this.color,
    this.textColor,
    this.mutedColor,
  );

  final String id;
  final Color color;
  final Color textColor;
  final Color mutedColor;
}

class _ReaderMessageState extends StatelessWidget {
  const _ReaderMessageState({
    required this.title,
    required this.message,
    this.primaryLabel,
    this.onPrimaryAction,
  });

  final String title;
  final String message;
  final String? primaryLabel;
  final VoidCallback? onPrimaryAction;

  @override
  Widget build(BuildContext context) {
    return UxStateView(
      icon: Icons.chrome_reader_mode_outlined,
      title: title,
      message: message,
      primaryAction: primaryLabel == null || onPrimaryAction == null
          ? null
          : UxStateAction(label: primaryLabel!, onPressed: onPrimaryAction!),
      secondaryAction: UxStateAction(
        label: '返回书架',
        onPressed: () {
          Navigator.of(context).maybePop();
        },
        filled: false,
      ),
      iconBackgroundColor: const Color(0xFFF1EBDD),
      iconColor: const Color(0xFF8C7A62),
      titleColor: _ReaderPageState._ink,
      messageColor: _ReaderPageState._muted,
      primaryColor: const Color(0xFF6B573F),
      outlineColor: const Color(0xFFD5C6B2),
      scrollable: true,
      padding: const EdgeInsets.fromLTRB(24, 56, 24, 56),
    );
  }
}

class _ReaderPreparingState extends StatelessWidget {
  const _ReaderPreparingState({required this.detail});

  final ReaderBookDetail? detail;

  @override
  Widget build(BuildContext context) {
    final String? coverImagePath = detail?.book.coverImagePath;
    final String? existingCoverImagePath =
        coverImagePath != null && File(coverImagePath).existsSync()
        ? coverImagePath
        : null;
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[Color(0xFFF7F2E8), Color(0xFFEAE0CF)],
        ),
      ),
      child: Center(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 220),
          child: existingCoverImagePath != null
              ? Container(
                  key: ValueKey<String>(existingCoverImagePath),
                  width: 168,
                  height: 236,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const <BoxShadow>[
                      BoxShadow(
                        color: Color(0x22000000),
                        blurRadius: 24,
                        offset: Offset(0, 12),
                      ),
                    ],
                  ),
                  child: Image.file(
                    File(existingCoverImagePath),
                    fit: BoxFit.cover,
                  ),
                )
              : Container(
                  key: const ValueKey<String>('reader-placeholder-cover'),
                  width: 168,
                  height: 236,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: <Color>[Color(0xFFD9C6A5), Color(0xFFB79B70)],
                    ),
                    boxShadow: const <BoxShadow>[
                      BoxShadow(
                        color: Color(0x22000000),
                        blurRadius: 24,
                        offset: Offset(0, 12),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}

class _ReaderPageEntry {
  const _ReaderPageEntry({
    required this.chapter,
    required this.pageInChapter,
    required this.pageCountInChapter,
    required this.chapterTextStart,
    required this.chapterTextEnd,
    required this.globalReadableOffset,
    required this.content,
    required this.showsTitle,
  });

  factory _ReaderPageEntry.anchor({
    required ReaderChapterModel chapter,
    int chapterTextStart = 0,
  }) {
    return _ReaderPageEntry(
      chapter: chapter,
      pageInChapter: 0,
      pageCountInChapter: 1,
      chapterTextStart: chapterTextStart,
      chapterTextEnd: chapterTextStart,
      globalReadableOffset: 0,
      content: '',
      showsTitle: false,
    );
  }

  final ReaderChapterModel chapter;
  final int pageInChapter;
  final int pageCountInChapter;
  final int chapterTextStart;
  final int chapterTextEnd;
  final int globalReadableOffset;
  final String content;
  final bool showsTitle;

  _ReaderPageEntry copyWith({int? globalReadableOffset}) {
    return _ReaderPageEntry(
      chapter: chapter,
      pageInChapter: pageInChapter,
      pageCountInChapter: pageCountInChapter,
      chapterTextStart: chapterTextStart,
      chapterTextEnd: chapterTextEnd,
      globalReadableOffset: globalReadableOffset ?? this.globalReadableOffset,
      content: content,
      showsTitle: showsTitle,
    );
  }
}

class _ReaderTextSlice {
  const _ReaderTextSlice({required this.start, required this.end});

  final int start;
  final int end;
}

class _ReaderPageLayout {
  const _ReaderPageLayout({
    required this.contentWidth,
    required this.firstPageBodyHeight,
    required this.followingPageBodyHeight,
  });

  final double contentWidth;
  final double firstPageBodyHeight;
  final double followingPageBodyHeight;
}

class _ReaderLayoutSnapshot {
  const _ReaderLayoutSnapshot({
    required this.viewportSize,
    required this.textScaler,
  });

  final Size viewportSize;
  final TextScaler textScaler;
}
