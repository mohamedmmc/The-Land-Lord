import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:the_land_lord_website/helpers/buildables.dart';
import 'package:the_land_lord_website/models/dto/property_detail_dto.dart';
import 'package:the_land_lord_website/services/main_app_service.dart';
import 'package:the_land_lord_website/utils/constants/sizes.dart';
import 'package:the_land_lord_website/services/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:the_land_lord_website/services/theme/theme.dart';
import 'package:the_land_lord_website/views/property_detail/components/all_photos_screen.dart';
import 'package:the_land_lord_website/views/property_detail/property_detail_controller.dart';

import '../../helpers/helper.dart';
import '../../utils/constants/amenities_icon.dart';
import '../../utils/constants/colors.dart';
import '../../utils/constants/constants.dart';
import '../../widgets/app_calendar.dart';
import '../../widgets/custom_buttons.dart';
import 'components/comment_card.dart';
import 'components/gallery_pictures.dart';
import 'components/sticky_container.dart';

class PropertyDetailScreen extends StatelessWidget {
  static const String routeName = '/property_detail';

  const PropertyDetailScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: Buildables.customAppBar(),
        // TODO Use for mobile device
        // bottomNavigationBar: AppBottomNavigation(),
        body: GetBuilder<PropertyDetailController>(
          builder: (controller) {
            return DecoratedBox(
              decoration: BoxDecoration(border: Border(top: BorderSide(color: kNeutralLightColor, width: 0.5))),
              child: Helper.isLoading.value || !SharedPreferencesService.find.isReady || controller.propertyDetailsDTO == null
                  ? const Center(child: CircularProgressIndicator(color: kPrimaryColor))
                  : SingleChildScrollView(
                      controller: controller.scrollController,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: Get.width * 0.1, vertical: Paddings.extraLarge),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(controller.propertyDetailsDTO!.mappedProperties!.name, style: AppFonts.x24Bold),
                                const Spacer(),
                                CustomButtons.icon(
                                  child: Stack(
                                    children: [
                                      Positioned(child: Icon(Icons.favorite, color: kNeutralColor.withOpacity(0.1))),
                                      Row(
                                        children: [
                                          const Icon(Icons.favorite_outline, color: kNeutralColor),
                                          Padding(
                                            padding: const EdgeInsets.only(bottom: 2, left: Paddings.small),
                                            child: Text('Save', style: AppFonts.x14Regular.copyWith(height: 1.5, decoration: TextDecoration.underline)),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  onPressed: () {
                                    // TODO add favorite logic
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: Paddings.exceptional),
                            LayoutBuilder(builder: (context, constraints) {
                              controller.galleryAdditionalHeight = constraints.maxWidth > 1135.0 ? (constraints.maxWidth - 1135.8) * 0.33 : 0;
                              return SizedBox(
                                width: constraints.maxWidth,
                                height: 380 + controller.galleryAdditionalHeight,
                                child: GalleryPictures(
                                  controller.propertyDetailsDTO!.mappedProperties!.images.map((e) => e.thumbnail.isEmpty ? e.url : e.thumbnail).toList(),
                                  width: constraints.maxWidth,
                                  additionalHeight: controller.galleryAdditionalHeight,
                                  onSeeAllPhotos: () => Get.toNamed(AllPhotoScreen.routeName, arguments: {'images': controller.propertyDetailsDTO!.mappedProperties!.images}),
                                ),
                              );
                            }),
                            const SizedBox(height: Paddings.exceptional),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Property Details
                                Flexible(
                                  flex: 3,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      ListTile(
                                        contentPadding: EdgeInsets.zero,
                                        title: Text(
                                            '${MainAppServie.find.getTypeNameById(int.parse(controller.propertyDetailsDTO!.mappedProperties!.typePropertyId))} in ${controller.propertyDetailsDTO!.mappedProperties!.getFullAddress()}',
                                            style: AppFonts.x18Bold),
                                        subtitle: Text(controller.propertyDetailsDTO!.mappedProperties!.getPropertySizeOverview(),
                                            style: AppFonts.x16Regular.copyWith(color: kNeutralColor)),
                                      ),
                                      const SizedBox(height: Paddings.large),
                                      Text(
                                        controller.propertyDetailsDTO!.mappedProperties!.description.first.text,
                                        style: AppFonts.x16Regular,
                                        textAlign: TextAlign.justify,
                                      ),
                                      const SizedBox(height: Paddings.exceptional),
                                      const Text('What this place offers', style: AppFonts.x18Bold),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(vertical: Paddings.large),
                                        child: Wrap(
                                          spacing: 10,
                                          runSpacing: 10,
                                          children: [for (final amenity in controller.propertyDetailsDTO!.mappedProperties!.amenity) _buildAmenity(amenity)],
                                        ),
                                      ),
                                      Buildables.lightDivider(),
                                      const Text('Where you\'ll be', style: AppFonts.x18Bold),
                                      const SizedBox(height: Paddings.large),
                                      SizedBox(
                                        height: 400,
                                        child: FlutterMap(
                                          mapController: controller.mapController,
                                          options: MapOptions(
                                            initialCenter: controller.propertyCoordinates!,
                                            initialZoom: 14,
                                          ),
                                          children: [
                                            Buildables.mapTileLayer(),
                                            MarkerLayer(
                                              markers: [
                                                Marker(
                                                  point: controller.propertyCoordinates!,
                                                  alignment: Alignment.center,
                                                  width: 90,
                                                  height: 30,
                                                  child: const Icon(Icons.place, color: kErrorColor, size: 24),
                                                )
                                              ],
                                            ),
                                            Stack(
                                              children: [
                                                Positioned(
                                                  bottom: 40,
                                                  right: 10,
                                                  child: CustomButtons.iconWithBackground(
                                                    width: 35,
                                                    height: 35,
                                                    padding: const EdgeInsets.all(Paddings.small),
                                                    buttonColor: kNeutralColor100.withOpacity(0.8),
                                                    icon: const Icon(Icons.filter_center_focus_outlined),
                                                    onPressed: () => controller.mapController.move(controller.propertyCoordinates!, 14),
                                                  ),
                                                ),
                                                Positioned(
                                                  bottom: 10,
                                                  right: 10,
                                                  child: CustomButtons.iconWithBackground(
                                                    width: 35,
                                                    height: 35,
                                                    padding: const EdgeInsets.all(Paddings.small),
                                                    buttonColor: kNeutralColor100.withOpacity(0.8),
                                                    icon: const Icon(Icons.directions),
                                                    onPressed: () => Helper.launchUrlHelper(
                                                        'https://maps.google.com/?q=${controller.propertyCoordinates!.latitude},${controller.propertyCoordinates!.longitude}'),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Buildables.lightDivider(),
                                      const Padding(
                                        padding: EdgeInsets.only(bottom: Paddings.regular),
                                        child: Text('Things to know', style: AppFonts.x18Bold),
                                      ),
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                const Text('House rules', style: AppFonts.x16Bold),
                                                _buildLabelIcon(
                                                  Icons.access_time_outlined,
                                                  'Check-in: ${controller.propertyDetailsDTO!.mappedProperties!.checkInOut.checkInFrom.join(', ')} - ${controller.propertyDetailsDTO!.mappedProperties!.checkInOut.checkInTo.join(', ')}',
                                                ),
                                                _buildLabelIcon(
                                                  Icons.access_time_outlined,
                                                  'Check-out: ${controller.propertyDetailsDTO!.mappedProperties!.checkInOut.checkOutUntil.join(', ')}',
                                                ),
                                                _buildLabelIcon(
                                                  Icons.place_outlined,
                                                  'Checking Place: ${controller.propertyDetailsDTO!.mappedProperties!.checkInOut.place.join(', ')}',
                                                ),
                                                _buildLabelIcon(
                                                  Icons.groups_outlined,
                                                  'Max Guest: ${controller.propertyDetailsDTO!.mappedProperties!.canSleepMax}',
                                                ),
                                                _buildLabelIcon(
                                                  controller.propertyDetailsDTO!.mappedProperties!.petsAllowed ? Icons.pets_outlined : Icons.do_not_disturb_outlined,
                                                  'Pets: ${controller.propertyDetailsDTO!.mappedProperties!.petsAllowed ? 'allowed' : 'not allowed'}',
                                                ),
                                                _buildLabelIcon(
                                                  controller.propertyDetailsDTO!.mappedProperties!.smokingAllowed ? Icons.smoking_rooms_outlined : Icons.smoke_free_outlined,
                                                  'Smoking: ${controller.propertyDetailsDTO!.mappedProperties!.smokingAllowed ? 'allowed' : 'not allowed'}',
                                                ),
                                                const Text('', style: AppFonts.x14Regular),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                const Text('Cancellation policy', style: AppFonts.x16Bold),
                                                Text(
                                                  controller.propertyDetailsDTO!.mappedProperties!.cancellationPolicies
                                                      .map((e) => '${e.validFrom} - ${e.validTo} -> ${e.value}')
                                                      .join('\n'),
                                                  style: AppFonts.x14Regular,
                                                ),
                                                const SizedBox(height: Paddings.large),
                                                const Text('Deposit policy', style: AppFonts.x16Bold),
                                                Text(
                                                  controller.propertyDetailsDTO!.mappedProperties!.deposit.first.name,
                                                  style: AppFonts.x14Regular,
                                                ),
                                                const SizedBox(height: Paddings.large),
                                                const Text('Accepted paiment', style: AppFonts.x16Bold),
                                                Text(
                                                  controller.propertyDetailsDTO!.mappedProperties!.paiement.map((e) => e.name).join(', '),
                                                  style: AppFonts.x14Regular,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      Buildables.lightDivider(),
                                      DecoratedBox(
                                        decoration: BoxDecoration(borderRadius: regularRadius, border: lightBorder),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: Paddings.large, vertical: Paddings.regular),
                                          child: Row(
                                            children: [
                                              const Text('Guests Reviews', style: AppFonts.x16Bold),
                                              const Spacer(),
                                              Column(
                                                children: [
                                                  Text(controller.propertyDetailsDTO!.mappedProperties!.rating.toStringAsFixed(2), style: AppFonts.x14Bold),
                                                  RatingBarIndicator(
                                                    rating: controller.propertyDetailsDTO!.mappedProperties!.rating,
                                                    itemBuilder: (context, index) => const Icon(Icons.star),
                                                    itemCount: 5,
                                                    itemSize: 12,
                                                  ),
                                                ],
                                              ),
                                              Buildables.lightVerticalDivider(),
                                              Column(
                                                children: [
                                                  Text(controller.propertyDetailsDTO!.mappedProperties!.reviewers.toString(), style: AppFonts.x14Bold),
                                                  Text('Reviews', style: AppFonts.x14Bold.copyWith(decoration: TextDecoration.underline, height: 1.5)),
                                                ],
                                              ),
                                              Buildables.lightVerticalDivider(),
                                              SizedBox(
                                                height: 100,
                                                width: 200,
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text('Overall rating', style: AppFonts.x14Bold.copyWith(height: 1)),
                                                    const Expanded(
                                                      child: ListTile(
                                                        dense: true,
                                                        contentPadding: EdgeInsets.zero,
                                                        minVerticalPadding: 0,
                                                        leading: Text('5', style: AppFonts.x12Regular),
                                                        title: LinearProgressIndicator(value: 0),
                                                      ),
                                                    ),
                                                    const Expanded(
                                                      child: ListTile(
                                                        dense: true,
                                                        contentPadding: EdgeInsets.zero,
                                                        minVerticalPadding: 0,
                                                        leading: Text('4', style: AppFonts.x12Regular),
                                                        title: LinearProgressIndicator(value: 0),
                                                      ),
                                                    ),
                                                    const Expanded(
                                                      child: ListTile(
                                                        dense: true,
                                                        contentPadding: EdgeInsets.zero,
                                                        minVerticalPadding: 0,
                                                        leading: Text('3', style: AppFonts.x12Regular),
                                                        title: LinearProgressIndicator(value: 0),
                                                      ),
                                                    ),
                                                    const Expanded(
                                                      child: ListTile(
                                                        dense: true,
                                                        contentPadding: EdgeInsets.zero,
                                                        minVerticalPadding: 0,
                                                        leading: Text('2', style: AppFonts.x12Regular),
                                                        title: LinearProgressIndicator(value: 0),
                                                      ),
                                                    ),
                                                    const Expanded(
                                                      child: ListTile(
                                                        dense: true,
                                                        contentPadding: EdgeInsets.zero,
                                                        minVerticalPadding: 0,
                                                        leading: Text('1', style: AppFonts.x12Regular),
                                                        title: LinearProgressIndicator(value: 0),
                                                      ),
                                                    ),
                                                    const SizedBox(height: Paddings.regular),
                                                  ],
                                                ),
                                              ),
                                              const Spacer(),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: Paddings.large),
                                      Wrap(
                                        spacing: Paddings.exceptional,
                                        runSpacing: Paddings.large,
                                        children: PropertyDetailController.dummyComments.map((item) => CommentCard(comment: item)).toList(),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: Paddings.large),
                                // Booking StickySide
                                Flexible(
                                  child: StickyContainer(
                                    scrollController: controller.scrollController,
                                    galleryAdditionalHeight: controller.galleryAdditionalHeight,
                                    child: Card(
                                      color: kNeutralColor100,
                                      surfaceTintColor: Colors.transparent,
                                      shape: OutlineInputBorder(borderRadius: regularRadius, borderSide: BorderSide(color: kNeutralLightColor, width: 0.7)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(Paddings.extraLarge),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('${controller.estimatedPrice ?? 280} TND night', style: AppFonts.x14Bold),
                                            const SizedBox(height: Paddings.large),
                                            AppCalendar(
                                              isDoubleCalendar: false,
                                              blackoutDates: controller.propertyDetailsDTO!.getBlackoutDates(),
                                              onSelectionChanged: (range) => range.value.endDate != null && range.value.startDate != null
                                                  ? controller.selectedDuration = DateTimeRange(start: range.value.startDate, end: range.value.endDate)
                                                  : {},
                                            ).animate(delay: const Duration(milliseconds: 300)).fadeIn(duration: const Duration(milliseconds: 300)),
                                            CustomButtons.elevatePrimary(
                                              onPressed: () {},
                                              title: 'Reserve',
                                              width: double.infinity,
                                            ),
                                            const SizedBox(height: Paddings.small),
                                            const Align(alignment: Alignment.center, child: Text('You won\'t be charged yet', style: AppFonts.x12Regular)),
                                            const SizedBox(height: Paddings.regular),
                                            _buildLabel(
                                              '${controller.estimatedPrice ?? 280} TND x ${Helper.getDurationInRange(controller.selectedDuration)} nights',
                                              '${controller.estimatedPrice ?? 280 * Helper.getDurationInRange(controller.selectedDuration)} TND',
                                            ),
                                            _buildLabel(
                                              'Cleaning fees',
                                              '${controller.propertyDetailsDTO!.mappedProperties!.cleaningPrice} TND',
                                            ),
                                            Buildables.lightDivider(padding: EdgeInsets.zero),
                                            _buildLabel(
                                              isBold: true,
                                              'Total',
                                              '${controller.getTotalPrice()} TND',
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
            );
          },
        ),
      );

  Widget _buildLabel(String label, String value, {bool isBold = false}) => Padding(
        padding: const EdgeInsets.symmetric(vertical: Paddings.small),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: AppFonts.x14Regular.copyWith(fontWeight: isBold ? FontWeight.bold : null)),
            Text(value, style: AppFonts.x14Regular.copyWith(fontWeight: isBold ? FontWeight.bold : null)),
          ],
        ),
      );

  Widget _buildLabelIcon(IconData icon, String value) => Padding(
      padding: const EdgeInsets.symmetric(vertical: Paddings.small),
      child: Row(
        children: [
          Icon(icon, size: 14, color: kNeutralColor),
          const SizedBox(width: Paddings.large),
          Text(value, style: AppFonts.x14Regular),
        ],
      ));

  Widget _buildAmenity(Amenity amenity) {
    IconData getIconForAmenity(String amenityName) {
      if (amenitiesIconMap[amenityName] != null) return amenitiesIconMap[amenityName]!;
      debugPrint('$amenityName\n');
      return Icons.help_outline;
    }

    return SizedBox(
      width: 275,
      child: Row(
        children: [
          Icon(getIconForAmenity(amenity.name)),
          const SizedBox(width: Paddings.regular),
          Expanded(child: Text(amenity.name, softWrap: true)),
        ],
      ),
    );
  }
}
