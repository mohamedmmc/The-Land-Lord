import 'package:the_land_lord_website/models/property_filter_model.dart';
import 'package:the_land_lord_website/utils/constants/sizes.dart';
import 'package:the_land_lord_website/utils/theme/theme.dart';
import 'package:the_land_lord_website/widgets/property_card.dart';
import 'package:the_land_lord_website/views/properties/properties_controller.dart';
import 'package:the_land_lord_website/widgets/property_filter/property_filter_widget.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart' as lottie;

import '../../utils/constants/assets.dart';
import '../../utils/constants/colors.dart';
import '../../utils/constants/constants.dart';
import '../../utils/enums/property_type.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/custom_dropdown copy.dart';

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
                child: Padding(
                  padding: const EdgeInsets.only(top: 0.8),
                  child: SizedBox(
                    height: Get.height,
                    child: Row(
                      children: [
                        Flexible(
                          flex: 5,
                          child: LayoutBuilder(
                            builder: (_, constraints) => SingleChildScrollView(
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
                                      if (filter.location == null && controller.filter.location != null) controller.filter.location = null;
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
                                          : Wrap(
                                              runSpacing: 20,
                                              spacing: 30,
                                              children: [
                                                for (int index = 0; index < controller.filteredProperties.length; index++)
                                                  PropertyCard(
                                                    property: controller.filteredProperties[index],
                                                    key: Key(controller.filteredProperties[index].id.toString()),
                                                  )
                                              ],
                                            ),
                                    ),
                                    additionalFilters: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: Paddings.exceptional * 2),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            children: [
                                              Flexible(
                                                child: CustomDropDownMenu(
                                                  buttonWidth: 400,
                                                  hint: controller.filter.rooms != null ? '${controller.filter.rooms} Chambres' : 'Chambres',
                                                  items: [
                                                    'Clear',
                                                    ...[1, 2, 3, 4, 5].map((e) => e.toString())
                                                  ],
                                                  selectedItem: controller.filter.rooms,
                                                  onChanged: (value) {
                                                    if (value == 'Clear') {
                                                      controller.filter.rooms = null;
                                                      controller.updateFilter();
                                                    } else {
                                                      controller.updateFilter(rooms: int.parse(value.toString()));
                                                    }
                                                  },
                                                ),
                                              ),
                                              const SizedBox(width: 15),
                                              Flexible(
                                                child: CustomDropDownMenu(
                                                  buttonWidth: 400,
                                                  hint: controller.filter.beds != null ? '${controller.filter.beds} Lits' : 'Lits',
                                                  items: [
                                                    'Clear',
                                                    ...[1, 2, 3, 4, 5].map((e) => e.toString())
                                                  ],
                                                  selectedItem: controller.filter.beds,
                                                  onChanged: (value) {
                                                    if (value == 'Clear') {
                                                      controller.filter.beds = null;
                                                      controller.updateFilter();
                                                    } else {
                                                      controller.updateFilter(beds: int.parse(value.toString()));
                                                    }
                                                  },
                                                ),
                                              ),
                                              const SizedBox(width: 15),
                                              Flexible(
                                                child: CustomDropDownMenu(
                                                  buttonWidth: 400,
                                                  hint: controller.filter.type != null ? controller.filter.type!.value : 'Type',
                                                  selectedItem: controller.filter.type?.value,
                                                  items: ['Clear', ...PropertyType.values.map((e) => e.value).toList()],
                                                  onChanged: (value) {
                                                    if (value == 'Clear') {
                                                      controller.filter.type = null;
                                                      controller.updateFilter();
                                                    } else {
                                                      controller.updateFilter(type: PropertyType.values.singleWhere((element) => element.value == value));
                                                    }
                                                  },
                                                ),
                                              ),
                                            ],
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
                                                            extraPropertyFilters.length,
                                                            (index) => SizedBox(
                                                              height: 40,
                                                              width: 250,
                                                              child: ListTile(
                                                                title: Text(extraPropertyFilters[index]),
                                                                leading: Checkbox(
                                                                  onChanged: (value) {},
                                                                  value: false,
                                                                ),
                                                              ),
                                                            ),
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
                              options: MapOptions(
                                initialCenter: tesaLocation,
                                initialZoom: 14,
                                // interactionOptions: const InteractionOptions(flags: InteractiveFlag.rotate),
                                onTap: (_, pos) {
                                  // Helper.launchUrlHelper('https://maps.google.com/?q=${tesaLocation.latitude},${tesaLocation.longitude}');
                                },
                              ),
                              children: [
                                TileLayer(
                                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                  userAgentPackageName: 'com.example.app',
                                ),
                                MarkerLayer(
                                  markers: [
                                    Marker(
                                      point: tesaLocation,
                                      width: 80,
                                      height: 30,
                                      child: DecoratedBox(
                                        decoration: BoxDecoration(color: kNeutralColor100, borderRadius: circularRadius, border: regularBorder),
                                        child: const Padding(
                                          padding: EdgeInsets.symmetric(horizontal: Paddings.regular, vertical: Paddings.small),
                                          child: Text('280 TND', style: AppFonts.x14Bold),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )),
    );
  }
}
