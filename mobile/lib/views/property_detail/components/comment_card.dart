import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:the_land_lord_website/helpers/helper.dart';
import 'package:the_land_lord_website/utils/constants/colors.dart';

import '../../../helpers/color_generator.dart';
import '../../../models/comments.dart';
import '../../../services/theme/theme.dart';
import '../../../utils/constants/sizes.dart';
import '../../../widgets/overflowed_text_with_tooltip.dart';

class CommentCard extends StatefulWidget {
  final Comments comment;
  const CommentCard({super.key, required this.comment});

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, constraints) {
          final ColorGenerator colorGenerator = ColorGenerator();
          double width = constraints.maxWidth * 0.45;
          if (width < 300) width = constraints.maxWidth;
          var randomColor = colorGenerator.getRandomColor();
          return SizedBox(
            height: 160,
            width: width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: randomColor,
                      child: Center(
                        child: Text(
                          widget.comment.initials,
                          style: AppFonts.x14Bold.copyWith(color: Helper.isColorDarkEnoughForWhiteText(randomColor) ? kBlackColor : kNeutralColor100),
                        ),
                      ),
                    ),
                    const SizedBox(width: Paddings.large),
                    Expanded(
                      child: ListTile(
                        title: Text(widget.comment.name, style: AppFonts.x14Bold),
                        subtitle: Text(widget.comment.country, style: AppFonts.x14Regular),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    RatingBarIndicator(
                      rating: widget.comment.rating,
                      itemBuilder: (context, index) => const Icon(Icons.star),
                      itemCount: 5,
                      itemSize: 12,
                    ),
                    const SizedBox(width: Paddings.large),
                    Text(DateFormat('yyyy-MM-dd').format(widget.comment.createdAt), style: AppFonts.x14Regular),
                  ],
                ),
                const SizedBox(height: Paddings.regular),
                OverflowedTextWithTooltip(title: widget.comment.comment ?? '', style: AppFonts.x14Regular, maxLines: 3, textAlign: TextAlign.justify),
              ],
            ),
          );
        },
      );
}
