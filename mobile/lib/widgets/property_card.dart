import 'package:the_land_lord_website/services/main_app_service.dart';
import 'package:the_land_lord_website/models/property.dart';
import 'package:the_land_lord_website/utils/constants/sizes.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:the_land_lord_website/widgets/overflowed_text_with_tooltip.dart';

import '../utils/constants/colors.dart';
import '../utils/constants/constants.dart';
import '../utils/theme/theme.dart';
import 'custom_buttons.dart';

class PropertyCard extends StatelessWidget {
  final Property property;
  const PropertyCard({super.key, required this.property});

  @override
  Widget build(BuildContext context) => SizedBox(
        width: 250,
        height: 320,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 200,
              width: 250,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: regularRadius,
                    child: Swiper(
                      itemBuilder: (_, int i) => Image.network(
                        property.imagePath![i],
                        height: 200,
                        width: 250,
                        fit: BoxFit.cover,
                        errorBuilder: (_, error, stackTrace) => Image.asset("assets/images/no_image.jpg", height: 200, width: 250, fit: BoxFit.cover),
                      ),
                      itemCount: property.imagePath?.length ?? 1,
                      pagination: const SwiperPagination(),
                      control: const SwiperControl(), // TODO Customize this
                    ),
                    // Image.asset(
                    //   'assets/images/house$index.jpeg',
                    //   height: 200,
                    //   width: 250,
                    //   fit: BoxFit.cover,
                    //   errorBuilder: (_, error, stackTrace) => Image.asset("assets/images/no_image.jpg"),
                    // ),
                  ),
                  Positioned(
                    right: Paddings.regular,
                    top: Paddings.regular,
                    child: CustomButtons.icon(
                      child: Stack(
                        children: [
                          Positioned(child: Icon(Icons.favorite, color: kNeutralColor.withOpacity(0.5))),
                          const Icon(Icons.favorite_outline, color: kNeutralColor100),
                        ],
                      ),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: Paddings.regular),
            Row(
              children: [
                Flexible(flex: 5, child: OverflowedTextWithTooltip(title: property.name ?? 'NA', style: AppFonts.x15Bold, expand: false)),
                const SizedBox(width: Paddings.small),
                Flexible(
                  flex: 3,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Icon(Icons.star),
                      Text('${property.rating ?? '5'} (${property.reviews ?? 54})'),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Text(MainAppServie.find.getLocatioNameById(property.location!), maxLines: 1, overflow: TextOverflow.ellipsis),
            Row(
              children: [
                Text('${property.beds ?? 0} beds'),
                const Text(' • '),
                Text('${property.guests ?? 0} guests'),
              ],
            ),
            const SizedBox(height: 5),
            RichText(
              text: TextSpan(
                text: '',
                style: AppFonts.x14Regular,
                children: [
                  TextSpan(text: '${property.pricePerNight ?? 0} TND', style: AppFonts.x14Bold),
                  const TextSpan(text: '/night • duration_cost'),
                ],
              ),
            ),
          ],
        ),
      );
}
