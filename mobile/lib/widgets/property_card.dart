import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:the_land_lord_website/helpers/helper.dart';
import 'package:the_land_lord_website/views/property_detail/properties_screen.dart';

import '../models/property.dart';
import '../services/main_app_service.dart';
import '../utils/constants/colors.dart';
import '../utils/constants/constants.dart';
import '../utils/constants/sizes.dart';
import '../utils/shared_preferences.dart';
import '../utils/theme/theme.dart';
import 'custom_buttons.dart';
import 'overflowed_text_with_tooltip.dart';

class PropertyCard extends StatelessWidget {
  final Property property;
  final double? width;
  final double? height;
  final bool filtred;
  final VoidCallback? onTap;
  const PropertyCard({super.key, required this.property, this.width, this.height, this.filtred = false, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        width: width ?? 250,
        height: height ?? 320,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: height != null ? height! - 120 : 200,
              width: width ?? 250,
              child: Stack(
                children: [
                  property.imagePath != null && property.imagePath!.isNotEmpty
                      ? Swiper(
                          itemBuilder: (_, int i) => ClipRRect(
                            borderRadius: regularRadius,
                            child: Image.network(
                              property.imagePath![i],
                              height: height != null ? height! - 120 : 200,
                              width: width ?? 250,
                              fit: BoxFit.cover,
                              errorBuilder: (_, error, stackTrace) => ClipRRect(
                                borderRadius: regularRadius,
                                child: Image.asset(
                                  "assets/images/no_image.jpg",
                                  height: height != null ? height! - 120 : 200,
                                  width: width ?? 250,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          itemCount: property.imagePath?.length ?? 1,
                          pagination: const SwiperPagination(),
                          control: const SwiperControl(), // TODO Customize this
                        )
                      : ClipRRect(
                          borderRadius: regularRadius,
                          child: Image.asset(
                            "assets/images/no_image.jpg",
                            height: height != null ? height! - 120 : 200,
                            width: width ?? 250,
                            fit: BoxFit.cover,
                          ),
                        ),
                  Positioned(
                    right: Paddings.regular,
                    top: Paddings.small,
                    child: CustomButtons.icon(
                      child: Stack(
                        children: [
                          Positioned(child: Icon(Icons.favorite, color: kNeutralColor.withOpacity(0.5))),
                          const Icon(Icons.favorite_outline, color: kNeutralColor100),
                        ],
                      ),
                      onPressed: () {
                        // TODO add favorite logic
                      },
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
                      Text('${property.rating ?? 5} (${property.reviews ?? 54})'),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Text(MainAppServie.find.getLocationNameById(property.location!), maxLines: 1, overflow: TextOverflow.ellipsis),
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
                  if (!filtred) const TextSpan(text: 'From  '),
                  TextSpan(text: '${property.pricePerNight?.toStringAsFixed(1) ?? 0} TND', style: AppFonts.x14Bold),
                  const TextSpan(text: '/night'),
                  if (filtred) const TextSpan(text: ' • duration_cost'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
