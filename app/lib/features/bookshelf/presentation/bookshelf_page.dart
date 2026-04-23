import 'package:flutter/material.dart';

class BookshelfPage extends StatelessWidget {
  const BookshelfPage({super.key});

  static const Color _green = Color(0xFF1DB954);
  static const Color _black = Color(0xFF2B2D38);
  static const Color _muted = Color(0xFF8F939C);
  static const Color _line = Color(0xFFE5E6EB);
  static const Color _bg = Color(0xFFFFFFFF);

  static const List<_ShelfTabData> _tabs = <_ShelfTabData>[
    _ShelfTabData(label: '全部', count: 128, selected: true),
    _ShelfTabData(label: '在读', count: 32),
    _ShelfTabData(label: '收藏', count: 18),
    _ShelfTabData(label: '置顶', count: 6),
  ];

  static const List<_BookItemData> _books = <_BookItemData>[
    _BookItemData(
      title: '大秦帝国（全六部）',
      author: '孙皓晖',
      status: '已读 68%',
      coverBackground: Color(0xFFB69668),
      coverAccent: Color(0xFFE6D1A4),
    ),
    _BookItemData(
      title: '三体全集',
      author: '刘慈欣',
      status: '已读 24%',
      coverBackground: Color(0xFF101114),
      coverAccent: Color(0xFFFFB200),
    ),
    _BookItemData(
      title: '活着',
      author: '余华',
      status: '已读 100%',
      coverBackground: Color(0xFFE9ECEE),
      coverAccent: Color(0xFF467E9B),
      checked: true,
    ),
    _BookItemData(
      title: '人类简史',
      author: '尤瓦尔·赫拉利',
      status: '已读 12%',
      coverBackground: Color(0xFFF7F1E5),
      coverAccent: Color(0xFFD1B07A),
    ),
    _BookItemData(
      title: '百年孤独',
      author: '加西亚·马尔克斯',
      status: '未读',
      coverBackground: Color(0xFF1F1A1A),
      coverAccent: Color(0xFF972B2B),
    ),
    _BookItemData(
      title: '明朝那些事儿',
      author: '当年明月',
      status: '已读 56%',
      coverBackground: Color(0xFFE7C28D),
      coverAccent: Color(0xFFB13A1E),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      floatingActionButton: SizedBox(
        width: 54,
        height: 54,
        child: FloatingActionButton(
          onPressed: () {},
          elevation: 0,
          backgroundColor: _green,
          shape: const CircleBorder(),
          child: const Icon(Icons.add_rounded, size: 30, color: Colors.white),
        ),
      ),
      bottomNavigationBar: const _BottomBar(),
      body: SafeArea(
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
                        onTap: () {},
                      ),
                      const SizedBox(width: 14),
                      _ActionButton(
                        icon: Icons.filter_alt_outlined,
                        onTap: () {},
                      ),
                      const SizedBox(width: 14),
                      _ActionButton(
                        icon: Icons.more_horiz_rounded,
                        onTap: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: <Widget>[
                      ..._tabs.map(_ShelfTab.new),
                      const Spacer(),
                      const Icon(
                        Icons.view_list_rounded,
                        size: 18,
                        color: Color(0xFFC9CDD3),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 96),
                itemCount: _books.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 22,
                  childAspectRatio: 0.47,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return _BookCard(data: _books[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.onTap,
  });

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: onTap,
      radius: 18,
      child: Icon(icon, size: 22, color: BookshelfPage._black),
    );
  }
}

class _ShelfTab extends StatelessWidget {
  const _ShelfTab(this.data);

  final _ShelfTabData data;

  @override
  Widget build(BuildContext context) {
    final Color color = data.selected ? BookshelfPage._green : BookshelfPage._muted;

    return Padding(
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
                    fontWeight: data.selected ? FontWeight.w700 : FontWeight.w500,
                    color: color,
                  ),
                ),
                TextSpan(
                  text: ' ${data.count}',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: data.selected ? FontWeight.w700 : FontWeight.w500,
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
              color: data.selected ? BookshelfPage._green : Colors.transparent,
              borderRadius: BorderRadius.circular(999),
            ),
          ),
        ],
      ),
    );
  }
}

class _BookCard extends StatelessWidget {
  const _BookCard({required this.data});

  final _BookItemData data;

  @override
  Widget build(BuildContext context) {
    return Column(
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
                        colors: <Color>[
                          data.coverAccent,
                          data.coverBackground,
                        ],
                      ),
                    ),
                    child: _CoverArt(data: data),
                  ),
                ),
              ),
            ),
            if (data.checked)
              const Positioned(
                top: 6,
                right: 6,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: BookshelfPage._green,
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
        const SizedBox(height: 10),
        Text(
          data.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: BookshelfPage._black,
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
            color: BookshelfPage._muted,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: <Widget>[
            Expanded(
              child: Text(
                data.status,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: BookshelfPage._muted,
                ),
              ),
            ),
            const SizedBox(width: 6),
            const Icon(
              Icons.more_horiz_rounded,
              size: 18,
              color: BookshelfPage._black,
            ),
          ],
        ),
      ],
    );
  }
}

class _CoverArt extends StatelessWidget {
  const _CoverArt({required this.data});

  final _BookItemData data;

  @override
  Widget build(BuildContext context) {
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
        return const SizedBox.shrink();
    }
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 74,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: BookshelfPage._line),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 10),
        child: Row(
          children: const <Widget>[
            Expanded(
              child: _BottomItem(
                icon: Icons.menu_book_outlined,
                label: '书架',
                selected: true,
              ),
            ),
            Expanded(
              child: _BottomItem(
                icon: Icons.explore_outlined,
                label: '发现',
              ),
            ),
            SizedBox(width: 68),
            Expanded(
              child: _BottomItem(
                icon: Icons.person_outline_rounded,
                label: '我的',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomItem extends StatelessWidget {
  const _BottomItem({
    required this.icon,
    required this.label,
    this.selected = false,
  });

  final IconData icon;
  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final Color color = selected ? BookshelfPage._green : const Color(0xFF8B9099);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(icon, size: 22, color: color),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
            color: color,
          ),
        ),
      ],
    );
  }
}

class _ShelfTabData {
  const _ShelfTabData({
    required this.label,
    required this.count,
    this.selected = false,
  });

  final String label;
  final int count;
  final bool selected;
}

class _BookItemData {
  const _BookItemData({
    required this.title,
    required this.author,
    required this.status,
    required this.coverBackground,
    required this.coverAccent,
    this.checked = false,
  });

  final String title;
  final String author;
  final String status;
  final Color coverBackground;
  final Color coverAccent;
  final bool checked;
}
