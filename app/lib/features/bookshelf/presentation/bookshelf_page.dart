import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pocketread/core/router/app_router.dart';
import 'package:pocketread/core/widgets/app_bottom_nav.dart';
import 'package:pocketread/core/widgets/ux_state_view.dart';
import 'package:pocketread/features/bookshelf/application/bookshelf_providers.dart';
import 'package:pocketread/features/bookshelf/domain/bookshelf_book.dart';
import 'package:pocketread/features/importer/application/importer_providers.dart';
import 'package:pocketread/features/importer/domain/import_job.dart';
import 'package:pocketread/features/importer/domain/import_selection.dart';
import 'package:pocketread/features/reader/application/reader_providers.dart';

class BookshelfPage extends ConsumerStatefulWidget {
  const BookshelfPage({super.key});

  @override
  ConsumerState<BookshelfPage> createState() => _BookshelfPageState();
}

class _BookshelfPageState extends ConsumerState<BookshelfPage> {
  static const Color _green = Color(0xFF1DB954);
  static const Color _black = Color(0xFF2B2D38);
  static const Color _muted = Color(0xFF8F939C);
  static const Color _bg = Color(0xFFFFFFFF);
  static const Color _line = Color(0xFFE5E6EB);

  _ShelfFilter _currentFilter = _ShelfFilter.all;
  _ShelfView _currentView = _ShelfView.grid;
  _SortType _sortType = _SortType.recentRead;
  String _searchQuery = '';
  _ShelfNotice? _notice;
  String? _preheatedRecentBookId;

  List<BookshelfBook> _filteredBooks(List<BookshelfBook> books) {
    final String keyword = _searchQuery.trim().toLowerCase();
    final List<BookshelfBook> filtered = books.where((BookshelfBook book) {
      final bool matchesFilter = switch (_currentFilter) {
        _ShelfFilter.all => true,
        _ShelfFilter.reading => book.isReading,
        _ShelfFilter.favorite => book.isFavorite,
        _ShelfFilter.pinned => book.isPinned,
      };
      final bool matchesKeyword =
          keyword.isEmpty ||
          book.title.toLowerCase().contains(keyword) ||
          book.author.toLowerCase().contains(keyword);
      return matchesFilter && matchesKeyword;
    }).toList();

    filtered.sort((BookshelfBook a, BookshelfBook b) {
      final int pinnedCompare = b.isPinned ? (a.isPinned ? 0 : 1) : -1;
      if (a.isPinned != b.isPinned) {
        return pinnedCompare;
      }
      return switch (_sortType) {
        _SortType.recentRead => (b.lastReadAt ?? DateTime(1970)).compareTo(
          a.lastReadAt ?? DateTime(1970),
        ),
        _SortType.imported => b.createdAt.compareTo(a.createdAt),
        _SortType.title => a.title.compareTo(b.title),
        _SortType.progress => b.progressPercent.compareTo(a.progressPercent),
      };
    });
    return filtered;
  }

  List<_ShelfTabData> _tabs(List<BookshelfBook> books) => <_ShelfTabData>[
    _buildTab(_ShelfFilter.all, '全部', books.length),
    _buildTab(
      _ShelfFilter.reading,
      '在读',
      books.where((BookshelfBook book) => book.isReading).length,
    ),
    _buildTab(
      _ShelfFilter.favorite,
      '收藏',
      books.where((BookshelfBook book) => book.isFavorite).length,
    ),
    _buildTab(
      _ShelfFilter.pinned,
      '置顶',
      books.where((BookshelfBook book) => book.isPinned).length,
    ),
  ];

  _ShelfTabData _buildTab(_ShelfFilter filter, String label, int count) {
    return _ShelfTabData(
      filter: filter,
      label: label,
      count: count,
      selected: filter == _currentFilter,
    );
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<List<BookshelfBook>> shelfBooks = ref.watch(
      bookshelfBooksProvider,
    );
    final List<BookshelfBook> allBooks = shelfBooks.maybeWhen(
      data: (List<BookshelfBook> books) => books,
      orElse: () => const <BookshelfBook>[],
    );
    final List<BookshelfBook> books = _filteredBooks(allBooks);
    _scheduleRecentReadWarmup(context, allBooks);

    return Scaffold(
      backgroundColor: _bg,
      floatingActionButton: SizedBox(
        width: 54,
        height: 54,
        child: FloatingActionButton(
          onPressed: _showImportOptions,
          elevation: 0,
          backgroundColor: _green,
          shape: const CircleBorder(),
          child: const Icon(Icons.add_rounded, size: 30, color: Colors.white),
        ),
      ),
      bottomNavigationBar: const AppBottomNav(
        currentTab: AppBottomNavTab.bookshelf,
      ),
      body: SafeArea(
        child: RefreshIndicator(
          color: _green,
          onRefresh: _refreshBookshelf,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 18, 24, 0),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        const Text(
                          '书架',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: _black,
                          ),
                        ),
                        const Spacer(),
                        _ActionButton(
                          icon: Icons.search_rounded,
                          onTap: _openSearch,
                        ),
                        const SizedBox(width: 14),
                        _ActionButton(
                          icon: Icons.filter_alt_outlined,
                          onTap: _showSortOptions,
                        ),
                        const SizedBox(width: 14),
                        _ActionButton(
                          icon: Icons.more_horiz_rounded,
                          onTap: _showMoreOptions,
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: <Widget>[
                        ..._tabs(allBooks).map(
                          (_ShelfTabData tab) => _ShelfTab(
                            data: tab,
                            onTap: () {
                              setState(() {
                                _currentFilter = tab.filter;
                              });
                            },
                          ),
                        ),
                        const Spacer(),
                        InkResponse(
                          onTap: _toggleView,
                          radius: 16,
                          child: Icon(
                            _currentView == _ShelfView.grid
                                ? Icons.view_list_rounded
                                : Icons.grid_view_rounded,
                            size: 18,
                            color: const Color(0xFFC9CDD3),
                          ),
                        ),
                      ],
                    ),
                    if (_notice != null) ...<Widget>[
                      const SizedBox(height: 16),
                      UxInlineNotice(
                        title: _notice!.title,
                        message: _notice!.message,
                        tone: _notice!.tone,
                        onClose: () {
                          setState(() {
                            _notice = null;
                          });
                        },
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: shelfBooks.when(
                  data: (_) {
                    return books.isEmpty
                        ? _BookshelfEmptyState(
                            hasSearch:
                                _searchQuery.isNotEmpty ||
                                _currentFilter != _ShelfFilter.all,
                            onResetSearch: () {
                              setState(() {
                                _searchQuery = '';
                                _currentFilter = _ShelfFilter.all;
                              });
                            },
                            onImport: _showImportOptions,
                          )
                        : _BookshelfContent(
                            view: _currentView,
                            books: books,
                            onOpenDetail: _openBookDetail,
                            onContinueRead: _continueReading,
                            onOpenBookMenu: _showBookActions,
                          );
                  },
                  loading: () => const Center(
                    child: CircularProgressIndicator(color: _green),
                  ),
                  error: (Object error, StackTrace stackTrace) =>
                      _BookshelfErrorState(
                        message: '书架加载失败',
                        onRetry: () => ref.invalidate(bookshelfBooksProvider),
                        onImport: _showImportOptions,
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _refreshBookshelf() async {
    ref.invalidate(bookshelfBooksProvider);
    await Future<void>.delayed(const Duration(milliseconds: 300));
    if (mounted) {
      _showNotice(
        const _ShelfNotice(
          title: '书架已更新',
          message: '最新书籍和阅读进度已经重新加载。',
          tone: UxNoticeTone.success,
        ),
      );
    }
  }

  Future<void> _openSearch() async {
    final AsyncValue<List<BookshelfBook>> shelfBooks = ref.read(
      bookshelfBooksProvider,
    );
    final List<BookshelfBook> books = shelfBooks.maybeWhen(
      data: (List<BookshelfBook> value) => value,
      orElse: () => const <BookshelfBook>[],
    );
    final String? result = await showSearch<String?>(
      context: context,
      delegate: _BookshelfSearchDelegate(
        books: books,
        initialQuery: _searchQuery,
      ),
    );
    if (result == null || !mounted) {
      return;
    }
    setState(() {
      _searchQuery = result;
    });
  }

  Future<void> _showSortOptions() async {
    final _SortType? result = await showModalBottomSheet<_SortType>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return _OptionSheet(
          title: '排序方式',
          options: _SortType.values
              .map(
                (_SortType type) => _OptionItem<_SortType>(
                  value: type,
                  title: type.label,
                  selected: type == _sortType,
                ),
              )
              .toList(),
        );
      },
    );
    if (result == null) {
      return;
    }
    setState(() {
      _sortType = result;
    });
  }

  Future<void> _showMoreOptions() async {
    final _TopMenuAction? result = await showModalBottomSheet<_TopMenuAction>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return _OptionSheet(
          title: '更多操作',
          options: <_OptionItem<_TopMenuAction>>[
            _OptionItem<_TopMenuAction>(
              value: _TopMenuAction.toggleView,
              title: _currentView == _ShelfView.grid ? '切换为列表视图' : '切换为网格视图',
            ),
            const _OptionItem<_TopMenuAction>(
              value: _TopMenuAction.batchManage,
              title: '批量管理',
            ),
            const _OptionItem<_TopMenuAction>(
              value: _TopMenuAction.clearSearch,
              title: '清空搜索',
            ),
          ],
        );
      },
    );
    if (result == null || !mounted) {
      return;
    }
    switch (result) {
      case _TopMenuAction.toggleView:
        _toggleView();
      case _TopMenuAction.batchManage:
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('批量管理功能待接入数据层')));
      case _TopMenuAction.clearSearch:
        setState(() {
          _searchQuery = '';
        });
    }
  }

  Future<void> _showImportOptions() async {
    final _ImportAction? result = await showModalBottomSheet<_ImportAction>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return const _OptionSheet(
          title: '导入书籍',
          options: <_OptionItem<_ImportAction>>[
            _OptionItem<_ImportAction>(
              value: _ImportAction.localFile,
              title: '导入本地文件',
            ),
            _OptionItem<_ImportAction>(
              value: _ImportAction.scanFolder,
              title: '扫描文件夹',
            ),
          ],
        );
      },
    );
    if (result == null || !mounted) {
      return;
    }
    final ImportLaunchResult launchResult = switch (result) {
      _ImportAction.localFile =>
        await ref.read(bookImportLauncherProvider).pickFiles(),
      _ImportAction.scanFolder =>
        await ref.read(bookImportLauncherProvider).pickDirectory(),
    };
    if (!mounted) {
      return;
    }

    final ImportSelection? selection = launchResult.selection;
    if (selection == null) {
      _showNotice(
        _ShelfNotice(
          title: '未开始导入',
          message: launchResult.message,
          tone: _noticeToneForLaunchStatus(launchResult.status),
        ),
      );
      return;
    }

    _showNotice(
      _ShelfNotice(
        title: '正在导入',
        message: '${launchResult.message}，请稍候。',
        tone: UxNoticeTone.info,
      ),
    );

    final BookImportReport report = await ref
        .read(importBooksUseCaseProvider)
        .execute(selection);
    if (!mounted) {
      return;
    }
    _showNotice(_noticeForReport(report));
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return _ImportResultSheet(
          report: report,
          onClose: () => Navigator.of(context).pop(),
          onViewBookshelf: () => Navigator.of(context).pop(),
          onRetryFailed: report.failedCount == 0
              ? null
              : () {
                  Navigator.of(context).pop();
                  _showNotice(
                    const _ShelfNotice(
                      title: '失败项保留',
                      message: '请重新选择失败文件后再次导入。',
                      tone: UxNoticeTone.warning,
                    ),
                  );
                },
        );
      },
    );
  }

  void _showNotice(_ShelfNotice notice) {
    if (!mounted) {
      return;
    }
    setState(() {
      _notice = notice;
    });
  }

  UxNoticeTone _noticeToneForLaunchStatus(ImportLaunchStatus status) {
    return switch (status) {
      ImportLaunchStatus.success => UxNoticeTone.success,
      ImportLaunchStatus.cancelled => UxNoticeTone.warning,
      ImportLaunchStatus.blocked => UxNoticeTone.danger,
      ImportLaunchStatus.failure => UxNoticeTone.danger,
    };
  }

  _ShelfNotice _noticeForReport(BookImportReport report) {
    if (report.failedCount > 0) {
      return _ShelfNotice(
        title: '导入已完成',
        message:
            '成功 ${report.importedCount} 本，重复 ${report.duplicateCount} 本，失败 ${report.failedCount} 本。',
        tone: report.importedCount > 0
            ? UxNoticeTone.warning
            : UxNoticeTone.danger,
      );
    }
    if (report.duplicateCount > 0) {
      return _ShelfNotice(
        title: '检测到重复书籍',
        message:
            '成功 ${report.importedCount} 本，本地重复 ${report.duplicateCount} 本。',
        tone: UxNoticeTone.info,
      );
    }
    return _ShelfNotice(
      title: '导入成功',
      message: '本次共导入 ${report.importedCount} 本书籍。',
      tone: UxNoticeTone.success,
    );
  }

  Future<void> _showBookActions(BookshelfBook book) async {
    final _BookMenuAction? result = await showModalBottomSheet<_BookMenuAction>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return _OptionSheet(
          title: book.title,
          options: <_OptionItem<_BookMenuAction>>[
            const _OptionItem<_BookMenuAction>(
              value: _BookMenuAction.detail,
              title: '查看详情',
            ),
            const _OptionItem<_BookMenuAction>(
              value: _BookMenuAction.read,
              title: '继续阅读',
            ),
            _OptionItem<_BookMenuAction>(
              value: _BookMenuAction.favorite,
              title: book.isFavorite ? '取消收藏' : '加入收藏',
            ),
            _OptionItem<_BookMenuAction>(
              value: _BookMenuAction.pin,
              title: book.isPinned ? '取消置顶' : '置顶书籍',
            ),
            const _OptionItem<_BookMenuAction>(
              value: _BookMenuAction.delete,
              title: '删除书籍',
              danger: true,
            ),
          ],
        );
      },
    );

    if (result == null || !mounted) {
      return;
    }

    switch (result) {
      case _BookMenuAction.detail:
        _openBookDetail(book);
      case _BookMenuAction.read:
        _continueReading(book);
      case _BookMenuAction.favorite:
        await ref
            .read(bookshelfRepositoryProvider)
            .setFavorite(book.id, isFavorite: !book.isFavorite);
      case _BookMenuAction.pin:
        await ref
            .read(bookshelfRepositoryProvider)
            .setPinned(book.id, isPinned: !book.isPinned);
      case _BookMenuAction.delete:
        await _confirmDeleteBook(book);
    }
  }

  Future<void> _confirmDeleteBook(BookshelfBook book) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('删除书籍'),
          content: Text('确定从书架移除《${book.title}》吗？导入记录会保留。'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('删除'),
            ),
          ],
        );
      },
    );
    if (confirmed != true) {
      return;
    }
    await ref.read(bookshelfRepositoryProvider).deleteBook(book.id);
  }

  void _toggleView() {
    setState(() {
      _currentView = _currentView == _ShelfView.grid
          ? _ShelfView.list
          : _ShelfView.grid;
    });
  }

  void _openBookDetail(BookshelfBook book) {
    context.pushNamed(
      AppRoute.bookDetail.name,
      pathParameters: <String, String>{'bookId': book.id},
    );
  }

  Future<void> _continueReading(BookshelfBook book) async {
    await ref.read(bookshelfRepositoryProvider).markReadIntent(book.id);
    await _prewarmReader(book.id);
    if (!mounted) {
      return;
    }
    context.pushNamed(
      AppRoute.reader.name,
      pathParameters: <String, String>{'bookId': book.id},
    );
  }

  Future<void> _prewarmReader(String bookId) {
    return ref.read(readerLaunchWarmupServiceProvider).warmUpBook(
      bookId: bookId,
      viewportSize: MediaQuery.sizeOf(context),
      textScaler: MediaQuery.textScalerOf(context),
    );
  }

  void _scheduleRecentReadWarmup(
    BuildContext context,
    List<BookshelfBook> books,
  ) {
    if (books.isEmpty) {
      return;
    }
    final List<BookshelfBook> recentBooks = books.toList()
      ..sort((BookshelfBook a, BookshelfBook b) {
        return (b.lastReadAt ?? DateTime(1970)).compareTo(
          a.lastReadAt ?? DateTime(1970),
        );
      });
    final BookshelfBook candidate = recentBooks.first;
    if (candidate.lastReadAt == null || _preheatedRecentBookId == candidate.id) {
      return;
    }
    _preheatedRecentBookId = candidate.id;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      unawaited(_prewarmReader(candidate.id));
    });
  }
}

class _BookshelfContent extends StatelessWidget {
  const _BookshelfContent({
    required this.view,
    required this.books,
    required this.onOpenDetail,
    required this.onContinueRead,
    required this.onOpenBookMenu,
  });

  final _ShelfView view;
  final List<BookshelfBook> books;
  final ValueChanged<BookshelfBook> onOpenDetail;
  final ValueChanged<BookshelfBook> onContinueRead;
  final ValueChanged<BookshelfBook> onOpenBookMenu;

  @override
  Widget build(BuildContext context) {
    if (view == _ShelfView.grid) {
      return GridView.builder(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 96),
        itemCount: books.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 16,
          mainAxisSpacing: 22,
          childAspectRatio: 0.44,
        ),
        itemBuilder: (BuildContext context, int index) {
          return _BookCard(
            data: books[index],
            onOpenDetail: () => onOpenDetail(books[index]),
            onContinueRead: () => onContinueRead(books[index]),
            onOpenMenu: () => onOpenBookMenu(books[index]),
          );
        },
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 96),
      itemCount: books.length,
      separatorBuilder: (BuildContext context, int index) =>
          const SizedBox(height: 14),
      itemBuilder: (BuildContext context, int index) {
        final BookshelfBook book = books[index];
        return _BookListTile(
          data: book,
          onOpenDetail: () => onOpenDetail(book),
          onContinueRead: () => onContinueRead(book),
          onOpenMenu: () => onOpenBookMenu(book),
        );
      },
    );
  }
}

class _BookshelfEmptyState extends StatelessWidget {
  const _BookshelfEmptyState({
    required this.hasSearch,
    required this.onResetSearch,
    required this.onImport,
  });

  final bool hasSearch;
  final VoidCallback onResetSearch;
  final VoidCallback onImport;

  @override
  Widget build(BuildContext context) {
    return UxStateView(
      icon: hasSearch ? Icons.search_off_rounded : Icons.menu_book_rounded,
      title: hasSearch ? '没有找到相关书籍' : '书架还空着',
      message: hasSearch ? '换个关键词试试，或者清除当前筛选条件。' : '导入一本本地书，书架就会开始生长。',
      caption: hasSearch ? null : '支持 TXT / EPUB',
      primaryAction: UxStateAction(
        label: hasSearch ? '清除筛选' : '导入书籍',
        onPressed: hasSearch ? onResetSearch : onImport,
      ),
      scrollable: true,
      padding: const EdgeInsets.fromLTRB(24, 40, 24, 120),
      iconBackgroundColor: const Color(0xFFF3F4F6),
      iconColor: const Color(0xFFC0C4CC),
      primaryColor: _BookshelfPageState._green,
      outlineColor: _BookshelfPageState._line,
    );
  }
}

class _BookshelfErrorState extends StatelessWidget {
  const _BookshelfErrorState({
    required this.message,
    required this.onRetry,
    required this.onImport,
  });

  final String message;
  final VoidCallback onRetry;
  final VoidCallback onImport;

  @override
  Widget build(BuildContext context) {
    return UxStateView(
      icon: Icons.cloud_off_rounded,
      title: '书架暂时打不开',
      message: '$message，请重新加载书架数据或直接继续导入新书。',
      primaryAction: UxStateAction(label: '重新加载', onPressed: onRetry),
      secondaryAction: UxStateAction(
        label: '导入书籍',
        onPressed: onImport,
        filled: false,
      ),
      iconBackgroundColor: const Color(0xFFF8EFEC),
      iconColor: const Color(0xFFD07B6D),
      primaryColor: _BookshelfPageState._green,
      outlineColor: _BookshelfPageState._line,
    );
  }
}

class _ImportResultSheet extends StatelessWidget {
  const _ImportResultSheet({
    required this.report,
    required this.onClose,
    required this.onViewBookshelf,
    this.onRetryFailed,
  });

  final BookImportReport report;
  final VoidCallback onClose;
  final VoidCallback onViewBookshelf;
  final VoidCallback? onRetryFailed;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFE6E8EC),
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              '导入完成',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: _BookshelfPageState._black,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              report.summary,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                height: 1.5,
                color: _BookshelfPageState._muted,
              ),
            ),
            const SizedBox(height: 18),
            Row(
              children: <Widget>[
                Expanded(
                  child: _ImportSummaryCard(
                    label: '成功',
                    value: report.importedCount,
                    color: const Color(0xFF2E9D62),
                    background: const Color(0xFFEAF7EE),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _ImportSummaryCard(
                    label: '重复',
                    value: report.duplicateCount,
                    color: const Color(0xFF7B8AA0),
                    background: const Color(0xFFF0F3F8),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _ImportSummaryCard(
                    label: '失败',
                    value: report.failedCount,
                    color: const Color(0xFFC46A3A),
                    background: const Color(0xFFFFF4EB),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Flexible(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 320),
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: report.items.length,
                  separatorBuilder: (BuildContext context, int index) =>
                      const SizedBox(height: 10),
                  itemBuilder: (BuildContext context, int index) {
                    final BookImportItemResult item = report.items[index];
                    return _ImportResultTile(item: item);
                  },
                ),
              ),
            ),
            const SizedBox(height: 18),
            Row(
              children: <Widget>[
                Expanded(
                  child: OutlinedButton(
                    onPressed: onRetryFailed ?? onClose,
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(48),
                      side: const BorderSide(color: _BookshelfPageState._line),
                      foregroundColor: _BookshelfPageState._black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Text(onRetryFailed == null ? '关闭' : '重试失败项'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: onViewBookshelf,
                    style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(48),
                      backgroundColor: _BookshelfPageState._green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text('查看书架'),
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

class _ImportSummaryCard extends StatelessWidget {
  const _ImportSummaryCard({
    required this.label,
    required this.value,
    required this.color,
    required this.background,
  });

  final String label;
  final int value;
  final Color color;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: <Widget>[
          Text(
            '$value',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _ImportResultTile extends StatelessWidget {
  const _ImportResultTile({required this.item});

  final BookImportItemResult item;

  @override
  Widget build(BuildContext context) {
    final ({Color bg, Color fg, String label}) status = switch (item.status) {
      BookImportItemStatus.imported => (
        bg: const Color(0xFFEAF7EE),
        fg: const Color(0xFF2E9D62),
        label: '已导入',
      ),
      BookImportItemStatus.duplicate => (
        bg: const Color(0xFFF0F3F8),
        fg: const Color(0xFF6F7F95),
        label: '重复',
      ),
      BookImportItemStatus.failed => (
        bg: const Color(0xFFFFF4EB),
        fg: const Color(0xFFC46A3A),
        label: '失败',
      ),
    };

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FB),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  item.fileName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: _BookshelfPageState._black,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: status.bg,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        status.label,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: status.fg,
                        ),
                      ),
                    ),
                    if (item.format != null) ...<Widget>[
                      const SizedBox(width: 8),
                      Text(
                        item.format!.value.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: _BookshelfPageState._muted,
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  item.message,
                  style: const TextStyle(
                    fontSize: 12,
                    height: 1.45,
                    color: _BookshelfPageState._muted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ShelfNotice {
  const _ShelfNotice({
    required this.title,
    required this.message,
    required this.tone,
  });

  final String title;
  final String message;
  final UxNoticeTone tone;
}

List<Color> _coverGradientColors(BookshelfBook book) {
  final List<List<Color>> palettes = <List<Color>>[
    <Color>[Color(0xFFE6D1A4), Color(0xFFB69668)],
    <Color>[Color(0xFFFFB200), Color(0xFF101114)],
    <Color>[Color(0xFFE9ECEE), Color(0xFF467E9B)],
    <Color>[Color(0xFFF7F1E5), Color(0xFFD1B07A)],
    <Color>[Color(0xFF972B2B), Color(0xFF1F1A1A)],
    <Color>[Color(0xFFE7C28D), Color(0xFFB13A1E)],
  ];
  final int seed = book.title.codeUnits.fold<int>(
    0,
    (int sum, int codeUnit) => sum + codeUnit,
  );
  return palettes[seed % palettes.length];
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: onTap,
      radius: 18,
      child: Icon(icon, size: 22, color: _BookshelfPageState._black),
    );
  }
}

class _ShelfTab extends StatelessWidget {
  const _ShelfTab({required this.data, required this.onTap});

  final _ShelfTabData data;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Color color = data.selected
        ? _BookshelfPageState._green
        : _BookshelfPageState._muted;

    return InkResponse(
      onTap: onTap,
      radius: 20,
      child: Padding(
        padding: const EdgeInsets.only(right: 18),
        child: Column(
          children: <Widget>[
            Text.rich(
              TextSpan(
                children: <InlineSpan>[
                  TextSpan(
                    text: data.label,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: data.selected
                          ? FontWeight.w700
                          : FontWeight.w500,
                      color: color,
                    ),
                  ),
                  TextSpan(
                    text: ' ${data.count}',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: data.selected
                          ? FontWeight.w700
                          : FontWeight.w500,
                      color: color,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 24,
              height: 2.5,
              decoration: BoxDecoration(
                color: data.selected
                    ? _BookshelfPageState._green
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BookCard extends StatelessWidget {
  const _BookCard({
    required this.data,
    required this.onOpenDetail,
    required this.onContinueRead,
    required this.onOpenMenu,
  });

  final BookshelfBook data;
  final VoidCallback onOpenDetail;
  final VoidCallback onContinueRead;
  final VoidCallback onOpenMenu;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onContinueRead,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: const <BoxShadow>[
                      BoxShadow(
                        color: Color(0x12000000),
                        blurRadius: 12,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: AspectRatio(
                    aspectRatio: 0.68,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: _coverGradientColors(data),
                          ),
                        ),
                        child: _CoverArt(data: data),
                      ),
                    ),
                  ),
                ),
                if (data.isFavorite)
                  const Positioned(
                    top: 6,
                    right: 6,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: _BookshelfPageState._green,
                        shape: BoxShape.circle,
                      ),
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: Icon(
                          Icons.check_rounded,
                          size: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              data.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: _BookshelfPageState._black,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              data.author,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: _BookshelfPageState._muted,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: <Widget>[
                Expanded(
                  child: InkWell(
                    onTap: onContinueRead,
                    borderRadius: BorderRadius.circular(4),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Text(
                        data.progressLabel,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: _BookshelfPageState._muted,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                InkResponse(
                  onTap: onOpenMenu,
                  radius: 16,
                  child: const Icon(
                    Icons.more_horiz_rounded,
                    size: 18,
                    color: _BookshelfPageState._black,
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

class _BookListTile extends StatelessWidget {
  const _BookListTile({
    required this.data,
    required this.onOpenDetail,
    required this.onContinueRead,
    required this.onOpenMenu,
  });

  final BookshelfBook data;
  final VoidCallback onOpenDetail;
  final VoidCallback onContinueRead;
  final VoidCallback onOpenMenu;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onContinueRead,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _BookshelfPageState._line),
            boxShadow: const <BoxShadow>[
              BoxShadow(
                color: Color(0x12000000),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: <Widget>[
              SizedBox(
                width: 72,
                child: AspectRatio(
                  aspectRatio: 0.68,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: _coverGradientColors(data),
                        ),
                      ),
                      child: _CoverArt(data: data),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      data.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: _BookshelfPageState._black,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      data.author,
                      style: const TextStyle(
                        fontSize: 13,
                        color: _BookshelfPageState._muted,
                      ),
                    ),
                    const SizedBox(height: 10),
                    InkWell(
                      onTap: onContinueRead,
                      borderRadius: BorderRadius.circular(4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            data.progressLabel,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: _BookshelfPageState._muted,
                            ),
                          ),
                          const SizedBox(height: 6),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(999),
                            child: LinearProgressIndicator(
                              value: data.progressPercent,
                              minHeight: 4,
                              backgroundColor: const Color(0xFFEAEAEA),
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                _BookshelfPageState._green,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              InkResponse(
                onTap: onOpenMenu,
                radius: 18,
                child: const Icon(
                  Icons.more_horiz_rounded,
                  size: 22,
                  color: _BookshelfPageState._black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CoverArt extends StatelessWidget {
  const _CoverArt({required this.data});

  final BookshelfBook data;

  @override
  Widget build(BuildContext context) {
    final String? coverImagePath = data.coverImagePath;
    if (coverImagePath != null && File(coverImagePath).existsSync()) {
      return Image.file(File(coverImagePath), fit: BoxFit.cover);
    }

    switch (data.title) {
      case '大秦帝国（全六部）':
        return Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Positioned(
              bottom: -6,
              left: -8,
              right: -8,
              child: Container(
                height: 70,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: <Color>[Color(0x00000000), Color(0x66000000)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),
            const Center(
              child: Text(
                '大秦帝国',
                style: TextStyle(
                  color: Color(0xFF3B2614),
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2,
                ),
              ),
            ),
          ],
        );
      case '三体全集':
        return Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Center(
              child: Container(
                width: 54,
                height: 54,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: <Color>[Color(0xFFFFD24A), Color(0xFFFF7A00)],
                  ),
                ),
              ),
            ),
            const Center(
              child: SizedBox(
                width: 88,
                height: 88,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.fromBorderSide(
                      BorderSide(color: Color(0x33FFFFFF), width: 1),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      case '活着':
        return const Center(
          child: Text(
            '活着',
            style: TextStyle(
              color: Color(0xFF16384A),
              fontSize: 22,
              fontWeight: FontWeight.w700,
              letterSpacing: 4,
            ),
          ),
        );
      case '人类简史':
        return const Center(
          child: Text(
            '人类简史',
            style: TextStyle(
              color: Color(0xFFB1843B),
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        );
      case '百年孤独':
        return const Center(
          child: SizedBox(
            width: 52,
            height: 72,
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(40)),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[Color(0xFFB31616), Color(0xFF2E0F0F)],
                ),
              ),
            ),
          ),
        );
      case '明朝那些事儿':
        return const Center(
          child: Text(
            '明朝那些事儿',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF6E200F),
              fontSize: 18,
              fontWeight: FontWeight.w700,
              height: 1.15,
            ),
          ),
        );
      default:
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              data.title,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w700,
                height: 1.15,
              ),
            ),
          ),
        );
    }
  }
}

class _OptionSheet<T> extends StatelessWidget {
  const _OptionSheet({required this.title, required this.options});

  final String title;
  final List<_OptionItem<T>> options;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: 44,
              height: 5,
              decoration: BoxDecoration(
                color: const Color(0xFFE6E2DE),
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            const SizedBox(height: 14),
            Text(
              title,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: _BookshelfPageState._black,
              ),
            ),
            const SizedBox(height: 12),
            ...options.map(
              (_OptionItem<T> item) => ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  item.title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: item.selected
                        ? FontWeight.w700
                        : FontWeight.w500,
                    color: item.danger
                        ? const Color(0xFFE4553F)
                        : _BookshelfPageState._black,
                  ),
                ),
                trailing: item.selected
                    ? const Icon(
                        Icons.check_rounded,
                        color: _BookshelfPageState._green,
                      )
                    : null,
                onTap: () => Navigator.of(context).pop(item.value),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BookshelfSearchDelegate extends SearchDelegate<String?> {
  _BookshelfSearchDelegate({
    required this.books,
    required String initialQuery,
  }) {
    query = initialQuery;
  }

  final List<BookshelfBook> books;

  @override
  String get searchFieldLabel => '搜索书名或作者';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return <Widget>[
      if (query.isNotEmpty)
        IconButton(
          onPressed: () {
            query = '';
            showSuggestions(context);
          },
          icon: const Icon(Icons.close_rounded),
        ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () => close(context, null),
      icon: const Icon(Icons.arrow_back_rounded),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final List<BookshelfBook> results = _results;
    if (results.isEmpty) {
      return const Center(child: Text('没有找到相关书籍'));
    }
    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (BuildContext context, int index) {
        final BookshelfBook book = results[index];
        return ListTile(
          title: Text(book.title),
          subtitle: Text(book.author),
          onTap: () => close(context, query),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final List<BookshelfBook> results = _results;
    if (results.isEmpty) {
      return const Center(child: Text('输入关键词开始搜索'));
    }
    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (BuildContext context, int index) {
        final BookshelfBook book = results[index];
        return ListTile(
          title: Text(book.title),
          subtitle: Text(book.author),
          onTap: () {
            query = book.title;
            close(context, query);
          },
        );
      },
    );
  }

  List<BookshelfBook> get _results {
    final String keyword = query.trim().toLowerCase();
    if (keyword.isEmpty) {
      return books;
    }
    return books.where((BookshelfBook book) {
      return book.title.toLowerCase().contains(keyword) ||
          book.author.toLowerCase().contains(keyword);
    }).toList();
  }
}

class _OptionItem<T> {
  const _OptionItem({
    required this.value,
    required this.title,
    this.selected = false,
    this.danger = false,
  });

  final T value;
  final String title;
  final bool selected;
  final bool danger;
}

class _ShelfTabData {
  const _ShelfTabData({
    required this.filter,
    required this.label,
    required this.count,
    required this.selected,
  });

  final _ShelfFilter filter;
  final String label;
  final int count;
  final bool selected;
}

enum _ShelfFilter { all, reading, favorite, pinned }

enum _ShelfView { grid, list }

enum _SortType {
  recentRead('最近阅读'),
  imported('导入时间'),
  title('书名排序'),
  progress('阅读进度');

  const _SortType(this.label);
  final String label;
}

enum _TopMenuAction { toggleView, batchManage, clearSearch }

enum _ImportAction { localFile, scanFolder }

enum _BookMenuAction { detail, read, favorite, pin, delete }
