import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:pocketread/core/widgets/ux_state_view.dart';
import 'package:pocketread/data/repositories/reader_repository.dart';
import 'package:pocketread/features/reader/application/reader_launch_warmup_service.dart';
import 'package:pocketread/features/reader/application/reader_providers.dart';
import 'package:pocketread/features/reader/domain/reader_models.dart';

part 'reader_pagination_engine.dart';
part 'reader_pagination_disk_cache.dart';
part 'reader_performance_log.dart';

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
  static const int _readerWindowLookAheadChapters = 2;

  PageController _pageController = PageController(keepPage: false);
  int _pageControllerRevision = 0;

  late final ReaderRepository _readerRepository;
  ReaderBookDetail? _detail;
  List<_ReaderPageEntry> _pages = const <_ReaderPageEntry>[];
  _ReaderUiSettings _settings = _ReaderUiSettings.defaults();
  int _globalPageIndex = 0;
  final ValueNotifier<int> _visiblePageIndexNotifier = ValueNotifier<int>(0);
  bool _chromeVisible = false;
  _ReaderBottomPanelTab _bottomPanelTab = _ReaderBottomPanelTab.menu;
  bool _tocVisible = false;
  bool _loading = true;
  bool _preserveChromeOnNextPageChange = false;
  String? _errorMessage;
  String? _paginationSignature;
  _ReaderPageEntry? _paginationAnchor;
  _ReaderLayoutSnapshot? _layoutSnapshot;
  int _totalReadableLengthCache = 0;
  final Set<String> _queuedPrepaginationKeys = <String>{};
  int _prepaginationRevision = 0;
  Timer? _saveDebounce;
  Timer? _pageWindowSyncDebounce;
  Timer? _prepaginationDebounce;
  Timer? _settingsSaveDebounce;
  DateTime _openedAt = DateTime.now();

  @override
  void initState() {
    super.initState();
    _readerRepository = ref.read(readerRepositoryProvider);
    WidgetsBinding.instance.addObserver(this);
    unawaited(_ReaderPaginationDiskCache.initialize(widget.bookId));
    _loadReader();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _saveDebounce?.cancel();
    _pageWindowSyncDebounce?.cancel();
    _prepaginationDebounce?.cancel();
    _settingsSaveDebounce?.cancel();
    unawaited(_persistSettingsOnDispose());
    unawaited(_saveProgressSafely());
    _visiblePageIndexNotifier.dispose();
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
      final int totalReadableLength = _calculateTotalReadableLength(detail);
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
                totalReadableLength: totalReadableLength,
                settings: savedSettings,
              ),
            );
      final List<_ReaderPageEntry> preparedPages = preparedLaunch == null
          ? const <_ReaderPageEntry>[]
          : _pageEntriesFromWarmup(detail, preparedLaunch);
      final int preparedPageIndex = (preparedLaunch?.initialPageIndex ?? 0)
          .clamp(0, math.max(0, preparedPages.length - 1));
      if (preparedPages.isNotEmpty) {
        _replacePageController(initialPage: preparedPageIndex);
      }

      setState(() {
        _settings = loadedSettings;
        _detail = detail;
        _totalReadableLengthCache = totalReadableLength;
        _pages = preparedPages;
        _setGlobalPageIndex(preparedPageIndex);
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
    return _ReaderPaginationEngine.buildChapterPages(
      chapter: chapter,
      text: _readableText(chapter),
      globalReadableOffset: _readableOffsetBeforeChapter(chapter.chapterIndex),
      layout: _pageLayoutFor(settings, viewportSize, context),
      bodyStyle: _bodyTextStyle(settings, context),
      textScaler: textScaler,
    );
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
    return _ReaderPaginationEngine.pageIndexForChapterOffset(
      pages,
      chapterIndex,
      chapterOffset,
    );
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
    if (!mounted) {
      _globalPageIndex = index;
      return;
    }
    _setGlobalPageIndex(index);
    if (_chromeVisible || _preserveChromeOnNextPageChange) {
      setState(() {
        if (_preserveChromeOnNextPageChange) {
          _preserveChromeOnNextPageChange = false;
        } else {
          _chromeVisible = false;
        }
      });
    }
    _saveDebounce?.cancel();
    _saveDebounce = Timer(const Duration(milliseconds: 700), _saveProgress);
    _schedulePageWindowSync();
    _schedulePrepaginationAroundCurrentPage();
  }

  void _setGlobalPageIndex(int index) {
    _globalPageIndex = index;
    if (_visiblePageIndexNotifier.value != index) {
      _visiblePageIndexNotifier.value = index;
    }
  }

  void _schedulePageWindowSync() {
    _pageWindowSyncDebounce?.cancel();
    _pageWindowSyncDebounce = Timer(
      const Duration(milliseconds: 180),
      _syncPageWindowWhenIdle,
    );
  }

  void _syncPageWindowWhenIdle() {
    if (!mounted) {
      return;
    }
    if (_pageController.hasClients &&
        _pageController.position.isScrollingNotifier.value) {
      _pageWindowSyncDebounce = Timer(
        const Duration(milliseconds: 80),
        _syncPageWindowWhenIdle,
      );
      return;
    }
    _syncPageWindowToCurrentChapter();
  }

  void _syncPageWindowToCurrentChapter() {
    final ReaderBookDetail? detail = _detail;
    final String? signature = _paginationSignature;
    final _ReaderLayoutSnapshot? snapshot = _layoutSnapshot;
    if (detail == null ||
        signature == null ||
        snapshot == null ||
        _pages.isEmpty) {
      return;
    }

    final _ReaderPageEntry currentEntry =
        _pages[_globalPageIndex.clamp(0, math.max(0, _pages.length - 1))];
    final List<int> missingChapterIndices =
        _ReaderPaginationEngine.missingWindowChapterIndices(
          detail: detail,
          currentPages: _pages,
          centerChapterIndex: currentEntry.chapter.chapterIndex,
          lookAheadChapters: _readerWindowLookAheadChapters,
        );
    if (missingChapterIndices.isEmpty) {
      return;
    }

    final int lastCurrentChapterIndex = _pages.last.chapter.chapterIndex;
    final List<_ReaderPageEntry> appendPages = <_ReaderPageEntry>[];
    for (final int chapterIndex in missingChapterIndices) {
      if (chapterIndex <= lastCurrentChapterIndex) {
        continue;
      }
      final ReaderChapterModel? chapter = _chapterByIndex(chapterIndex);
      if (chapter == null) {
        continue;
      }
      final List<_ReaderPageEntry> chapterPages = _chapterPagesFor(
        chapter: chapter,
        signature: signature,
        settings: _settings,
        viewportSize: snapshot.viewportSize,
        textScaler: snapshot.textScaler,
        context: context,
      );
      appendPages.addAll(chapterPages);
    }
    if (appendPages.isEmpty) {
      return;
    }
    final int previousPageIndex = _globalPageIndex;
    setState(() {
      _pages = <_ReaderPageEntry>[..._pages, ...appendPages];
      _setGlobalPageIndex(
        previousPageIndex.clamp(0, math.max(0, _pages.length - 1)),
      );
    });
  }

  Future<void> _saveProgress() async {
    final ReaderBookDetail? detail = _detail;
    if (detail == null || _pages.isEmpty) {
      return;
    }

    final _ReaderPageEntry entry =
        _pages[_globalPageIndex.clamp(0, math.max(0, _pages.length - 1))];
    final ReaderChapterModel chapter = entry.chapter;
    final double progressPercent = _progressPercentForEntry(
      entry,
      _totalReadableLengthCache,
    );
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

  double _progressPercentForEntry(
    _ReaderPageEntry entry,
    int totalReadableLength,
  ) {
    if (totalReadableLength <= 0) {
      return 0;
    }
    final int chapterProgressOffset = math.max(
      entry.chapterTextStart + 1,
      entry.chapterTextEnd,
    );
    final int globalOffset = entry.globalReadableOffset + chapterProgressOffset;
    return (globalOffset / totalReadableLength).clamp(0, 1);
  }

  int _calculateTotalReadableLength(ReaderBookDetail detail) {
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
    unawaited(_saveProgressSafely());
    _pageWindowSyncDebounce?.cancel();
    final ReaderChapterModel? chapter = _chapterByIndex(chapterIndex);
    if (chapter == null) {
      return;
    }
    if (_jumpToChapterFromCurrentLayout(chapterIndex)) {
      return;
    }
    _paginationAnchor = _ReaderPageEntry.anchor(chapter: chapter);
    _paginationSignature = null;
    _ensurePaginationFromLastLayout();
  }

  void _replacePageController({
    required int initialPage,
    int? animateToPage,
    Duration duration = const Duration(milliseconds: 220),
    Curve curve = Curves.easeOutCubic,
  }) {
    final PageController previousController = _pageController;
    final PageController nextController = PageController(
      initialPage: initialPage,
      keepPage: false,
    );
    _pageController = nextController;
    _pageControllerRevision += 1;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      previousController.dispose();
      if (!mounted ||
          !identical(_pageController, nextController) ||
          !nextController.hasClients) {
        return;
      }
      if (animateToPage != null && animateToPage != initialPage) {
        nextController.animateToPage(
          animateToPage,
          duration: duration,
          curve: curve,
        );
      }
    });
  }

  bool _jumpToChapterFromCurrentLayout(int chapterIndex) {
    final ReaderBookDetail? detail = _detail;
    final String? signature = _paginationSignature;
    final _ReaderLayoutSnapshot? snapshot = _layoutSnapshot;
    if (detail == null || signature == null || snapshot == null) {
      return false;
    }

    final Stopwatch jumpStopwatch = Stopwatch()..start();
    final List<_ReaderPageEntry> nextPages = _composeFocusedChapterWindow(
      detail: detail,
      chapterIndex: chapterIndex,
      signature: signature,
      settings: _settings,
      viewportSize: snapshot.viewportSize,
      textScaler: snapshot.textScaler,
      context: context,
    );
    if (nextPages.isEmpty) {
      _ReaderPerformanceLog.log(
        'toc_jump_empty',
        fields: <String, Object?>{'chapterIndex': chapterIndex},
      );
      return false;
    }

    final int nextIndex = _pageIndexForChapterOffset(
      nextPages,
      chapterIndex,
      0,
    ).clamp(0, math.max(0, nextPages.length - 1));

    setState(() {
      _invalidatePrepaginationQueue();
      _replacePageController(initialPage: nextIndex);
      _pages = nextPages;
      _setGlobalPageIndex(nextIndex);
      _paginationAnchor = null;
      _tocVisible = false;
      _chromeVisible = false;
      _bottomPanelTab = _ReaderBottomPanelTab.menu;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || nextPages.isEmpty) {
        return;
      }
      _schedulePrepaginationAroundCurrentPage();
    });
    _ReaderPerformanceLog.log(
      'toc_jump',
      fields: <String, Object?>{
        'chapterIndex': chapterIndex,
        'pageIndex': nextIndex,
        'windowPages': nextPages.length,
        'durationMs': jumpStopwatch.elapsedMilliseconds,
        'mode': 'focused',
      },
    );
    return true;
  }

  void _handleTapUp(TapUpDetails details, BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double dx = details.localPosition.dx;
    final double leftBound = width * 0.33;
    final double rightBound = width * 0.67;
    if (dx < leftBound) {
      _goToAdjacentPage(_settings.leftTapAction == 'next_page' ? 1 : -1);
      return;
    }
    if (dx > rightBound) {
      _goToAdjacentPage(1);
      return;
    }
    setState(() {
      _chromeVisible = !_chromeVisible;
      if (_chromeVisible) {
        _bottomPanelTab = _ReaderBottomPanelTab.menu;
      }
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
      _bottomPanelTab = _ReaderBottomPanelTab.menu;
      _setGlobalPageIndex(targetIndex);
    });
    if (_pageController.hasClients) {
      _pageController.animateToPage(
        targetIndex,
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
      );
    }
    _schedulePrepaginationAroundCurrentPage();
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
    final Stopwatch chapterSwitchStopwatch = Stopwatch()..start();
    final List<_ReaderPageEntry> nextPages = _composeChapterTransitionWindow(
      detail: detail,
      fromChapterIndex: currentEntry.chapter.chapterIndex,
      targetChapterIndex: targetChapterIndex,
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
      _invalidatePrepaginationQueue();
      _replacePageController(
        initialPage: currentIndexInNextPages,
        animateToPage: nextIndex,
      );
      _pages = nextPages;
      _setGlobalPageIndex(currentIndexInNextPages);
      _chromeVisible = false;
      _bottomPanelTab = _ReaderBottomPanelTab.menu;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _schedulePrepaginationAroundCurrentPage();
    });
    _ReaderPerformanceLog.log(
      'adjacent_chapter',
      fields: <String, Object?>{
        'direction': delta,
        'fromChapter': currentEntry.chapter.chapterIndex,
        'targetChapter': targetChapterIndex,
        'fromPageIndex': currentIndexInNextPages,
        'targetPageIndex': nextIndex,
        'windowPages': nextPages.length,
        'durationMs': chapterSwitchStopwatch.elapsedMilliseconds,
        'mode': 'transition',
      },
    );
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
    if (!mounted) {
      return;
    }
    setState(() {
      _chromeVisible = false;
      _bottomPanelTab = _ReaderBottomPanelTab.menu;
      _tocVisible = true;
    });
  }

  void _closeToc() {
    if (!mounted) {
      return;
    }
    setState(() {
      _tocVisible = false;
    });
  }

  void _updateSettings(_ReaderUiSettings settings) {
    _rebuildPagesForSettings(settings);
  }

  void _restoreDefaultSettings() {
    _rebuildPagesForSettings(_ReaderUiSettings.defaults());
  }

  Future<void> _persistSettingsOnDispose() async {
    try {
      await _readerRepository.saveReaderSettings(_settings.toModel());
    } catch (_) {
      // Ignore teardown races in test/unmount paths.
    }
  }

  Future<void> _saveProgressSafely() async {
    try {
      await _saveProgress();
    } catch (_) {
      // Ignore teardown races in test/unmount paths.
    }
  }

  void _rebuildPagesForSettings(_ReaderUiSettings nextSettings) {
    final _ReaderPageEntry? currentEntry = _pages.isEmpty
        ? null
        : _pages[_globalPageIndex.clamp(0, _pages.length - 1)];
    setState(() {
      _invalidatePrepaginationQueue();
      _settings = nextSettings;
      _paginationSignature = null;
      _paginationAnchor = currentEntry;
      _preserveChromeOnNextPageChange = true;
      if (currentEntry != null) {
        _setGlobalPageIndex(0);
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
    final String signature = _ReaderPaginationEngine.paginationKey(
      viewportSize: viewportSize,
      settings: _settings,
      textScaler: textScaler,
      bookId: detail.book.id,
      chapterCount: detail.chapters.length,
      totalReadableLength: _totalReadableLengthCache,
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
        final int nextIndex = preparedLaunch.initialPageIndex.clamp(
          0,
          math.max(0, pages.length - 1),
        );
        setState(() {
          if (pages.isNotEmpty) {
            _replacePageController(initialPage: nextIndex);
          }
          _pages = pages;
          _setGlobalPageIndex(nextIndex);
          _paginationSignature = signature;
          _paginationAnchor = null;
        });
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _schedulePrepaginationAroundCurrentPage();
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
        if (pages.isNotEmpty) {
          _replacePageController(initialPage: nextIndex);
        }
        _pages = pages;
        _setGlobalPageIndex(nextIndex);
        _paginationSignature = signature;
        _paginationAnchor = null;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _schedulePrepaginationAroundCurrentPage();
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
    return _ReaderPerformanceLog.track(
      'compose_window',
      () {
        final List<int> orderedIndices =
            _ReaderPaginationEngine.availableWindowChapterIndices(
              detail: detail,
              centerChapterIndex: centerChapterIndex,
              lookAheadChapters: _readerWindowLookAheadChapters,
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
      },
      fields: <String, Object?>{
        'bookId': detail.book.id,
        'centerChapter': centerChapterIndex,
        'chapters': detail.chapters.length,
      },
    );
  }

  List<_ReaderPageEntry> _composeFocusedChapterWindow({
    required ReaderBookDetail detail,
    required int chapterIndex,
    required String signature,
    required _ReaderUiSettings settings,
    required Size viewportSize,
    required TextScaler textScaler,
    required BuildContext context,
  }) {
    return _ReaderPerformanceLog.track(
      'compose_focused_window',
      () {
        final ReaderChapterModel? chapter = _chapterByIndex(chapterIndex);
        if (chapter == null) {
          return const <_ReaderPageEntry>[];
        }
        return _chapterPagesFor(
          chapter: chapter,
          signature: signature,
          settings: settings,
          viewportSize: viewportSize,
          textScaler: textScaler,
          context: context,
        );
      },
      fields: <String, Object?>{
        'bookId': detail.book.id,
        'chapterIndex': chapterIndex,
        'chapters': detail.chapters.length,
      },
    );
  }

  List<_ReaderPageEntry> _composeChapterTransitionWindow({
    required ReaderBookDetail detail,
    required int fromChapterIndex,
    required int targetChapterIndex,
    required String signature,
    required _ReaderUiSettings settings,
    required Size viewportSize,
    required TextScaler textScaler,
    required BuildContext context,
  }) {
    return _ReaderPerformanceLog.track(
      'compose_transition_window',
      () {
        final int firstChapterIndex = math.min(
          fromChapterIndex,
          targetChapterIndex,
        );
        final int lastChapterIndex = math.max(
          fromChapterIndex,
          targetChapterIndex,
        );
        final List<_ReaderPageEntry> pages = <_ReaderPageEntry>[];
        for (
          int chapterIndex = firstChapterIndex;
          chapterIndex <= lastChapterIndex;
          chapterIndex += 1
        ) {
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
      },
      fields: <String, Object?>{
        'bookId': detail.book.id,
        'fromChapter': fromChapterIndex,
        'targetChapter': targetChapterIndex,
        'chapters': detail.chapters.length,
      },
    );
  }

  List<_ReaderPageEntry> _chapterPagesFor({
    required ReaderChapterModel chapter,
    required String signature,
    required _ReaderUiSettings settings,
    required Size viewportSize,
    required TextScaler textScaler,
    required BuildContext context,
  }) {
    final String cacheKey = _ReaderPaginationEngine.chapterPaginationKey(
      signature,
      chapter.chapterIndex,
    );
    final List<_ReaderPageEntry>? cachedPages =
        _ReaderPaginationEngine.cachedChapterPages(cacheKey);
    if (cachedPages != null) {
      _ReaderPerformanceLog.log(
        'chapter_pages_cache_hit',
        fields: <String, Object?>{
          'chapterIndex': chapter.chapterIndex,
          'pages': cachedPages.length,
        },
      );
      return cachedPages;
    }
    final int readableTextLength = _readableText(chapter).trim().length;
    final List<_ReaderPageEntry>? diskCachedPages =
        _ReaderPaginationDiskCache.load(
          cacheKey: cacheKey,
          chapter: chapter,
          textLength: readableTextLength,
        );
    if (diskCachedPages != null) {
      _ReaderPaginationEngine.touchChapterPagination(cacheKey, diskCachedPages);
      _ReaderPerformanceLog.log(
        'chapter_pages_disk_cache_hit',
        fields: <String, Object?>{
          'chapterIndex': chapter.chapterIndex,
          'pages': diskCachedPages.length,
        },
      );
      return diskCachedPages;
    }
    final List<_ReaderPageEntry> pages = _ReaderPerformanceLog.track(
      'paginate_chapter',
      () {
        return _buildChapterPages(
          chapter,
          settings,
          viewportSize,
          textScaler,
          context,
        );
      },
      fields: <String, Object?>{
        'chapterIndex': chapter.chapterIndex,
        'textLength': readableTextLength,
        'viewport':
            '${viewportSize.width.round()}x${viewportSize.height.round()}',
        'fontSize': settings.fontSize,
        'lineHeight': settings.lineHeight,
        'font': settings.fontId,
      },
    );
    _ReaderPerformanceLog.log(
      'paginate_chapter_result',
      fields: <String, Object?>{
        'chapterIndex': chapter.chapterIndex,
        'pages': pages.length,
      },
    );
    _ReaderPaginationEngine.touchChapterPagination(cacheKey, pages);
    _ReaderPaginationDiskCache.store(
      cacheKey: cacheKey,
      chapter: chapter,
      textLength: readableTextLength,
      pages: pages,
    );
    return pages;
  }

  void _prepaginateAroundCurrentPage() {
    final ReaderBookDetail? detail = _detail;
    final String? signature = _paginationSignature;
    final _ReaderLayoutSnapshot? snapshot = _layoutSnapshot;
    if (detail == null ||
        _pages.isEmpty ||
        signature == null ||
        snapshot == null) {
      return;
    }
    final _ReaderPageEntry entry =
        _pages[_globalPageIndex.clamp(0, math.max(0, _pages.length - 1))];
    final int chapterIndex = entry.chapter.chapterIndex;
    final int scheduledRevision = _prepaginationRevision;
    final List<int> targets = <int>[
      if (chapterIndex > 0) chapterIndex - 1,
      if (chapterIndex < detail.chapters.length - 1) chapterIndex + 1,
      if (chapterIndex < detail.chapters.length - 2) chapterIndex + 2,
    ];
    for (final int target in targets) {
      final String cacheKey = _ReaderPaginationEngine.chapterPaginationKey(
        signature,
        target,
      );
      if (_ReaderPaginationEngine.hasCachedChapterPages(cacheKey) ||
          _queuedPrepaginationKeys.contains(cacheKey)) {
        continue;
      }
      _queuedPrepaginationKeys.add(cacheKey);
      unawaited(
        SchedulerBinding.instance.scheduleTask<void>(
          () {
            if (!mounted ||
                _paginationSignature != signature ||
                _prepaginationRevision != scheduledRevision) {
              _queuedPrepaginationKeys.remove(cacheKey);
              return;
            }
            final ReaderChapterModel? chapter = _chapterByIndex(target);
            if (chapter == null) {
              _queuedPrepaginationKeys.remove(cacheKey);
              return;
            }
            _ReaderPerformanceLog.track(
              'prepaginate_chapter',
              () {
                _chapterPagesFor(
                  chapter: chapter,
                  signature: signature,
                  settings: _settings,
                  viewportSize: snapshot.viewportSize,
                  textScaler: snapshot.textScaler,
                  context: context,
                );
              },
              fields: <String, Object?>{
                'fromChapter': chapterIndex,
                'targetChapter': target,
              },
            );
            _queuedPrepaginationKeys.remove(cacheKey);
          },
          Priority.idle,
          debugLabel: 'reader prepaginate chapter $target',
        ),
      );
    }
  }

  void _schedulePrepaginationAroundCurrentPage() {
    _prepaginationDebounce?.cancel();
    _prepaginationDebounce = Timer(const Duration(milliseconds: 420), () {
      if (!mounted) {
        return;
      }
      if (_pageController.hasClients &&
          _pageController.position.isScrollingNotifier.value) {
        _schedulePrepaginationAroundCurrentPage();
        return;
      }
      _prepaginateAroundCurrentPage();
    });
  }

  void _invalidatePrepaginationQueue() {
    _prepaginationRevision += 1;
    _queuedPrepaginationKeys.clear();
  }

  void _ensurePaginationFromLastLayout() {
    _invalidatePrepaginationQueue();
    setState(() {
      _pages = const <_ReaderPageEntry>[];
      _setGlobalPageIndex(0);
    });
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
        body: Stack(
          children: <Widget>[
            Positioned.fill(child: _buildBody()),
            if (_detail != null && currentEntry != null) ...<Widget>[
              IgnorePointer(
                ignoring: !_chromeVisible,
                child: AnimatedOpacity(
                  opacity: _chromeVisible ? 1 : 0,
                  duration: const Duration(milliseconds: 180),
                  curve: Curves.easeOutCubic,
                  child: AnimatedSlide(
                    offset: _chromeVisible
                        ? Offset.zero
                        : const Offset(0, -0.08),
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeOutCubic,
                    child: _ReaderTopBar(
                      title: currentEntry.chapter.title,
                      textColor: textColor,
                      dividerColor: dividerColor,
                      onBack: () => Navigator.of(context).maybePop(),
                      onToc: _openToc,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: IgnorePointer(
                  ignoring: !_chromeVisible,
                  child: AnimatedOpacity(
                    opacity: _chromeVisible ? 1 : 0,
                    duration: const Duration(milliseconds: 180),
                    curve: Curves.easeOutCubic,
                    child: AnimatedSlide(
                      offset: _chromeVisible
                          ? Offset.zero
                          : const Offset(0, 0.08),
                      duration: const Duration(milliseconds: 240),
                      curve: Curves.easeOutCubic,
                      child: _buildBottomPanel(textColor),
                    ),
                  ),
                ),
              ),
            ],
            if (_detail != null && _pages.isNotEmpty && !_chromeVisible)
              ValueListenableBuilder<int>(
                valueListenable: _visiblePageIndexNotifier,
                builder: (BuildContext context, int pageIndex, Widget? child) {
                  final _ReaderPageEntry entry =
                      _pages[pageIndex.clamp(0, _pages.length - 1)];
                  return _ReaderPageProgress(
                    currentPage: entry.pageInChapter + 1,
                    totalPages: entry.pageCountInChapter,
                    color: mutedColor,
                  );
                },
              ),
            if (_detail != null && currentEntry != null)
              _ReaderTocOverlay(
                visible: _tocVisible,
                onDismiss: _closeToc,
                child: _ReaderTocDrawer(
                  chapters: _detail!.chapters,
                  currentChapterIndex: currentEntry.chapter.chapterIndex,
                  currentChapterTitle: currentEntry.chapter.title,
                  onClose: _closeToc,
                  onSelectChapter: (int chapterIndex) {
                    _goToChapter(chapterIndex);
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const _ReaderPreparingState();
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
          return const _ReaderPreparingState();
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
            key: ValueKey<String>(
              '${_paginationSignature ?? 'pending'}:$_pageControllerRevision',
            ),
            controller: _pageController,
            itemCount: _pages.length,
            allowImplicitScrolling: false,
            onPageChanged: _onPageChanged,
            itemBuilder: (BuildContext context, int index) {
              final _ReaderPageEntry entry = _pages[index];
              return RepaintBoundary(
                key: ValueKey<String>(entry.stableKey),
                child: _ReaderTextPage(
                  chapterTitle: entry.chapter.title,
                  text: entry.content,
                  showTitle: entry.showsTitle,
                  settings: _settings,
                  backgroundStyle: _resolvedBackgroundStyle(context),
                ),
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

  Widget _buildBottomPanel(Color textColor) {
    return switch (_bottomPanelTab) {
      _ReaderBottomPanelTab.menu => _ReaderBottomMenuPanel(
        textColor: textColor,
        panelColor: _overlaySurface,
        chipColor: _overlayChipSurface,
        onOpenToc: () {
          _openToc();
        },
        onOpenBackground: () {
          setState(() {
            _bottomPanelTab = _ReaderBottomPanelTab.background;
          });
        },
        onOpenSettings: () {
          setState(() {
            _bottomPanelTab = _ReaderBottomPanelTab.settings;
          });
        },
      ),
      _ReaderBottomPanelTab.background => _ReaderBackgroundPanel(
        settings: _settings,
        textColor: textColor,
        accentColor: _accent,
        panelColor: _overlaySurface,
        onBack: () {
          setState(() {
            _bottomPanelTab = _ReaderBottomPanelTab.menu;
          });
        },
        onBackgroundChanged: (_ReaderBackgroundStyle style) {
          _updateSettings(_settings.copyWith(backgroundId: style.id));
        },
      ),
      _ReaderBottomPanelTab.settings => _ReaderSettingsPanel(
        settings: _settings,
        textColor: textColor,
        accentColor: _accent,
        panelColor: _overlaySurface,
        chipColor: _overlayChipSurface,
        onRestoreDefaults: _restoreDefaultSettings,
        onBack: () {
          setState(() {
            _bottomPanelTab = _ReaderBottomPanelTab.menu;
          });
        },
        onFontSizeChanged: (double value) {
          _updateSettings(_settings.copyWith(fontSize: value));
        },
        onLineHeightChanged: (double value) {
          _updateSettings(_settings.copyWith(lineHeight: value));
        },
        onPageMarginChanged: (_ReaderPageMargin margin) {
          _updateSettings(_settings.copyWith(pageMarginId: margin.id));
        },
        onFontChanged: (_ReaderFontOption font) {
          _updateSettings(_settings.copyWith(fontId: font.id));
        },
        onLeftTapActionChanged: (_ReaderLeftTapAction action) {
          _updateSettings(_settings.copyWith(leftTapAction: action.id));
        },
      ),
    };
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
    return _ReaderPaginationEngine.displayText(value);
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

class _ReaderTocOverlay extends StatelessWidget {
  const _ReaderTocOverlay({
    required this.visible,
    required this.onDismiss,
    required this.child,
  });

  final bool visible;
  final VoidCallback onDismiss;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !visible,
      child: Stack(
        children: <Widget>[
          AnimatedOpacity(
            opacity: visible ? 1 : 0,
            duration: const Duration(milliseconds: 160),
            curve: Curves.easeOutCubic,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onDismiss,
              child: const ColoredBox(color: Color(0x33000000)),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: AnimatedSlide(
              offset: visible ? Offset.zero : const Offset(0, 1),
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOutCubic,
              child: AnimatedOpacity(
                opacity: visible ? 1 : 0,
                duration: const Duration(milliseconds: 160),
                curve: Curves.easeOutCubic,
                child: child,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReaderTocDrawer extends StatefulWidget {
  const _ReaderTocDrawer({
    required this.chapters,
    required this.currentChapterIndex,
    required String currentChapterTitle,
    required this.onClose,
    required this.onSelectChapter,
  }) : _currentChapterTitle = currentChapterTitle;

  final List<ReaderChapterModel> chapters;
  final int currentChapterIndex;
  final String? _currentChapterTitle;
  String get currentChapterTitle => _currentChapterTitle ?? '';
  final VoidCallback onClose;
  final ValueChanged<int> onSelectChapter;

  @override
  State<_ReaderTocDrawer> createState() => _ReaderTocDrawerState();
}

class _ReaderTocDrawerState extends State<_ReaderTocDrawer> {
  late final ScrollController _scrollController;
  double _handleDragOffset = 0;
  bool _isDraggingHandle = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController(
      initialScrollOffset: _estimatedInitialOffset(),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    final double delta = details.primaryDelta ?? 0;
    final double maxDragDistance = MediaQuery.of(context).size.height * 0.72;
    setState(() {
      _isDraggingHandle = true;
      _handleDragOffset = (_handleDragOffset + delta).clamp(0, maxDragDistance);
    });
  }

  void _handleDragEnd(DragEndDetails details) {
    final double velocity = details.primaryVelocity ?? 0;
    final double closeThreshold = MediaQuery.of(context).size.height * 0.18;
    if (_handleDragOffset > closeThreshold || velocity > 700) {
      widget.onClose();
    }
    setState(() {
      _isDraggingHandle = false;
      _handleDragOffset = 0;
    });
  }

  double _estimatedInitialOffset() {
    final int targetPosition = _targetChapterPosition();
    if (targetPosition <= 0) {
      return 0;
    }
    const double estimatedTileExtent = 72;
    const double preferredAlignmentOffset = 3;
    return ((targetPosition - preferredAlignmentOffset) * estimatedTileExtent)
        .clamp(0, double.infinity);
  }

  int _targetChapterPosition() {
    final String currentTitle = widget.currentChapterTitle.trim();
    if (currentTitle.isNotEmpty) {
      final int titleMatchIndex = widget.chapters.indexWhere(
        (ReaderChapterModel chapter) => chapter.title.trim() == currentTitle,
      );
      if (titleMatchIndex >= 0) {
        return titleMatchIndex;
      }
    }
    return widget.chapters.indexWhere(
      (ReaderChapterModel chapter) =>
          chapter.chapterIndex == widget.currentChapterIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final double bottomInset = MediaQuery.of(context).padding.bottom;
    final double dragProgress = MediaQuery.of(context).size.height <= 0
        ? 0
        : (_handleDragOffset / (MediaQuery.of(context).size.height * 0.72))
              .clamp(0, 1);
    return Material(
      color: Colors.transparent,
      child: AnimatedContainer(
        duration: _isDraggingHandle
            ? Duration.zero
            : const Duration(milliseconds: 140),
        curve: Curves.easeOutCubic,
        transform: Matrix4.translationValues(0, _handleDragOffset, 0),
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.72,
        ),
        decoration: BoxDecoration(
          color: _ReaderPageState._paper,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Color.lerp(
                const Color(0x1F000000),
                Colors.transparent,
                dragProgress,
              )!,
              blurRadius: 28,
              offset: const Offset(0, -10),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: EdgeInsets.only(bottom: bottomInset),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onVerticalDragUpdate: _handleDragUpdate,
                  onVerticalDragEnd: _handleDragEnd,
                  child: Center(
                    child: Container(
                      width: 54,
                      height: 6,
                      margin: const EdgeInsets.only(top: 10, bottom: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD9D9D9),
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
                  child: const Text(
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
                  child: Scrollbar(
                    controller: _scrollController,
                    thumbVisibility: true,
                    interactive: true,
                    thickness: 10,
                    radius: const Radius.circular(999),
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: widget.chapters.length,
                      itemBuilder: (BuildContext context, int index) {
                        final ReaderChapterModel chapter =
                            widget.chapters[index];
                        final bool selected =
                            chapter.title.trim() ==
                                widget.currentChapterTitle.trim() ||
                            chapter.chapterIndex == widget.currentChapterIndex;
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
                          onTap: () =>
                              widget.onSelectChapter(chapter.chapterIndex),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
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
    required this.onBack,
    required this.onFontSizeChanged,
    required this.onLineHeightChanged,
    required this.onPageMarginChanged,
    required this.onFontChanged,
    required this.onLeftTapActionChanged,
  });

  final _ReaderUiSettings settings;
  final Color textColor;
  final Color accentColor;
  final Color panelColor;
  final Color chipColor;
  final VoidCallback onRestoreDefaults;
  final VoidCallback onBack;
  final ValueChanged<double> onFontSizeChanged;
  final ValueChanged<double> onLineHeightChanged;
  final ValueChanged<_ReaderPageMargin> onPageMarginChanged;
  final ValueChanged<_ReaderFontOption> onFontChanged;
  final ValueChanged<_ReaderLeftTapAction> onLeftTapActionChanged;

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
              _ReaderPanelHeader(
                title: '阅读设置',
                textColor: textColor,
                leading: _ReaderPanelBackButton(
                  textColor: textColor,
                  onTap: onBack,
                ),
                trailing: InkWell(
                  onTap: onRestoreDefaults,
                  borderRadius: BorderRadius.circular(999),
                  child: Container(
                    height: 36,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: chipColor,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      '恢复默认',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: accentColor,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              const Divider(height: 1, color: Color(0xFFEDEAE4)),
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
                label: '左侧点击',
                textColor: textColor,
                child: Row(
                  children: _ReaderLeftTapAction.values
                      .map((_ReaderLeftTapAction action) {
                        final bool selected =
                            action.id == settings.leftTapAction;
                        return Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(
                              right: action == _ReaderLeftTapAction.values.last
                                  ? 0
                                  : 10,
                            ),
                            child: _ReaderChoiceChip(
                              label: action.label,
                              selected: selected,
                              accentColor: accentColor,
                              chipColor: chipColor,
                              width: double.infinity,
                              onTap: () => onLeftTapActionChanged(action),
                            ),
                          ),
                        );
                      })
                      .toList(growable: false),
                ),
              ),
              const SizedBox(height: 18),
              _ReaderSettingGroupRow(
                label: '字体',
                textColor: textColor,
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _ReaderFontOption.values.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1.75,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    final _ReaderFontOption font =
                        _ReaderFontOption.values[index];
                    final bool selected = font.id == settings.fontId;
                    return _ReaderChoiceChip(
                      label: font.label,
                      selected: selected,
                      accentColor: accentColor,
                      chipColor: chipColor,
                      width: double.infinity,
                      onTap: () => onFontChanged(font),
                    );
                  },
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

class _ReaderBottomMenuPanel extends StatelessWidget {
  const _ReaderBottomMenuPanel({
    required this.textColor,
    required this.panelColor,
    required this.chipColor,
    required this.onOpenToc,
    required this.onOpenBackground,
    required this.onOpenSettings,
  });

  final Color textColor;
  final Color panelColor;
  final Color chipColor;
  final VoidCallback onOpenToc;
  final VoidCallback onOpenBackground;
  final VoidCallback onOpenSettings;

  @override
  Widget build(BuildContext context) {
    final double bottomInset = MediaQuery.of(context).padding.bottom;
    return Container(
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
      child: Padding(
        padding: EdgeInsets.fromLTRB(18, 12, 18, 18 + bottomInset),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: 54,
              height: 6,
              decoration: BoxDecoration(
                color: const Color(0xFFD9D9D9),
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            const SizedBox(height: 18),
            Row(
              children: <Widget>[
                Expanded(
                  child: _ReaderMenuAction(
                    icon: Icons.list_alt_rounded,
                    label: '目录',
                    textColor: textColor,
                    chipColor: chipColor,
                    onTap: onOpenToc,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _ReaderMenuAction(
                    icon: Icons.palette_outlined,
                    label: '背景',
                    textColor: textColor,
                    chipColor: chipColor,
                    onTap: onOpenBackground,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _ReaderMenuAction(
                    icon: Icons.tune_rounded,
                    label: '阅读设置',
                    textColor: textColor,
                    chipColor: chipColor,
                    onTap: onOpenSettings,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ReaderBackgroundPanel extends StatelessWidget {
  const _ReaderBackgroundPanel({
    required this.settings,
    required this.textColor,
    required this.accentColor,
    required this.panelColor,
    required this.onBack,
    required this.onBackgroundChanged,
  });

  final _ReaderUiSettings settings;
  final Color textColor;
  final Color accentColor;
  final Color panelColor;
  final VoidCallback onBack;
  final ValueChanged<_ReaderBackgroundStyle> onBackgroundChanged;

  @override
  Widget build(BuildContext context) {
    final double bottomInset = MediaQuery.of(context).padding.bottom;
    return Container(
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
      child: Padding(
        padding: EdgeInsets.fromLTRB(18, 10, 18, 18 + bottomInset),
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
            _ReaderPanelHeader(
              title: '背景',
              textColor: textColor,
              leading: _ReaderPanelBackButton(
                textColor: textColor,
                onTap: onBack,
              ),
              trailing: const SizedBox(width: 40, height: 40),
            ),
            const SizedBox(height: 18),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _ReaderBackgroundStyle.values
                    .map((_ReaderBackgroundStyle style) {
                      final bool selected = style.id == settings.backgroundId;
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
          ],
        ),
      ),
    );
  }
}

class _ReaderPanelHeader extends StatelessWidget {
  const _ReaderPanelHeader({
    required this.title,
    required this.textColor,
    required this.leading,
    required this.trailing,
  });

  final String title;
  final Color textColor;
  final Widget leading;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Align(alignment: Alignment.centerLeft, child: leading),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w700,
              color: textColor,
              letterSpacing: 0.2,
            ),
          ),
          Align(alignment: Alignment.centerRight, child: trailing),
        ],
      ),
    );
  }
}

class _ReaderPanelBackButton extends StatelessWidget {
  const _ReaderPanelBackButton({required this.textColor, required this.onTap});

  final Color textColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: SizedBox(
        width: 40,
        height: 40,
        child: Icon(Icons.chevron_left_rounded, color: textColor, size: 28),
      ),
    );
  }
}

class _ReaderMenuAction extends StatelessWidget {
  const _ReaderMenuAction({
    required this.icon,
    required this.label,
    required this.textColor,
    required this.chipColor,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color textColor;
  final Color chipColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        height: 84,
        decoration: BoxDecoration(
          color: chipColor,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(icon, color: textColor, size: 24),
            const SizedBox(height: 10),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
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
    this.width = 104,
  });

  final String label;
  final bool selected;
  final Color accentColor;
  final Color chipColor;
  final VoidCallback onTap;
  final double width;

  @override
  Widget build(BuildContext context) {
    return _ReaderChoiceSurface(
      width: width,
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
    required String leftTapAction,
  }) : _leftTapAction = leftTapAction;

  factory _ReaderUiSettings.defaults() {
    return const _ReaderUiSettings(
      fontSize: 18,
      lineHeight: 1.78,
      pageMarginId: 'comfort',
      fontId: 'system',
      backgroundId: 'paper',
      themeMode: _ReaderThemeMode.day,
      leftTapAction: 'previous_page',
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
      leftTapAction:
          _ReaderLeftTapAction.values.any(
            (_ReaderLeftTapAction item) => item.id == model.leftTapAction,
          )
          ? model.leftTapAction
          : 'previous_page',
    );
  }

  final double fontSize;
  final double lineHeight;
  final String pageMarginId;
  final String fontId;
  final String backgroundId;
  final _ReaderThemeMode themeMode;
  final String? _leftTapAction;
  String get leftTapAction => _leftTapAction ?? 'previous_page';

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
      leftTapAction: leftTapAction,
    );
  }

  _ReaderUiSettings copyWith({
    double? fontSize,
    double? lineHeight,
    String? pageMarginId,
    String? fontId,
    String? backgroundId,
    _ReaderThemeMode? themeMode,
    String? leftTapAction,
  }) {
    return _ReaderUiSettings(
      fontSize: fontSize ?? this.fontSize,
      lineHeight: lineHeight ?? this.lineHeight,
      pageMarginId: pageMarginId ?? this.pageMarginId,
      fontId: fontId ?? this.fontId,
      backgroundId: backgroundId ?? this.backgroundId,
      themeMode: themeMode ?? this.themeMode,
      leftTapAction: leftTapAction ?? this.leftTapAction,
    );
  }
}

enum _ReaderLeftTapAction {
  previousPage('previous_page', '上一页'),
  nextPage('next_page', '下一页');

  const _ReaderLeftTapAction(this.id, this.label);

  final String id;
  final String label;
}

enum _ReaderThemeMode {
  day('日间', Icons.light_mode_outlined),
  night('夜间', Icons.dark_mode_outlined),
  system('跟随系统', Icons.desktop_windows_outlined);

  const _ReaderThemeMode(this.label, this.icon);

  final String label;
  final IconData icon;
}

enum _ReaderBottomPanelTab { menu, background, settings }

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
  const _ReaderPreparingState();

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(color: _ReaderPageState._paper);
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

  String get stableKey =>
      '${chapter.id}:$pageInChapter:$chapterTextStart:$chapterTextEnd';

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
