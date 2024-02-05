import 'package:flutter_map/flutter_map.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart' as lottie;

import '../../helpers/helper.dart';
import '../../models/property_filter_model.dart';
import '../../utils/constants/assets.dart';
import '../../utils/constants/colors.dart';
import '../../utils/constants/constants.dart';
import '../../utils/constants/sizes.dart';
import '../../utils/theme/theme.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/custom_marker.dart';
import '../../widgets/property_card.dart';
import '../../widgets/property_filter/property_filter_widget.dart';
import 'properties_controller.dart';

class PropertiesScreen extends StatelessWidget {
  final PropertyFilterModel? filter;
  static const String routeName = '/properties';

  const PropertiesScreen({super.key, this.filter});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kNeutralColor100,
        surfaceTintColor: kNeutralColor100,
        toolbarHeight: 110,
        flexibleSpace: const CustomAppBar(),
      ),
      // TODO Use for mobile device
      // bottomNavigationBar: AppBottomNavigation(),
      body: GetBuilder<PropertiesController>(
        initState: (state) => state.controller?.filter = filter ?? PropertyFilterModel(),
        builder: (controller) => DecoratedBox(
          decoration: BoxDecoration(border: Border(top: BorderSide(color: kNeutralLightColor, width: 0.5))),
          child: Helper.isLoading.value
              ? const Center(child: CircularProgressIndicator(color: kPrimaryColor))
              : Padding(
                  padding: const EdgeInsets.only(top: 0.8),
                  child: SizedBox(
                    height: Get.height,
                    child: Row(
                      children: [
                        Flexible(
                          flex: 5,
                          child: LayoutBuilder(
                            builder: (_, constraints) => Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const SizedBox(height: Paddings.large),
                                Expanded(
                                  child: PropertyFilterWidget(
                                    scrollController: controller.scrollController,
                                    toggleExpandFilter: controller.isFilterExpanded,
                                    updateFilter: (filter) {
                                      if (filter.location == null && controller.filter?.location != null) controller.filter?.location = null;
                                      controller.updateFilter(filterModel: filter);
                                    },
                                    constraints: constraints,
                                    propertiesList: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: Paddings.extraLarge * 2, vertical: Paddings.regular),
                                      child: controller.filteredProperties.isEmpty
                                          ? SizedBox(
                                              height: Get.height * 0.5,
                                              child: Center(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(Paddings.regular),
                                                  child: lottie.Lottie.asset(Assets.noDataLottie, height: Get.height * 0.3),
                                                ),
                                              ),
                                            )
                                          : Column(
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              children: [
                                                Text('${controller.filteredProperties.length} results found', style: AppFonts.x12Regular),
                                                const SizedBox(height: Paddings.regular),
                                                Wrap(
                                                  runSpacing: 20,
                                                  spacing: 30,
                                                  children: [
                                                    for (int index = 0; index < controller.filteredProperties.length; index++)
                                                      PropertyCard(
                                                        property: controller.filteredProperties[index],
                                                        filtred: controller.filter?.checkin != null,
                                                        key: Key(controller.filteredProperties[index].id.toString()),
                                                        onTap: (){
                                                          controller.detailScreen(controller.filteredProperties[index].id ?? '');
                                                        },
                                                      )
                                                  ],
                                                ),
                                              ],
                                            ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 3,
                          child: DecoratedBox(
                            decoration: const BoxDecoration(color: Colors.lightGreen),
                            child: FlutterMap(
                              mapController: controller.mapController,
                              options: MapOptions(
                                initialCenter: controller.calculateMidPoint()?['midPoint'] ?? tesaLocation,
                                initialZoom: controller.calculateMidPoint()?['zoomLevel'] ?? 13,
                                onTap: (_, pos) {
                                  // Helper.launchUrlHelper('https://maps.google.com/?q=${tesaLocation.latitude},${tesaLocation.longitude}');
                                },
                              ),
                              children: [
                                TileLayer(urlTemplate: 'https://basemaps.cartocdn.com/rastertiles/voyager_nolabels/{z}/{x}/{y}.png'),
                                MarkerLayer(
                                  markers: List.generate(
                                    controller.filteredProperties.where((element) => element.coordinates != null).length,
                                    (index) {
                                      final property = controller.filteredProperties.where((element) => element.coordinates != null).toList()[index];
                                      return Marker(
                                        point: property.coordinates!,
                                        alignment: Alignment.center,
                                        width: 90,
                                        height: 30,
                                        child: BuildCustomMarker(property, controller.propertiesMarkerLayer[index], controller.mapController),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
