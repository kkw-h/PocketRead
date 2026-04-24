import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pocketread/core/router/app_router.dart';
import 'package:pocketread/core/widgets/ux_state_view.dart';
import 'package:pocketread/features/book_detail/application/book_detail_providers.dart';
import 'package:pocketread/features/book_detail/domain/book_detail_model.dart';
import 'package:pocketread/features/bookshelf/application/bookshelf_providers.dart';
import 'package:pocketread/features/reader/application/reader_providers.dart';

class BookDetailPage extends ConsumerWidget {
  const BookDetailPage({required this.bookId, super.key});

  final String bookId;

  static const Color _pageBackground = Color(0xFFF7F5F2);
  static const Color _cardBackground = Color(0xFFFFFFFF);
  static const Color _textPrimary = Color(0xFF2D2525);
  static const Color _textSecondary = Color(0xFF7E7571);
  static const Color _line = Color(0xFFE9E2DB);
  static const Color _shadow = Color(0x12000000);
  static const Color _buttonBackground = Color(0xFF2E2120);
  static const Color _accentGreen = Color(0xFF2BA36B);
  static const Color _accentOrange = Color(0xFFE9A11A);
  static const Color _danger = Color(0xFFE4553F);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<BookDetailModel?> detail = ref.watch(
      bookDetailProvider(bookId),
    );

    return Scaffold(
      backgroundColor: _pageBackground,
      body: SafeArea(
        child: detail.when(
          loading: () => const Center(
            child: CircularProgressIndicator(color: _buttonBackground),
          ),
          error: (Object error, StackTrace stackTrace) => UxStateView(
            icon: Icons.book_outlined,
            title: '详情加载失败',
            message: '当前书籍信息暂时无法读取，请稍后重试。',
            primaryAction: UxStateAction(
              label: '重新加载',
              onPressed: () => ref.invalidate(bookDetailProvider(bookId)),
            ),
            secondaryAction: UxStateAction(
              label: '返回书架',
              onPressed: () => context.goNamed(AppRoute.bookshelf.name),
              filled: false,
            ),
            iconBackgroundColor: const Color(0xFFF1ECE6),
            iconColor: const Color(0xFFAE8D6A),
            titleColor: _textPrimary,
            messageColor: _textSecondary,
            primaryColor: _accentGreen,
            outlineColor: _line,
          ),
          data: (BookDetailModel? data) {
            if (data == null) {
              return UxStateView(
                icon: Icons.auto_stories_outlined,
                title: '书籍已不可用',
                message: '这本书可能已经被删除，或者本地文件已经失效。',
                primaryAction: UxStateAction(
                  label: '返回书架',
                  onPressed: () => context.goNamed(AppRoute.bookshelf.name),
                ),
                secondaryAction: UxStateAction(
                  label: '重新导入',
                  onPressed: () => context.goNamed(AppRoute.bookshelf.name),
                  filled: false,
                ),
                iconBackgroundColor: const Color(0xFFF3EEE8),
                iconColor: const Color(0xFFA08870),
                titleColor: _textPrimary,
                messageColor: _textSecondary,
                primaryColor: _accentGreen,
                outlineColor: _line,
              );
            }
            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _Header(
                    onBack: () => Navigator.of(context).maybePop(),
                    onMore: () => _showActions(context, ref, data),
                  ),
                  const SizedBox(height: 18),
                  _HeroSection(data: data),
                  const SizedBox(height: 16),
                  _StatsCard(data: data),
                  const SizedBox(height: 16),
                  _ContinueButton(
                    data: data,
                    onTap: () => _openReader(context, ref, data.id),
                  ),
                  const SizedBox(height: 16),
                  _ActionRow(
                    data: data,
                    onToggleFavorite: () => _toggleFavorite(ref, data),
                    onTogglePinned: () => _togglePinned(ref, data),
                    onRead: () => _openReader(context, ref, data.id),
                    onDelete: () => _confirmDelete(context, ref, data),
                  ),
                  const SizedBox(height: 18),
                  _FileInfoCard(data: data),
                  const SizedBox(height: 18),
                  _ImportInfoCard(data: data),
                  const SizedBox(height: 18),
                  _SummaryCard(data: data),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _showActions(
    BuildContext context,
    WidgetRef ref,
    BookDetailModel data,
  ) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return _DetailActionsSheet(
          data: data,
          onToggleFavorite: () async {
            Navigator.of(context).pop();
            await _toggleFavorite(ref, data);
          },
          onTogglePinned: () async {
            Navigator.of(context).pop();
            await _togglePinned(ref, data);
          },
          onCopyLocalPath: () async {
            Navigator.of(context).pop();
            await Clipboard.setData(ClipboardData(text: data.localFilePath));
            if (!context.mounted) {
              return;
            }
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('已复制本地路径')),
            );
          },
          onRead: () {
            Navigator.of(context).pop();
            _openReader(context, ref, data.id);
          },
          onDelete: () {
            Navigator.of(context).pop();
            _confirmDelete(context, ref, data);
          },
        );
      },
    );
  }

  Future<void> _openReader(
    BuildContext context,
    WidgetRef ref,
    String bookId,
  ) async {
    final Size viewportSize = MediaQuery.sizeOf(context);
    final TextScaler textScaler = MediaQuery.textScalerOf(context);
    await ref.read(deleteBookRepositoryProvider).markReadIntent(bookId);
    await ref.read(readerLaunchWarmupServiceProvider).warmUpBook(
      bookId: bookId,
      viewportSize: viewportSize,
      textScaler: textScaler,
    );
    if (!context.mounted) {
      return;
    }
    context.pushNamed(
      AppRoute.reader.name,
      pathParameters: <String, String>{'bookId': bookId},
    );
  }

  Future<void> _toggleFavorite(WidgetRef ref, BookDetailModel data) async {
    await ref
        .read(deleteBookRepositoryProvider)
        .setFavorite(data.id, isFavorite: !data.isFavorite);
    ref.invalidate(bookDetailProvider(data.id));
    ref.invalidate(bookshelfBooksProvider);
  }

  Future<void> _togglePinned(WidgetRef ref, BookDetailModel data) async {
    await ref
        .read(deleteBookRepositoryProvider)
        .setPinned(data.id, isPinned: !data.isPinned);
    ref.invalidate(bookDetailProvider(data.id));
    ref.invalidate(bookshelfBooksProvider);
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    BookDetailModel data,
  ) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('删除书籍'),
          content: Text('确定删除《${data.title}》吗？章节、进度和本地文件会被清理，导入记录会保留。'),
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
    await ref.read(deleteBookRepositoryProvider).deleteBook(data.id);
    ref.invalidate(bookDetailProvider(data.id));
    if (!context.mounted) {
      return;
    }
    context.goNamed(AppRoute.bookshelf.name);
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.onBack, required this.onMore});

  final VoidCallback onBack;
  final VoidCallback onMore;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: Row(
        children: <Widget>[
          _HeaderIconButton(
            icon: Icons.arrow_back_ios_new_rounded,
            onTap: onBack,
          ),
          const Spacer(),
          _HeaderIconButton(icon: Icons.more_horiz_rounded, onTap: onMore),
        ],
      ),
    );
  }
}

class _HeaderIconButton extends StatelessWidget {
  const _HeaderIconButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: onTap,
      radius: 22,
      child: SizedBox(
        width: 28,
        height: 28,
        child: Icon(icon, size: 24, color: BookDetailPage._textPrimary),
      ),
    );
  }
}

class _HeroSection extends StatelessWidget {
  const _HeroSection({required this.data});

  final BookDetailModel data;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _BookCover(data: data),
        const SizedBox(width: 16),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  data.title,
                  style: const TextStyle(
                    fontSize: 18,
                    height: 1.35,
                    fontWeight: FontWeight.w800,
                    color: BookDetailPage._textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  data.author.isEmpty ? '未知作者' : data.author,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: BookDetailPage._textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                _FormatBadge(format: data.format),
                const SizedBox(height: 18),
                _MetaRow(
                  icon: Icons.access_time_rounded,
                  label: '导入时间',
                  value: data.createdAtLabel,
                ),
                const SizedBox(height: 10),
                _MetaRow(
                  icon: Icons.history_rounded,
                  label: '最近阅读',
                  value: data.lastReadAtLabel ?? '未阅读',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _FormatBadge extends StatelessWidget {
  const _FormatBadge({required this.format});

  final String format;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFE3F1E8),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        format,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: BookDetailPage._accentGreen,
        ),
      ),
    );
  }
}

class _MetaRow extends StatelessWidget {
  const _MetaRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Icon(icon, size: 16, color: BookDetailPage._textSecondary),
        const SizedBox(width: 8),
        SizedBox(
          width: 68,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: BookDetailPage._textSecondary,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: BookDetailPage._textSecondary,
            ),
          ),
        ),
      ],
    );
  }
}

class _BookCover extends StatelessWidget {
  const _BookCover({required this.data});

  final BookDetailModel data;

  @override
  Widget build(BuildContext context) {
    final String? coverPath = data.coverImagePath;
    return Container(
      width: 168,
      height: 236,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: BookDetailPage._shadow,
            blurRadius: 16,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: coverPath != null && File(coverPath).existsSync()
            ? Image.file(File(coverPath), fit: BoxFit.cover)
            : _GeneratedCover(data: data),
      ),
    );
  }
}

class _GeneratedCover extends StatelessWidget {
  const _GeneratedCover({required this.data});

  final BookDetailModel data;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[Color(0xFF2D571A), Color(0xFF14220D)],
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Positioned(
            left: 14,
            top: 0,
            bottom: 0,
            child: Container(width: 24, color: const Color(0x663F7622)),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Text(
                data.title,
                textAlign: TextAlign.center,
                maxLines: 5,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Color(0xFFE8F0D7),
                  fontSize: 16,
                  height: 1.45,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ),
          if (data.isFavorite)
            const Positioned(
              top: 8,
              right: 8,
              child: Icon(
                Icons.star_rounded,
                size: 24,
                color: BookDetailPage._accentOrange,
              ),
            ),
          if (data.isPinned)
            Positioned(
              left: 8,
              bottom: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xB05B5A50),
                  borderRadius: BorderRadius.circular(7),
                ),
                child: const Text(
                  '置顶',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _StatsCard extends StatelessWidget {
  const _StatsCard({required this.data});

  final BookDetailModel data;

  @override
  Widget build(BuildContext context) {
    final int percent = (data.progressPercent * 100).round();
    return Container(
      decoration: BoxDecoration(
        color: BookDetailPage._cardBackground,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: BookDetailPage._line),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: BookDetailPage._shadow,
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: _StatItem(
              title: '阅读进度',
              value: '$percent%',
              footer: data.progressLabel,
              progress: data.progressPercent,
              showProgressBar: true,
            ),
          ),
          const _StatDivider(),
          Expanded(
            child: _StatItem(
              title: '章节数',
              value: '${data.totalChapters}',
              footer: '共 ${data.totalChapters} 章',
            ),
          ),
          const _StatDivider(),
          Expanded(
            child: _StatItem(
              title: '文件大小',
              value: data.fileSizeLabel,
              footer: '',
            ),
          ),
        ],
      ),
    );
  }
}

class _StatDivider extends StatelessWidget {
  const _StatDivider();

  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 94, color: BookDetailPage._line);
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.title,
    required this.value,
    required this.footer,
    this.progress,
    this.showProgressBar = false,
  });

  final String title;
  final String value;
  final String footer;
  final double? progress;
  final bool showProgressBar;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: BookDetailPage._textSecondary,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: BookDetailPage._textPrimary,
            ),
          ),
          const SizedBox(height: 10),
          if (showProgressBar) ...<Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                value: progress?.clamp(0, 1),
                minHeight: 5,
                backgroundColor: const Color(0xFFE7ECE8),
                valueColor: const AlwaysStoppedAnimation<Color>(
                  BookDetailPage._accentGreen,
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
          Text(
            footer,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: BookDetailPage._textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _ContinueButton extends StatelessWidget {
  const _ContinueButton({
    required this.data,
    required this.onTap,
  });

  final BookDetailModel data;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: BookDetailPage._buttonBackground,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: SizedBox(
          height: 74,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.menu_book_outlined, color: Colors.white, size: 22),
                  SizedBox(width: 8),
                  Text(
                    '继续阅读',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                data.lastReadChapterLabel == null
                    ? '从第一页开始阅读'
                    : '上次阅读至：${data.lastReadChapterLabel}',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFFBAADA4),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionRow extends StatelessWidget {
  const _ActionRow({
    required this.data,
    required this.onToggleFavorite,
    required this.onTogglePinned,
    required this.onRead,
    required this.onDelete,
  });

  final BookDetailModel data;
  final VoidCallback onToggleFavorite;
  final VoidCallback onTogglePinned;
  final VoidCallback onRead;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: _ActionTile(
            icon: data.isFavorite
                ? Icons.star_rounded
                : Icons.star_outline_rounded,
            label: data.isFavorite ? '已收藏' : '未收藏',
            iconColor: BookDetailPage._accentOrange,
            onTap: onToggleFavorite,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _ActionTile(
            icon: Icons.vertical_align_top_rounded,
            label: data.isPinned ? '已置顶' : '未置顶',
            onTap: onTogglePinned,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _ActionTile(
            icon: Icons.article_outlined,
            label: '阅读',
            onTap: onRead,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _ActionTile(
            icon: Icons.delete_outline_rounded,
            label: '删除',
            iconColor: BookDetailPage._danger,
            textColor: BookDetailPage._danger,
            onTap: onDelete,
          ),
        ),
      ],
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.icon,
    required this.label,
    this.iconColor = BookDetailPage._textPrimary,
    this.textColor = BookDetailPage._textPrimary,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final Color iconColor;
  final Color textColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFF9F5EE),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: SizedBox(
          height: 84,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(icon, size: 24, color: iconColor),
              const SizedBox(height: 10),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: textColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FileInfoCard extends StatelessWidget {
  const _FileInfoCard({required this.data});

  final BookDetailModel data;

  @override
  Widget build(BuildContext context) {
    return _InfoCard(
      title: '文件信息',
      child: Column(
        children: <Widget>[
          _InfoRow(label: '文件名', value: data.fileName),
          const SizedBox(height: 18),
          _InfoRow(label: '文件格式', value: data.format),
          const SizedBox(height: 18),
          _InfoRow(label: '文件大小', value: data.fileSizeLabel),
          const SizedBox(height: 18),
          _InfoRow(label: '本地路径', value: data.localFilePath),
          const SizedBox(height: 18),
          _InfoRow(label: '原始路径', value: data.sourceFilePath),
          const SizedBox(height: 18),
          _InfoRow(label: '封面来源', value: data.coverSourceType ?? '无'),
          const SizedBox(height: 18),
          _InfoRow(
            label: '导入状态',
            value: data.importStatus,
            valueColor: BookDetailPage._accentGreen,
            leadingValueIcon: Icons.check_circle_rounded,
          ),
        ],
      ),
    );
  }
}

class _ImportInfoCard extends StatelessWidget {
  const _ImportInfoCard({required this.data});

  final BookDetailModel data;

  @override
  Widget build(BuildContext context) {
    return _InfoCard(
      title: '导入信息',
      child: Column(
        children: <Widget>[
          _InfoRow(label: '导入记录', value: data.importRecordLabel),
          const SizedBox(height: 18),
          _InfoRow(label: '编码', value: data.charsetName ?? '无'),
          const SizedBox(height: 18),
          _InfoRow(label: '语言', value: data.language ?? '无'),
          const SizedBox(height: 18),
          _InfoRow(label: '文件哈希', value: data.fileHash),
          const SizedBox(height: 18),
          _InfoRow(label: '更新时间', value: data.updatedAtLabel),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.data});

  final BookDetailModel data;

  @override
  Widget build(BuildContext context) {
    return _InfoCard(
      title: '简介',
      child: Text(
        data.description?.trim().isNotEmpty == true
            ? data.description!
            : '暂无简介',
        style: const TextStyle(
          fontSize: 14,
          height: 1.75,
          fontWeight: FontWeight.w600,
          color: BookDetailPage._textSecondary,
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
      decoration: BoxDecoration(
        color: BookDetailPage._cardBackground,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: BookDetailPage._line),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: BookDetailPage._shadow,
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: BookDetailPage._textPrimary,
            ),
          ),
          const SizedBox(height: 18),
          child,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
    this.valueColor = BookDetailPage._textPrimary,
    this.leadingValueIcon,
  });

  final String label;
  final String value;
  final Color valueColor;
  final IconData? leadingValueIcon;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          width: 74,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: BookDetailPage._textSecondary,
            ),
          ),
        ),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (leadingValueIcon != null) ...<Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 1),
                  child: Icon(leadingValueIcon, size: 16, color: valueColor),
                ),
                const SizedBox(width: 6),
              ],
              Expanded(
                child: Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.45,
                    fontWeight: FontWeight.w600,
                    color: valueColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DetailActionsSheet extends StatelessWidget {
  const _DetailActionsSheet({
    required this.data,
    required this.onToggleFavorite,
    required this.onTogglePinned,
    required this.onCopyLocalPath,
    required this.onRead,
    required this.onDelete,
  });

  final BookDetailModel data;
  final VoidCallback onToggleFavorite;
  final VoidCallback onTogglePinned;
  final VoidCallback onCopyLocalPath;
  final VoidCallback onRead;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: const EdgeInsets.fromLTRB(18, 10, 18, 28),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const _SheetHandle(),
            const SizedBox(height: 12),
            _SheetActionTile(
              icon: data.isFavorite
                  ? Icons.star_rounded
                  : Icons.star_outline_rounded,
              title: data.isFavorite ? '取消收藏' : '加入收藏',
              subtitle: '更新书架收藏状态',
              onTap: onToggleFavorite,
            ),
            _SheetActionTile(
              icon: Icons.vertical_align_top_rounded,
              title: data.isPinned ? '取消置顶' : '置顶书籍',
              subtitle: '调整书架展示顺序',
              onTap: onTogglePinned,
            ),
            _SheetActionTile(
              icon: Icons.menu_book_outlined,
              title: '继续阅读',
              subtitle: '打开阅读器',
              onTap: onRead,
            ),
            _SheetActionTile(
              icon: Icons.content_copy_rounded,
              title: '复制本地路径',
              subtitle: '复制应用内书籍文件路径',
              onTap: onCopyLocalPath,
            ),
            const Divider(height: 20, color: BookDetailPage._line),
            _SheetActionTile(
              icon: Icons.delete_outline_rounded,
              title: '删除书籍',
              subtitle: '清理章节、进度和本地文件',
              danger: true,
              onTap: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}

class _SheetHandle extends StatelessWidget {
  const _SheetHandle();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 5,
      decoration: BoxDecoration(
        color: const Color(0xFFE1DDD8),
        borderRadius: BorderRadius.circular(999),
      ),
    );
  }
}

class _SheetActionTile extends StatelessWidget {
  const _SheetActionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.danger = false,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    final Color titleColor = danger
        ? BookDetailPage._danger
        : BookDetailPage._textPrimary;

    return InkWell(
      onTap: onTap,
      child: SizedBox(
        height: 76,
        child: Row(
          children: <Widget>[
            Icon(icon, size: 26, color: titleColor),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: titleColor,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: BookDetailPage._textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              size: 24,
              color: BookDetailPage._textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}
