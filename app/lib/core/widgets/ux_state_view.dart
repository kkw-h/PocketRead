import 'package:flutter/material.dart';

enum UxNoticeTone { info, success, warning, danger }

class UxStateAction {
  const UxStateAction({
    required this.label,
    required this.onPressed,
    this.filled = true,
  });

  final String label;
  final VoidCallback onPressed;
  final bool filled;
}

class UxStateView extends StatelessWidget {
  const UxStateView({
    required this.title,
    required this.message,
    super.key,
    this.icon = Icons.inbox_rounded,
    this.primaryAction,
    this.secondaryAction,
    this.caption,
    this.iconBackgroundColor = const Color(0xFFF1F3F5),
    this.iconColor = const Color(0xFF8F939C),
    this.titleColor = const Color(0xFF2B2D38),
    this.messageColor = const Color(0xFF8F939C),
    this.primaryColor = const Color(0xFF1DB954),
    this.outlineColor = const Color(0xFFE5E6EB),
    this.scrollable = false,
    this.padding = const EdgeInsets.fromLTRB(24, 48, 24, 48),
  });

  final String title;
  final String message;
  final IconData icon;
  final UxStateAction? primaryAction;
  final UxStateAction? secondaryAction;
  final String? caption;
  final Color iconBackgroundColor;
  final Color iconColor;
  final Color titleColor;
  final Color messageColor;
  final Color primaryColor;
  final Color outlineColor;
  final bool scrollable;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final Widget content = Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 320),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                color: iconBackgroundColor,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 38, color: iconColor),
            ),
            const SizedBox(height: 22),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 21,
                height: 1.25,
                fontWeight: FontWeight.w700,
                color: titleColor,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                height: 1.6,
                color: messageColor,
              ),
            ),
            if (caption != null) ...<Widget>[
              const SizedBox(height: 12),
              Text(
                caption!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: messageColor,
                ),
              ),
            ],
            if (primaryAction != null || secondaryAction != null) ...<Widget>[
              const SizedBox(height: 28),
              if (primaryAction != null)
                _UxActionButton(
                  label: primaryAction!.label,
                  onPressed: primaryAction!.onPressed,
                  filled: primaryAction!.filled,
                  primaryColor: primaryColor,
                  outlineColor: outlineColor,
                ),
              if (primaryAction != null && secondaryAction != null)
                const SizedBox(height: 12),
              if (secondaryAction != null)
                _UxActionButton(
                  label: secondaryAction!.label,
                  onPressed: secondaryAction!.onPressed,
                  filled: secondaryAction!.filled,
                  primaryColor: primaryColor,
                  outlineColor: outlineColor,
                ),
            ],
          ],
        ),
      ),
    );

    if (scrollable) {
      return ListView(padding: padding, children: <Widget>[content]);
    }
    return Padding(padding: padding, child: content);
  }
}

class UxInlineNotice extends StatelessWidget {
  const UxInlineNotice({
    required this.message,
    super.key,
    this.title,
    this.tone = UxNoticeTone.info,
    this.onClose,
  });

  final String? title;
  final String message;
  final UxNoticeTone tone;
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    final _UxNoticePalette palette = _paletteForTone(tone);
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 10, 12),
      decoration: BoxDecoration(
        color: palette.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: palette.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 1),
            child: Icon(palette.icon, size: 18, color: palette.foreground),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                if (title != null)
                  Text(
                    title!,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: palette.foreground,
                    ),
                  ),
                if (title != null) const SizedBox(height: 2),
                Text(
                  message,
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.45,
                    color: palette.foreground,
                  ),
                ),
              ],
            ),
          ),
          if (onClose != null)
            InkResponse(
              onTap: onClose,
              radius: 16,
              child: Padding(
                padding: const EdgeInsets.all(2),
                child: Icon(
                  Icons.close_rounded,
                  size: 18,
                  color: palette.foreground,
                ),
              ),
            ),
        ],
      ),
    );
  }

  _UxNoticePalette _paletteForTone(UxNoticeTone tone) {
    return switch (tone) {
      UxNoticeTone.info => const _UxNoticePalette(
          background: Color(0xFFEAF3FF),
          border: Color(0xFFCFE1FF),
          foreground: Color(0xFF3A6AA0),
          icon: Icons.info_outline_rounded,
        ),
      UxNoticeTone.success => const _UxNoticePalette(
          background: Color(0xFFEAF7EE),
          border: Color(0xFFD0EAD9),
          foreground: Color(0xFF2C7A4B),
          icon: Icons.check_circle_outline_rounded,
        ),
      UxNoticeTone.warning => const _UxNoticePalette(
          background: Color(0xFFFFF6E6),
          border: Color(0xFFF2DEAE),
          foreground: Color(0xFF9C6A0A),
          icon: Icons.error_outline_rounded,
        ),
      UxNoticeTone.danger => const _UxNoticePalette(
          background: Color(0xFFFCEAEA),
          border: Color(0xFFF4CFCF),
          foreground: Color(0xFFB14C4C),
          icon: Icons.report_gmailerrorred_rounded,
        ),
    };
  }
}

class _UxActionButton extends StatelessWidget {
  const _UxActionButton({
    required this.label,
    required this.onPressed,
    required this.filled,
    required this.primaryColor,
    required this.outlineColor,
  });

  final String label;
  final VoidCallback onPressed;
  final bool filled;
  final Color primaryColor;
  final Color outlineColor;

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style = filled
        ? FilledButton.styleFrom(
            minimumSize: const Size(double.infinity, 48),
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          )
        : OutlinedButton.styleFrom(
            minimumSize: const Size(double.infinity, 48),
            foregroundColor: const Color(0xFF2B2D38),
            side: BorderSide(color: outlineColor),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          );

    return filled
        ? FilledButton(onPressed: onPressed, style: style, child: Text(label))
        : OutlinedButton(onPressed: onPressed, style: style, child: Text(label));
  }
}

class _UxNoticePalette {
  const _UxNoticePalette({
    required this.background,
    required this.border,
    required this.foreground,
    required this.icon,
  });

  final Color background;
  final Color border;
  final Color foreground;
  final IconData icon;
}
