import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:pocketread/core/widgets/ux_state_view.dart';
import 'package:pocketread/features/reader/application/reader_providers.dart';
import 'package:pocketread/features/reader/domain/reader_models.dart';

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

  final PageController _pageController = PageController();

  ReaderBookDetail? _detail;
  List<_ReaderPageEntry> _pages = const <_ReaderPageEntry>[];
  _ReaderUiSettings _settings = _ReaderUiSettings.defaults();
  int _globalPageIndex = 0;
  bool _chromeVisible = false;
  bool _loading = true;
  String? _errorMessage;
  Timer? _saveDebounce;
  Timer? _settingsSaveDebounce;
  DateTime _openedAt = DateTime.now();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadReader();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _saveDebounce?.cancel();
    _settingsSaveDebounce?.cancel();
    unawaited(
      ref.read(readerRepositoryProvider).saveReaderSettings(_settings.toModel()),
    );
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
      final ReaderSettingsModel savedSettings = await ref
          .read(readerRepositoryProvider)
          .getReaderSettings();
      final ReaderBookDetail? detail = await ref
          .read(readerRepositoryProvider)
          .getBookDetail(widget.bookId);
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
      final List<_ReaderPageEntry> pages = _buildBookPages(
        detail,
        loadedSettings,
      );
      final int initialPageIndex = _restorePageIndex(detail.progress, pages);

      setState(() {
        _settings = loadedSettings;
        _detail = detail;
        _pages = pages;
        _globalPageIndex = initialPageIndex;
        _loading = false;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_pageController.hasClients && pages.isNotEmpty) {
          _pageController.jumpToPage(initialPageIndex);
        }
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

  List<_ReaderPageEntry> _buildBookPages(
    ReaderBookDetail detail,
    _ReaderUiSettings settings,
  ) {
    final List<_ReaderPageEntry> pages = <_ReaderPageEntry>[];
    for (final ReaderChapterModel chapter in detail.chapters) {
      final List<String> chapterPages = _buildChapterPages(chapter, settings);
      for (int i = 0; i < chapterPages.length; i += 1) {
        pages.add(
          _ReaderPageEntry(
            chapter: chapter,
            pageInChapter: i,
            pageCountInChapter: chapterPages.length,
            content: chapterPages[i],
            showsTitle: i == 0,
            showHtml:
                detail.book.format == 'epub' &&
                chapter.htmlContent != null &&
                chapterPages.length == 1,
          ),
        );
      }
    }
    return pages;
  }

  List<String> _buildChapterPages(
    ReaderChapterModel chapter,
    _ReaderUiSettings settings,
  ) {
    final String text = _readableText(chapter).trim();
    if (text.isEmpty) {
      return const <String>['本章暂无正文内容'];
    }

    final List<String> paragraphs = text
        .split(RegExp(r'\n{2,}'))
        .map((String value) => value.trim())
        .where((String value) => value.isNotEmpty)
        .toList(growable: false);
    if (paragraphs.isEmpty) {
      return <String>[text];
    }

    final int firstPageLimit = settings.firstPageCharLimit;
    final int followingPageLimit = settings.followingPageCharLimit;
    final List<String> pages = <String>[];
    final StringBuffer buffer = StringBuffer();

    for (final String paragraph in paragraphs) {
      final int limit = pages.isEmpty ? firstPageLimit : followingPageLimit;
      final String candidate = buffer.isEmpty
          ? paragraph
          : '${buffer.toString()}\n\n$paragraph';
      if (candidate.length <= limit) {
        buffer
          ..clear()
          ..write(candidate);
        continue;
      }

      if (buffer.isNotEmpty) {
        pages.add(buffer.toString());
        buffer.clear();
      }

      int start = 0;
      while (start < paragraph.length) {
        final int pageLimit = pages.isEmpty
            ? firstPageLimit
            : followingPageLimit;
        final int end = math.min(start + pageLimit, paragraph.length);
        pages.add(paragraph.substring(start, end));
        start = end;
      }
    }

    if (buffer.isNotEmpty) {
      pages.add(buffer.toString());
    }

    return pages.isEmpty ? <String>[text] : pages;
  }

  int _restorePageIndex(
    ReaderProgressModel? progress,
    List<_ReaderPageEntry> pages,
  ) {
    if (pages.isEmpty) {
      return 0;
    }
    final String? locatorValue = progress?.locatorValue;
    if (locatorValue != null) {
      final RegExpMatch? match = RegExp(
        r'^page:(\d+):(\d+)$',
      ).firstMatch(locatorValue);
      if (match != null) {
        final int chapterIndex = int.tryParse(match.group(1) ?? '') ?? 0;
        final int pageInChapter = int.tryParse(match.group(2) ?? '') ?? 0;
        final int index = pages.indexWhere((_ReaderPageEntry entry) {
          return entry.chapter.chapterIndex == chapterIndex &&
              entry.pageInChapter == pageInChapter;
        });
        if (index >= 0) {
          return index;
        }
      }
    }

    final int chapterIndex = progress?.currentChapterIndex ?? 0;
    final int fallback = pages.indexWhere(
      (_ReaderPageEntry entry) => entry.chapter.chapterIndex == chapterIndex,
    );
    return fallback >= 0 ? fallback : 0;
  }

  void _onPageChanged(int index) {
    _globalPageIndex = index;
    _saveDebounce?.cancel();
    _saveDebounce = Timer(const Duration(milliseconds: 700), _saveProgress);
    if (mounted) {
      setState(() {});
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
    final double chapterProgress = entry.pageCountInChapter <= 1
        ? 0
        : entry.pageInChapter / math.max(1, entry.pageCountInChapter - 1);
    final double progressPercent =
        ((chapter.chapterIndex + chapterProgress) /
                math.max(1, detail.chapters.length))
            .clamp(0, 1);
    final int now = DateTime.now().millisecondsSinceEpoch;
    final int totalMinutes =
        (detail.progress?.totalReadingMinutes ?? 0) +
        DateTime.now().difference(_openedAt).inMinutes;

    await ref
        .read(readerRepositoryProvider)
        .saveProgress(
          bookId: widget.bookId,
          currentChapterIndex: chapter.chapterIndex,
          chapterOffset: _chapterOffsetForPage(chapter, entry),
          scrollOffset: _globalPageIndex.toDouble(),
          progressPercent: progressPercent,
          locatorType: 'chapter_page',
          locatorValue: 'page:${chapter.chapterIndex}:${entry.pageInChapter}',
          lastReadAtMillis: now,
          updatedAtMillis: now,
          totalReadingMinutes: totalMinutes,
        );
    _openedAt = DateTime.now();
  }

  int? _chapterOffsetForPage(
    ReaderChapterModel chapter,
    _ReaderPageEntry entry,
  ) {
    final int? startOffset = chapter.startOffset;
    final int? endOffset = chapter.endOffset;
    if (startOffset == null || endOffset == null || endOffset <= startOffset) {
      return null;
    }
    final double ratio = entry.pageCountInChapter <= 1
        ? 0
        : entry.pageInChapter / math.max(1, entry.pageCountInChapter - 1);
    return startOffset + ((endOffset - startOffset) * ratio).round();
  }

  Future<void> _goToChapter(int chapterIndex) async {
    await _saveProgress();
    final int targetIndex = _pages.indexWhere(
      (_ReaderPageEntry entry) => entry.chapter.chapterIndex == chapterIndex,
    );
    if (targetIndex < 0) {
      return;
    }
    setState(() {
      _globalPageIndex = targetIndex;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_pageController.hasClients) {
        _pageController.jumpToPage(targetIndex);
      }
      _saveProgress();
    });
  }

  void _handleTapUp(TapUpDetails details, BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double dx = details.localPosition.dx;
    final double leftBound = width * 0.33;
    final double rightBound = width * 0.67;
    if (dx >= leftBound && dx <= rightBound) {
      setState(() {
        _chromeVisible = !_chromeVisible;
      });
    }
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
    final ReaderBookDetail? detail = _detail;
    final _ReaderPageEntry? currentEntry = _pages.isEmpty
        ? null
        : _pages[_globalPageIndex.clamp(0, _pages.length - 1)];
    if (detail == null || currentEntry == null) {
      setState(() {
        _settings = nextSettings;
      });
      return;
    }

    final List<_ReaderPageEntry> nextPages = _buildBookPages(
      detail,
      nextSettings,
    );
    final List<_ReaderPageEntry> sameChapterPages = nextPages
        .where(
          (_ReaderPageEntry entry) =>
              entry.chapter.chapterIndex == currentEntry.chapter.chapterIndex,
        )
        .toList(growable: false);
    final double ratio = currentEntry.pageCountInChapter <= 1
        ? 0
        : currentEntry.pageInChapter /
              math.max(1, currentEntry.pageCountInChapter - 1);
    final int nextPageInChapter = sameChapterPages.isEmpty
        ? 0
        : (ratio * math.max(0, sameChapterPages.length - 1)).round();
    final int targetIndex = nextPages.indexWhere(
      (_ReaderPageEntry entry) =>
          entry.chapter.chapterIndex == currentEntry.chapter.chapterIndex &&
          entry.pageInChapter == nextPageInChapter,
    );

    setState(() {
      _settings = nextSettings;
      _pages = nextPages;
      _globalPageIndex = targetIndex >= 0 ? targetIndex : 0;
    });
    _scheduleSettingsSave(nextSettings);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_pageController.hasClients) {
        _pageController.jumpToPage(_globalPageIndex);
      }
    });
  }

  void _scheduleSettingsSave(_ReaderUiSettings settings) {
    _settingsSaveDebounce?.cancel();
    _settingsSaveDebounce = Timer(const Duration(milliseconds: 250), () async {
      await ref
          .read(readerRepositoryProvider)
          .saveReaderSettings(settings.toModel());
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
            if (_chromeVisible && _detail != null && currentEntry != null) ...<Widget>[
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
                currentPage: _globalPageIndex + 1,
                totalPages: _pages.length,
                color: mutedColor,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const UxStateView(
        icon: Icons.menu_book_rounded,
        title: '正在打开书籍',
        message: '正文和目录正在准备，请稍候。',
        iconBackgroundColor: Color(0xFFF1EBDD),
        iconColor: Color(0xFF8C7A62),
        titleColor: _ink,
        messageColor: _muted,
        primaryColor: Color(0xFF6B573F),
        scrollable: true,
      );
    }
    if (_errorMessage != null) {
      final bool missingBook = _errorMessage == '书籍不存在或已被删除';
      final bool emptyContent = _errorMessage == '这本书还没有可阅读章节';
      return _ReaderMessageState(
        title: missingBook ? '书籍已不可用' : '加载失败',
        message: emptyContent
            ? '当前文件没有解析出可阅读正文，请重新导入后再试。'
            : _errorMessage!,
        primaryLabel: missingBook ? '返回书架' : '重新加载',
        onPrimaryAction: missingBook
            ? () {
                Navigator.of(context).maybePop();
              }
            : _loadReader,
      );
    }
    if (_detail == null || _pages.isEmpty) {
      return const _ReaderMessageState(
        title: '没有可阅读内容',
        message: '当前章节内容为空，暂时无法继续阅读。',
      );
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapUp: (TapUpDetails details) => _handleTapUp(details, context),
      child: PageView.builder(
        key: ValueKey<int>(_pages.length),
        controller: _pageController,
        itemCount: _pages.length,
        onPageChanged: _onPageChanged,
        itemBuilder: (BuildContext context, int index) {
          final _ReaderPageEntry entry = _pages[index];
          return _ReaderTextPage(
            chapterTitle: entry.chapter.title,
            text: entry.content,
            showTitle: entry.showsTitle,
            showHtml: entry.showHtml,
            htmlContent: entry.chapter.htmlContent,
            settings: _settings,
            backgroundStyle: _resolvedBackgroundStyle(context),
          );
        },
      ),
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
    required this.showHtml,
    required this.htmlContent,
    required this.settings,
    required this.backgroundStyle,
  });

  final String chapterTitle;
  final String text;
  final bool showTitle;
  final bool showHtml;
  final String? htmlContent;
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
    return Padding(
      padding: EdgeInsets.fromLTRB(
        margin.horizontalPadding,
        44,
        margin.horizontalPadding,
        48,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (showTitle) ...<Widget>[
            Text(
              chapterTitle,
              maxLines: 1,
              overflow: TextOverflow.fade,
              softWrap: false,
              style: TextStyle(
                fontSize: 15,
                height: 1.2,
                fontWeight: FontWeight.w500,
                color: backgroundStyle.mutedColor,
                letterSpacing: 0.3,
              ),
            ),
            const SizedBox(height: 20),
          ],
          Expanded(
            child: ClipRect(
              child: showHtml
                  ? HtmlWidget(
                      htmlContent!,
                      textStyle: bodyStyle,
                    )
                  : Text(
                      _displayText(text),
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
              _ReaderSettingSliderRow(
                label: '字号',
                textColor: textColor,
                leading: _ReaderStepButton(
                  label: 'A-',
                  chipColor: chipColor,
                  onTap: () => onFontSizeChanged(
                    (settings.fontSize - 1).clamp(14, 26),
                  ),
                ),
                valueBadge: '${settings.fontSize.round()}',
                chipColor: chipColor,
                trailing: _ReaderStepButton(
                  label: 'A+',
                  chipColor: chipColor,
                  onTap: () => onFontSizeChanged(
                    (settings.fontSize + 1).clamp(14, 26),
                  ),
                ),
                sliderValue: settings.fontSize,
                min: 14,
                max: 26,
                onChanged: onFontSizeChanged,
                endLabel: 'A',
                accentColor: accentColor,
              ),
              const SizedBox(height: 16),
              _ReaderSettingSliderRow(
                label: '行高',
                textColor: textColor,
                leading: _ReaderIconChip(
                  icon: Icons.short_text_rounded,
                  chipColor: chipColor,
                ),
                trailing: _ReaderIconChip(
                  icon: Icons.reorder_rounded,
                  chipColor: chipColor,
                ),
                sliderValue: settings.lineHeight,
                min: 1.4,
                max: 2.2,
                onChanged: onLineHeightChanged,
                accentColor: accentColor,
                chipColor: chipColor,
              ),
              const SizedBox(height: 18),
              _ReaderSettingGroupRow(
                label: '页边距',
                textColor: textColor,
                child: Row(
                  children: _ReaderPageMargin.values.map((_ReaderPageMargin item) {
                    final bool selected = item.id == settings.pageMarginId;
                    return Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                          right: item == _ReaderPageMargin.values.last ? 0 : 10,
                        ),
                      child: _ReaderMarginChip(
                          margin: item,
                          selected: selected,
                          accentColor: accentColor,
                          chipColor: chipColor,
                          onTap: () => onPageMarginChanged(item),
                        ),
                      ),
                    );
                  }).toList(growable: false),
                ),
              ),
              const SizedBox(height: 18),
              _ReaderSettingGroupRow(
                label: '字体',
                textColor: textColor,
                child: Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: _ReaderFontOption.values.map((_ReaderFontOption font) {
                    final bool selected = font.id == settings.fontId;
                    return _ReaderChoiceChip(
                      label: font.label,
                      selected: selected,
                      accentColor: accentColor,
                      chipColor: chipColor,
                      onTap: () => onFontChanged(font),
                    );
                  }).toList(growable: false),
                ),
              ),
              const SizedBox(height: 18),
              _ReaderSettingGroupRow(
                label: '背景',
                textColor: textColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: _ReaderBackgroundStyle.values.map((
                    _ReaderBackgroundStyle style,
                  ) {
                    final bool selected = style.id == settings.backgroundId;
                    return _ReaderBackgroundChip(
                      style: style,
                      selected: selected,
                      accentColor: accentColor,
                      onTap: () => onBackgroundChanged(style),
                    );
                  }).toList(growable: false),
                ),
              ),
              const SizedBox(height: 18),
              _ReaderSettingGroupRow(
                label: '主题模式',
                textColor: textColor,
                child: Row(
                  children: _ReaderThemeMode.values.map((_ReaderThemeMode mode) {
                    final bool selected = mode == settings.themeMode;
                    return Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                          right: mode == _ReaderThemeMode.values.last ? 0 : 10,
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
                  }).toList(growable: false),
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
}

class _ReaderSettingSliderRow extends StatelessWidget {
  const _ReaderSettingSliderRow({
    required this.label,
    required this.textColor,
    required this.sliderValue,
    required this.min,
    required this.max,
    required this.onChanged,
    required this.accentColor,
    required this.chipColor,
    this.leading,
    this.valueBadge,
    this.trailing,
    this.endLabel,
  });

  final String label;
  final Color textColor;
  final Widget? leading;
  final String? valueBadge;
  final Widget? trailing;
  final double sliderValue;
  final double min;
  final double max;
  final ValueChanged<double> onChanged;
  final String? endLabel;
  final Color accentColor;
  final Color chipColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
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
        ...?leading == null ? null : <Widget>[leading!],
        if (valueBadge != null) ...<Widget>[
          const SizedBox(width: 10),
          _ReaderValueBadge(label: valueBadge!, chipColor: chipColor),
        ],
        if (trailing != null) ...<Widget>[
          const SizedBox(width: 10),
          trailing!,
        ],
        const SizedBox(width: 12),
        Expanded(
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 3,
              inactiveTrackColor: const Color(0xFFE3E3E3),
              activeTrackColor: accentColor,
              thumbColor: accentColor,
              overlayShape: SliderComponentShape.noOverlay,
            ),
            child: Slider(
              value: sliderValue.clamp(min, max),
              min: min,
              max: max,
              onChanged: onChanged,
            ),
          ),
        ),
        if (endLabel != null) ...<Widget>[
          const SizedBox(width: 8),
          SizedBox(
            width: 24,
            child: Text(
              endLabel!,
              style: TextStyle(
                fontSize: 18,
                color: textColor,
              ),
            ),
          ),
        ],
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
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
      ),
    );
  }
}

class _ReaderValueBadge extends StatelessWidget {
  const _ReaderValueBadge({required this.label, required this.chipColor});

  final String label;
  final Color chipColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: chipColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
      ),
    );
  }
}

class _ReaderIconChip extends StatelessWidget {
  const _ReaderIconChip({required this.icon, required this.chipColor});

  final IconData icon;
  final Color chipColor;

  @override
  Widget build(BuildContext context) {
    return _ReaderChoiceSurface(
      width: 52,
      height: 48,
      onTap: () {},
      chipColor: chipColor,
      child: Icon(icon, size: 24),
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

class _ReaderMarginChip extends StatelessWidget {
  const _ReaderMarginChip({
    required this.margin,
    required this.selected,
    required this.accentColor,
    required this.chipColor,
    required this.onTap,
  });

  final _ReaderPageMargin margin;
  final bool selected;
  final Color accentColor;
  final Color chipColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return _ReaderChoiceSurface(
      width: double.infinity,
      height: 56,
      onTap: onTap,
      selected: selected,
      accentColor: accentColor,
      chipColor: chipColor,
      child: CustomPaint(
        painter: _ReaderMarginPainter(
          lineColor: selected ? accentColor : const Color(0xFF4B4B4B),
          inset: margin.previewInset,
        ),
        child: const SizedBox.expand(),
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

class _ReaderMarginPainter extends CustomPainter {
  const _ReaderMarginPainter({required this.lineColor, required this.inset});

  final Color lineColor;
  final double inset;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint stroke = Paint()
      ..color = lineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6;
    final Paint fill = Paint()
      ..color = lineColor
      ..strokeWidth = 1.4;
    final Rect rect = Rect.fromLTWH(
      inset,
      10,
      size.width - inset * 2,
      size.height - 20,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(6)),
      stroke,
    );
    final double lineStart = rect.left + 8;
    final double lineEnd = rect.right - 8;
    for (int i = 0; i < 3; i += 1) {
      final double y = rect.top + 8 + i * 8;
      canvas.drawLine(Offset(lineStart, y), Offset(lineEnd, y), fill);
    }
  }

  @override
  bool shouldRepaint(covariant _ReaderMarginPainter oldDelegate) {
    return oldDelegate.lineColor != lineColor || oldDelegate.inset != inset;
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
      pageMarginId: _ReaderPageMargin.values
              .any(
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
      fontId: _ReaderFontOption.values.any(
        (_ReaderFontOption font) => font.id == model.fontFamilyId,
      )
          ? model.fontFamilyId
          : 'system',
      backgroundId: _ReaderBackgroundStyle.values.any(
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
  system(
    'system',
    '系统默认',
    null,
    <String>['PingFang SC', 'Noto Sans CJK SC', 'Microsoft YaHei'],
  ),
  sans(
    'sans',
    '思源黑体',
    'ReaderNotoSansSC',
    <String>['PingFang SC', 'Noto Sans CJK SC', 'Microsoft YaHei', 'sans-serif'],
  ),
  song(
    'song',
    '思源宋体',
    'ReaderNotoSerifSC',
    <String>['Songti SC', 'STSong', 'Noto Serif CJK SC', 'serif'],
  ),
  wenkai(
    'wenkai',
    '霞鹜文楷',
    'ReaderLXGWWenKai',
    <String>['Kaiti SC', 'STKaiti', 'KaiTi', 'serif'],
  ),
  mono(
    'mono',
    '等宽',
    'Menlo',
    <String>['SF Mono', 'Roboto Mono', 'monospace'],
  );

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
  compact('compact', 20, 16),
  comfort('comfort', 26, 12),
  relaxed('relaxed', 32, 22),
  wide('wide', 38, 18),
  extra('extra', 44, 14);

  const _ReaderPageMargin(this.id, this.horizontalPadding, this.previewInset);

  final String id;
  final double horizontalPadding;
  final double previewInset;
}

enum _ReaderBackgroundStyle {
  paper(
    'paper',
    Color(0xFFF6F1E9),
    Color(0xFF111111),
    Color(0xFF8C918B),
  ),
  mist(
    'mist',
    Color(0xFFF5F5F3),
    Color(0xFF1D1D1D),
    Color(0xFF898989),
  ),
  wheat(
    'wheat',
    Color(0xFFF3E2C5),
    Color(0xFF251E14),
    Color(0xFF85705A),
  ),
  sage(
    'sage',
    Color(0xFFDCE6D5),
    Color(0xFF1D281F),
    Color(0xFF647065),
  ),
  fog(
    'fog',
    Color(0xFFD9D9DD),
    Color(0xFF212121),
    Color(0xFF666872),
  ),
  charcoal(
    'charcoal',
    Color(0xFF6B6B6D),
    Color(0xFFF7F7F7),
    Color(0xFFD4D4D4),
  ),
  midnight(
    'midnight',
    Color(0xFF111111),
    Color(0xFFF5F5F5),
    Color(0xFFBBBBBB),
  );

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

class _ReaderPageEntry {
  const _ReaderPageEntry({
    required this.chapter,
    required this.pageInChapter,
    required this.pageCountInChapter,
    required this.content,
    required this.showsTitle,
    required this.showHtml,
  });

  final ReaderChapterModel chapter;
  final int pageInChapter;
  final int pageCountInChapter;
  final String content;
  final bool showsTitle;
  final bool showHtml;
}
