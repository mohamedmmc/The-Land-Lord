import 'package:flutter/material.dart';
import 'package:the_land_lord_website/utils/constants/colors.dart';

import '../utils/theme/theme.dart';

class OverflowedTextWithTooltip extends StatelessWidget {
  final String title;
  final TextStyle? style;
  final Color? titleColor;
  final bool expand;

  /// This widget generally should be put inside a row or a column since it start with an expanded to get all the available space.
  /// It only requires the [title] to put in the Text widget.
  /// Optionally we could change the Text widget color with the parameter [titleColor].
  /// Or we could change the Text widget style with the parameter [style] this will discard the [titleColor] if provided.
  /// If the [title] is short and not overflowed the tooltip will be disabled.
  ///
  const OverflowedTextWithTooltip({required this.title, this.titleColor, this.style, this.expand = true, super.key});

  Widget _buildOverflowedTextWithTooltip(BuildContext context) => LayoutBuilder(
        // This layoutBuilder is used to detect if the title will be overflowed or not, to assign a tooltip with it if so.
        builder: (context, size) {
          final span = TextSpan(
            text: title,
            style: style ?? AppFonts.x16Regular.copyWith(color: titleColor ?? kNeutralColor, fontWeight: FontWeight.w400),
          );
          final tp = TextPainter(maxLines: 1, textAlign: TextAlign.left, textDirection: TextDirection.ltr, text: span);
          tp.layout(maxWidth: size.maxWidth);
          // whether the text overflowed or not
          return Tooltip(
            message: tp.didExceedMaxLines ? title : '',
            child: Text(
              title.replaceAll('', '\u{200B}'),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: style ?? AppFonts.x16Regular.copyWith(color: titleColor ?? kNeutralColor, fontWeight: FontWeight.w400),
            ),
          );
        },
      );

  @override
  Widget build(BuildContext context) => expand
      ? Expanded(
          child: _buildOverflowedTextWithTooltip(context),
        )
      : _buildOverflowedTextWithTooltip(context);
}
