import 'package:the_land_lord_website/models/property_filter_model.dart';
import 'package:the_land_lord_website/services/main_app_service.dart';
import 'package:the_land_lord_website/utils/constants/sizes.dart';
import 'package:the_land_lord_website/utils/theme/theme.dart';
import 'package:the_land_lord_website/widgets/property_card.dart';
import 'package:the_land_lord_website/views/properties/properties_controller.dart';
import 'package:the_land_lord_website/widgets/property_filter/property_filter_widget.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart' as lottie;

import '../../helpers/helper.dart';
import '../../utils/constants/assets.dart';
import '../../utils/constants/colors.dart';
import '../../utils/constants/constants.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/custom_dropdown.dart';
import '../../widgets/custom_marker.dart';

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
                            builder: (_, constraints) => SingleChildScrollView(
                              controller: controller.scrollController,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 15.0),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: Paddings.exceptional).copyWith(bottom: Paddings.extraLarge),
                                    child: const Text(
                                      "Découvrez notre sélection pour vos vacances",
                                      style: TextStyle(
                                        fontSize: 26.0,
                                        height: 1.5,
                                        color: Color.fromRGBO(33, 45, 82, 1),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  PropertyFilterWidget(
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
                                    additionalFilters: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: Paddings.exceptional * 2.5),
                                      child: Column(
                                        children: [
                                          ConstrainedBox(
                                            constraints: const BoxConstraints(maxHeight: 71),
                                            child: SizedBox(
                                              height: 71,
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: CustomDropDownMenu(
                                                      buttonHeight: 50,
                                                      maxWidth: true,
                                                      hint: controller.filter?.rooms != null ? '${controller.filter?.rooms} Chambres' : 'Chambres',
                                                      items: [
                                                        'Clear',
                                                        ...[1, 2, 3, 4, 5].map((e) => e == 5 ? '5+' : e.toString())
                                                      ],
                                                      selectedItem: controller.filter?.rooms,
                                                      onChanged: (value) {
                                                        if (value == 'Clear') {
                                                          controller.filter?.rooms = null;
                                                          controller.updateFilter();
                                                        } else {
                                                          if (value.toString().contains('+')) value = value.toString().substring(0, 1);
                                                          controller.updateFilter(rooms: int.parse(value.toString()));
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                  const SizedBox(width: 15),
                                                  Expanded(
                                                    child: CustomDropDownMenu(
                                                      maxWidth: true,
                                                      buttonHeight: 50,
                                                      hint: controller.filter?.beds != null ? '${controller.filter?.beds} Lits' : 'Lits',
                                                      items: [
                                                        'Clear',
                                                        ...[1, 2, 3, 4, 5].map((e) => e == 5 ? '5+' : e.toString())
                                                      ],
                                                      selectedItem: controller.filter?.beds,
                                                      onChanged: (value) {
                                                        if (value == 'Clear') {
                                                          controller.filter?.beds = null;
                                                          controller.updateFilter();
                                                        } else {
                                                          if (value.toString().contains('+')) value = value.toString().substring(0, 1);
                                                          controller.updateFilter(beds: int.parse(value.toString()));
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                  const SizedBox(width: 15),
                                                  Expanded(
                                                    child: CustomDropDownMenu(
                                                      maxWidth: true,
                                                      buttonHeight: 50,
                                                      hint: controller.filter?.type != null ? MainAppServie.find.getTypeNameById(controller.filter!.type!) : 'Type',
                                                      selectedItem: controller.filter?.type != null ? MainAppServie.find.getTypeNameById(controller.filter!.type!) : null,
                                                      items: ['Clear', ...MainAppServie.find.filterData?.propertyTypelist.map((e) => e.name).toList() ?? []],
                                                      onChanged: (value) {
                                                        if (value == 'Clear') {
                                                          controller.filter?.type = null;
                                                          controller.updateFilter();
                                                        } else {
                                                          controller.updateFilter(type: MainAppServie.find.getTypeIdByName(value.toString()));
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(vertical: Paddings.large),
                                            child: SizedBox(
                                              width: constraints.maxWidth - 150,
                                              child: DecoratedBox(
                                                decoration: BoxDecoration(color: kNeutralColor100, borderRadius: smallRadius, border: lightBorder),
                                                child: Theme(
                                                  data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                                                  child: ExpansionTile(
                                                    title: const Text('More extra filters'),
                                                    children: [
                                                      Padding(
                                                        padding: const EdgeInsets.symmetric(vertical: Paddings.regular),
                                                        child: Wrap(
                                                          runSpacing: 15,
                                                          spacing: 10,
                                                          children: List.generate(
                                                            MainAppServie.find.filterData?.listAmenities.length ?? 0,
                                                            (index) {
                                                              var amenity = MainAppServie.find.filterData!.listAmenities[index];
                                                              return SizedBox(
                                                                height: 40,
                                                                width: 250,
                                                                child: ListTile(
                                                                  title: Text(amenity.name),
                                                                  leading: Checkbox(
                                                                    onChanged: (value) => controller.updateFilter(amenity: {'amenity': amenity, 'value': value}),
                                                                    value: controller.filter?.amenities.any((element) => element.id == amenity.id) ?? false,
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
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
