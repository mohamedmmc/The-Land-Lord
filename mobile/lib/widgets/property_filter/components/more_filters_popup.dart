import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:the_land_lord_website/helpers/helper.dart';
import 'package:the_land_lord_website/services/theme/theme.dart';
import 'package:the_land_lord_website/widgets/custom_buttons.dart';
import 'package:the_land_lord_website/widgets/custom_text_field.dart';
import 'package:the_land_lord_website/widgets/property_filter/property_filter_controller.dart';

import '../../../helpers/buildables.dart';
import '../../../services/main_app_service.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/constants.dart';
import '../../../utils/constants/sizes.dart';

class MoreFiltersPopup extends StatelessWidget {
  final double maxWidth;
  const MoreFiltersPopup({super.key, required this.maxWidth});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PropertyFilterController>(
      builder: (controller) => Material(
        surfaceTintColor: Colors.transparent,
        borderRadius: regularRadius,
        color: Colors.transparent,
        // backgroundColor: kNeutralColor100,
        child: SizedBox(
          width: Get.width,
          height: Get.height,
          child: Center(
            child: DecoratedBox(
              decoration: BoxDecoration(color: kNeutralColor100, borderRadius: regularRadius),
              child: SizedBox(
                height: Get.height * 0.9,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    DecoratedBox(
                      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: kNeutralLightColor))),
                      child: Padding(
                        padding: const EdgeInsets.all(Paddings.large),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomButtons.icon(onPressed: Get.back, icon: const Icon(Icons.close)),
                            const Text('Filters', style: AppFonts.x15Bold),
                            const SizedBox(width: 50),
                          ],
                        ),
                      ),
                    ),
                    // Filters
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.only(right: Paddings.regular),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: Paddings.large),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: Paddings.regular),
                                child: Text('Price range', style: AppFonts.x18Bold),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: Paddings.extraLarge),
                                child: RangeSlider(
                                  min: minPriceRange,
                                  max: maxPriceRange,
                                  activeColor: kPrimaryColor,
                                  onChanged: (value) => controller.managePriceFilter(range: value),
                                  values: RangeValues(controller.filter!.priceMin, controller.filter!.priceMax),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  SizedBox(
                                    width: maxWidth * 0.2,
                                    child: CustomTextField(
                                      hintText: 'Minimum',
                                      enableFloatingLabel: true,
                                      fieldController: controller.minPriceController,
                                      suffixIcon: const Padding(
                                        padding: EdgeInsets.symmetric(vertical: Paddings.large),
                                        child: Text('TND', style: AppFonts.x15Bold),
                                      ),
                                      onChanged: (value) => Helper.onSearchDebounce(() => controller.managePriceFilter(min: value)),
                                    ),
                                  ),
                                  Container(
                                    height: 1,
                                    width: 20,
                                    color: kNeutralColor,
                                    margin: const EdgeInsets.symmetric(vertical: 25),
                                  ),
                                  SizedBox(
                                    width: maxWidth * 0.2,
                                    child: CustomTextField(
                                      hintText: 'Maximum',
                                      enableFloatingLabel: true,
                                      fieldController: controller.maxPriceController,
                                      suffixIcon: const Padding(
                                        padding: EdgeInsets.symmetric(vertical: Paddings.large),
                                        child: Text('TND', style: AppFonts.x15Bold),
                                      ),
                                      onChanged: (value) => Helper.onSearchDebounce(() => controller.managePriceFilter(max: value)),
                                    ),
                                  ),
                                ],
                              ),
                              Buildables.lightDivider(),
                              const Padding(
                                padding: EdgeInsets.only(bottom: Paddings.regular),
                                child: Text('Beds and bathrooms', style: AppFonts.x18Bold),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: Paddings.small),
                                child: Text('Beds', style: AppFonts.x14Regular),
                              ),
                              buildChips(
                                list: [
                                  'Any',
                                  ...[1, 2, 3, 4, 5].map((e) => e == 5 ? '5+' : e.toString())
                                ],
                                onSelect: (value) {
                                  if (value.toString().contains('+')) value = value.toString().substring(0, 1);
                                  if (value == 'Any') controller.filter?.beds = null;
                                  controller.updateFilterModel(beds: value == 'Any' ? null : int.parse(value.toString()));
                                },
                                selected: controller.filter?.beds == 5 ? '5+' : controller.filter?.beds?.toString() ?? 'Any',
                              ),
                              const SizedBox(height: Paddings.regular),
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: Paddings.small),
                                child: Text('Bathrooms', style: AppFonts.x14Regular),
                              ),
                              buildChips(
                                list: [
                                  'Any',
                                  ...[1, 2, 3, 4, 5].map((e) => e == 5 ? '5+' : e.toString())
                                ],
                                onSelect: (value) {
                                  if (value.toString().contains('+')) value = value.toString().substring(0, 1);
                                  if (value == 'Any') controller.filter?.bathrooms = null;
                                  controller.updateFilterModel(bathrooms: value == 'Any' ? null : int.parse(value.toString()));
                                },
                                selected: controller.filter?.bathrooms == 5 ? '5+' : controller.filter?.bathrooms?.toString() ?? 'Any',
                              ),
                              Buildables.lightDivider(),
                              const Padding(
                                padding: EdgeInsets.only(bottom: Paddings.large),
                                child: Text('Property type', style: AppFonts.x18Bold),
                              ),
                              buildChips(
                                isWrap: true,
                                list: ['Any', ...MainAppServie.find.filterData?.propertyTypelist.map((e) => e.name).toList() ?? []],
                                selected: controller.filter?.type != null ? MainAppServie.find.getTypeNameById(controller.filter!.type!) : 'Any',
                                onSelect: (value) {
                                  if (value == 'Any') controller.filter?.type = null;
                                  controller.updateFilterModel(type: value == 'Any' ? null : MainAppServie.find.getTypeIdByName(value.toString()));
                                },
                              ),
                              Buildables.lightDivider(),
                              const Padding(
                                padding: EdgeInsets.only(bottom: Paddings.regular),
                                child: Text('Amenities', style: AppFonts.x18Bold),
                              ),
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
                                            onChanged: (value) => controller.updateFilterModel(amenity: {'amenity': amenity, 'value': value}),
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
                    // Footer
                    DecoratedBox(
                      decoration: BoxDecoration(border: Border(top: BorderSide(color: kNeutralLightColor))),
                      child: Padding(
                        padding: const EdgeInsets.all(Paddings.large),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomButtons.text(onPressed: () => controller.resetFilterForm(), title: 'Clear All'),
                            CustomButtons.elevatePrimary(
                              title: 'Show Results',
                              onPressed: () {
                                controller.updateFilter!(controller.filter!);
                                Get.back();
                              },
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
      ),
    );
  }

  Widget buildChips({required List<String> list, required String selected, required void Function(String) onSelect, EdgeInsets? padding, bool isWrap = false}) {
    final chipsList = list
        .map(
          (e) => InkWell(
            borderRadius: circularRadius,
            onTap: () => onSelect(e),
            child: Opacity(
              opacity: 0.75,
              child: DecoratedBox(
                decoration: ShapeDecoration(
                  color: e == selected ? kBlackColor : kNeutralColor100,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(width: 0.7, color: kNeutralLightColor),
                    borderRadius: circularRadius,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Paddings.extraLarge, vertical: Paddings.regular),
                  child: Text(e, style: AppFonts.x14Bold.copyWith(color: e == selected ? kNeutralColor100 : kBlackColor, height: 1)),
                ),
              ),
            ),
          ),
        )
        .toList();
    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: Paddings.exceptional),
      child: isWrap
          ? Wrap(
              spacing: 10,
              runSpacing: 10,
              children: chipsList,
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: chipsList,
            ),
    );
  }
}
