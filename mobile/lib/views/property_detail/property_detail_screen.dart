import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:the_land_lord_website/models/dto/property_detail_dto.dart';
import 'package:the_land_lord_website/services/main_app_service.dart';
import 'package:the_land_lord_website/utils/constants/sizes.dart';
import 'package:the_land_lord_website/utils/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:the_land_lord_website/utils/theme/theme.dart';
import 'package:the_land_lord_website/views/property_detail/property_detail_controller.dart';

import '../../helpers/helper.dart';
import '../../utils/constants/colors.dart';
import '../../utils/constants/constants.dart';
import '../../widgets/app_calendar.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/custom_buttons.dart';

class PropertyDetailScreen extends StatelessWidget {
  static const String routeName = '/property_detail';

  const PropertyDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kNeutralColor100,
        surfaceTintColor: kNeutralColor100,
        toolbarHeight: 80,
        leading: const SizedBox(),
        flexibleSpace: const Center(child: CustomAppBar()),
      ),
      // TODO Use for mobile device
      // bottomNavigationBar: AppBottomNavigation(),
      body: GetBuilder<PropertyDetailController>(
        builder: (controller) => DecoratedBox(
          decoration: BoxDecoration(border: Border(top: BorderSide(color: kNeutralLightColor, width: 0.5))),
          child: Helper.isLoading.value || !SharedPreferencesService.find.isReady || controller.propertyDetailDTO == null
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
                            Text(controller.propertyDetailDTO!.mappedProperties.name, style: AppFonts.x24Bold),
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
                        SizedBox(
                          height: 500,
                          width: Get.width * 0.8,
                          child: Center(
                            // TODO convert this to picture gallery with first 5 picture
                            child: Swiper(
                              itemBuilder: (_, int i) => ClipRRect(
                                borderRadius: regularRadius,
                                child: CachedNetworkImage(
                                  imageUrl: controller.propertyDetailDTO?.mappedProperties.images[i] ?? 'NA',
                                  progressIndicatorBuilder: (context, url, downloadProgress) => Center(child: CircularProgressIndicator(value: downloadProgress.progress)),
                                  errorWidget: (context, url, error) => Image.asset("assets/images/no_image.jpg", height: 200, width: 250, fit: BoxFit.cover),
                                ),
                              ),
                              itemCount: controller.propertyDetailDTO?.mappedProperties.images.length ?? 0,
                              pagination: const SwiperPagination(),
                              control: const SwiperControl(),
                            ),
                          ),
                        ),
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
                                    title: Text(controller.propertyDetailDTO!.mappedProperties.getFullAddress(), style: AppFonts.x18Bold),
                                    subtitle:
                                        Text(controller.propertyDetailDTO!.mappedProperties.getPropertySizeOverview(), style: AppFonts.x16Regular.copyWith(color: kNeutralColor)),
                                  ),
                                  const SizedBox(height: Paddings.large),
                                  const Text(
                                    'Commodo consequat elit cillum consequat exercitation enim duis tempor occaecat in esse. Est enim officia voluptate deserunt incididunt qui pariatur sint aliqua pariatur. Est minim officia proident pariatur ad proident nulla eu laboris officia anim.',
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
                                      children: [for (final amenity in controller.propertyDetailDTO!.mappedProperties.amenities) _buildAmenity(amenity)],
                                    ),
                                  ),
                                  const SizedBox(height: Paddings.large),
                                  Divider(color: kNeutralLightColor.withAlpha(150)),
                                  const SizedBox(height: Paddings.large),
                                  SizedBox(
                                    height: 400,
                                    child: FlutterMap(
                                      mapController: controller.mapController,
                                      options: MapOptions(
                                        interactionOptions: const InteractionOptions(flags: InteractiveFlag.none),
                                        initialCenter: controller.propertyDetailDTO!.mappedProperties.coordinates.toLatLng(),
                                        initialZoom: 13,
                                        onTap: (_, pos) {
                                          // Helper.launchUrlHelper('https://maps.google.com/?q=${tesaLocation.latitude},${tesaLocation.longitude}');
                                        },
                                      ),
                                      children: [
                                        // TileLayer(
                                        //   urlTemplate: 'https://snowmap.fast-sfc.com/base_snow_map/{z}/{x}/{y}.png',
                                        //   tileProvider: CancellableNetworkTileProvider(),
                                        // ),
                                        MarkerLayer(
                                          markers: [
                                            Marker(
                                              point: controller.propertyDetailDTO!.mappedProperties.coordinates.toLatLng(),
                                              alignment: Alignment.center,
                                              width: 90,
                                              height: 30,
                                              child: const Icon(Icons.place, color: kErrorColor, size: 24),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: Paddings.large),
                                  Divider(color: kNeutralLightColor.withAlpha(150)),
                                  const SizedBox(height: Paddings.exceptional * 10),
                                ],
                              ),
                            ),
                            const SizedBox(width: Paddings.large),
                            // Booking StickySide
                            Flexible(
                              child: StickyContainer(
                                scrollController: controller.scrollController,
                                child: Card(
                                  color: kNeutralColor100,
                                  surfaceTintColor: Colors.transparent,
                                  shape: OutlineInputBorder(borderRadius: regularRadius, borderSide: BorderSide(color: kNeutralLightColor, width: 0.7)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(Paddings.extraLarge),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('${controller.propertyDetailDTO?.mappedProperties.pricePerNight ?? 280} TND night', style: AppFonts.x14Bold),
                                        const SizedBox(height: Paddings.large),
                                        AppCalendar(
                                          isDoubleCalendar: false,
                                          onSelectionChanged: (p0) {},
                                          blackoutDates: controller.propertyDetailDTO!.getBlackoutDates(),
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
                                          '${controller.propertyDetailDTO?.mappedProperties.pricePerNight ?? 280} TND x ${Helper.getDurationInRange(controller.selectedDuration)} nights',
                                          '${controller.propertyDetailDTO?.mappedProperties.pricePerNight ?? 280 * Helper.getDurationInRange(controller.selectedDuration)} TND',
                                        ),
                                        _buildLabel(
                                          'Cleaning fees',
                                          '${controller.propertyDetailDTO?.mappedProperties.cleaningPrice ?? 50} TND',
                                        ),
                                        Divider(color: kNeutralLightColor.withAlpha(150)),
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
        ),
      ),
    );
  }

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

  Widget _buildAmenity(AmenityDTO amenity) => SizedBox(
        width: 150,
        child: Row(
          children: [
            const Icon(Icons.ac_unit),
            const SizedBox(width: Paddings.regular),
            Text(MainAppServie.find.getAmenityNameById(amenity.amenityId)),
          ],
        ),
      );
}

class StickyContainer extends StatefulWidget {
  final Widget child;
  final ScrollController scrollController;

  const StickyContainer({Key? key, required this.child, required this.scrollController}) : super(key: key);

  @override
  State<StickyContainer> createState() => _StickyContainerState();
}

class _StickyContainerState extends State<StickyContainer> {
  bool isSticky = false;
  double initialOffset = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(_getInitialOffset);
    widget.scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  void _getInitialOffset(Duration _) {
    final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      initialOffset = renderBox.localToGlobal(Offset.zero).dy - 100; // AppBar height size
    }
  }

  void _scrollListener() {
    final currentOffset = widget.scrollController.offset;
    setState(() => isSticky = currentOffset > initialOffset);
    // if (currentOffset > initialOffset && !isSticky) {
    //   setState(() => isSticky = true);
    // } else if (currentOffset <= initialOffset && isSticky) {
    //   setState(() => isSticky = false);
    // }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.linear,
      margin: EdgeInsets.only(top: isSticky ? widget.scrollController.offset - initialOffset : 0),
      child: widget.child,
    );
  }
}
