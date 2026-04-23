import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pocketread/core/router/app_router.dart';
import 'package:pocketread/core/widgets/app_bottom_nav.dart';

class MyPage extends StatelessWidget {
  const MyPage({super.key});

  static const Color _pageBackground = Color(0xFFF7F5F2);
  static const Color _cardBackground = Color(0xFFFFFFFF);
  static const Color _textPrimary = Color(0xFF2D2525);
  static const Color _textSecondary = Color(0xFF948B86);
  static const Color _textMuted = Color(0xFFB4ACA8);
  static const Color _line = Color(0xFFEAE4DE);
  static const Color _shadow = Color(0x10000000);
  static const Color _green = Color(0xFF2F9D63);
  static const Color _greenSoft = Color(0xFFA6CEB1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _pageBackground,
      bottomNavigationBar: const AppBottomNav(currentTab: AppBottomNavTab.my),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(18, 20, 18, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          '我的',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            color: _textPrimary,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          '你的本地阅读空间',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: _textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  InkResponse(
                    onTap: () => context.pushNamed(AppRoute.settings.name),
                    radius: 22,
                    child: const SizedBox(
                      width: 40,
                      height: 40,
                      child: Icon(
                        Icons.settings_outlined,
                        size: 27,
                        color: _textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),
              const _ReaderSpaceCard(),
              const SizedBox(height: 26),
              const _SectionTitle('功能入口'),
              const SizedBox(height: 12),
              const _MenuCard(),
              const SizedBox(height: 26),
              const _SectionTitle('存储与数据'),
              const SizedBox(height: 12),
              const _StorageCard(),
              const SizedBox(height: 34),
              const Center(
                child: Column(
                  children: <Widget>[
                    Text(
                      '极简阅读 · 纯粹本地',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: _textMuted,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '版本 1.2.3',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: _textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w700,
        color: MyPage._textSecondary,
      ),
    );
  }
}

class _ReaderSpaceCard extends StatelessWidget {
  const _ReaderSpaceCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
      decoration: BoxDecoration(
        color: MyPage._cardBackground,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: MyPage._shadow,
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: <Widget>[
          const Row(
            children: <Widget>[
              _ReaderAvatar(),
              SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '本地阅读者',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: MyPage._textPrimary,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      '专注本地，回归阅读',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: MyPage._textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Container(height: 1, color: MyPage._line),
          const SizedBox(height: 18),
          const Row(
            children: <Widget>[
              Expanded(
                child: _StatBlock(
                  value: '128',
                  label: '累计书籍',
                ),
              ),
              Expanded(
                child: _StatBlock(
                  value: '32',
                  label: '在读书籍',
                ),
              ),
              Expanded(
                child: _StatBlock(
                  value: '18.6h',
                  label: '累计阅读',
                ),
              ),
              Expanded(
                child: _StatBlock(
                  value: '今天 08:30',
                  label: '最近阅读',
                  compact: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ReaderAvatar extends StatelessWidget {
  const _ReaderAvatar();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64,
      height: 64,
      decoration: const BoxDecoration(
        color: Color(0xFFF3F1E8),
        shape: BoxShape.circle,
      ),
      child: Stack(
        children: <Widget>[
          Positioned(
            left: 11,
            top: 15,
            child: Container(
              width: 42,
              height: 22,
              decoration: BoxDecoration(
                color: const Color(0xFFA4B693),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          Positioned(
            left: 17,
            top: 11,
            child: Container(
              width: 30,
              height: 18,
              decoration: const BoxDecoration(
                color: Color(0xFFC8D7B7),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                  bottomLeft: Radius.circular(4),
                  bottomRight: Radius.circular(4),
                ),
              ),
            ),
          ),
          Positioned(
            left: 16,
            top: 28,
            child: Transform.rotate(
              angle: -0.14,
              child: Container(
                width: 32,
                height: 18,
                decoration: BoxDecoration(
                  color: const Color(0xFF7CA26A),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          ),
          Positioned(
            right: 8,
            top: 11,
            child: Transform.rotate(
              angle: 0.24,
              child: Container(
                width: 18,
                height: 26,
                decoration: BoxDecoration(
                  color: const Color(0xFFD7E5CC),
                  borderRadius: BorderRadius.circular(9),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatBlock extends StatelessWidget {
  const _StatBlock({
    required this.value,
    required this.label,
    this.compact = false,
  });

  final String value;
  final String label;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          value,
          style: TextStyle(
            fontSize: compact ? 16 : 18,
            fontWeight: FontWeight.w800,
            color: MyPage._textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: MyPage._textSecondary,
          ),
        ),
      ],
    );
  }
}

class _MenuCard extends StatelessWidget {
  const _MenuCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: MyPage._cardBackground,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: MyPage._shadow,
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: const Column(
        children: <Widget>[
          _MenuTile(
            icon: Icons.settings_outlined,
            title: '阅读设置',
            subtitle: '字体、主题、默认阅读等',
          ),
          _MenuDivider(),
          _MenuTile(
            icon: Icons.file_open_outlined,
            title: '导入记录',
            subtitle: '查看导入历史与状态',
          ),
          _MenuDivider(),
          _MenuTile(
            icon: Icons.description_outlined,
            title: '格式支持说明',
            subtitle: '支持的文件格式与说明',
          ),
          _MenuDivider(),
          _MenuTile(
            icon: Icons.info_outline_rounded,
            title: '关于应用',
            subtitle: '版本信息与开发者致谢',
          ),
        ],
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  const _MenuTile({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 94,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: <Widget>[
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFFF7F5F2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 24, color: MyPage._textPrimary),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: MyPage._textPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: MyPage._textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              size: 24,
              color: MyPage._textMuted,
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuDivider extends StatelessWidget {
  const _MenuDivider();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(height: 1, color: MyPage._line),
    );
  }
}

class _StorageCard extends StatelessWidget {
  const _StorageCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: MyPage._cardBackground,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: MyPage._shadow,
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.fromLTRB(18, 18, 18, 14),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        '本地存储占用',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: MyPage._textPrimary,
                        ),
                      ),
                    ),
                    Text(
                      '4.82 GB / 128 GB',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: MyPage._textSecondary,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 14),
                ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(999)),
                  child: LinearProgressIndicator(
                    value: 0.42,
                    minHeight: 7,
                    backgroundColor: Color(0xFFEAE9E6),
                    valueColor: AlwaysStoppedAnimation<Color>(MyPage._green),
                  ),
                ),
                SizedBox(height: 18),
                _StorageRow(
                  color: MyPage._green,
                  label: '书籍文件',
                  value: '3.21 GB',
                ),
                SizedBox(height: 14),
                _StorageRow(
                  color: MyPage._greenSoft,
                  label: '缓存文件',
                  value: '1.02 GB',
                ),
                SizedBox(height: 14),
                _StorageRow(
                  color: Color(0xFFB9D2BE),
                  label: '其他数据',
                  value: '0.59 GB',
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Container(height: 1, color: MyPage._line),
          ),
          const SizedBox(
            height: 76,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 18),
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.auto_delete_outlined,
                    size: 22,
                    color: MyPage._textPrimary,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      '清理缓存',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: MyPage._textPrimary,
                      ),
                    ),
                  ),
                  Text(
                    '1.02 GB 可清理',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: MyPage._textSecondary,
                    ),
                  ),
                  SizedBox(width: 6),
                  Icon(
                    Icons.chevron_right_rounded,
                    size: 24,
                    color: MyPage._textMuted,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StorageRow extends StatelessWidget {
  const _StorageRow({
    required this.color,
    required this.label,
    required this.value,
  });

  final Color color;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: MyPage._textPrimary,
            ),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: MyPage._textSecondary,
          ),
        ),
      ],
    );
  }
}
