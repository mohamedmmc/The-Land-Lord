import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:the_land_lord_website/helpers/helper.dart';
import 'package:the_land_lord_website/utils/theme/theme.dart';
import 'package:the_land_lord_website/widgets/custom_text_field.dart';

import '../../../services/main_app_service.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/constants.dart';
import '../../../utils/constants/sizes.dart';
import '../../../views/properties/properties_controller.dart';
import '../../custom_dropdown.dart';

class MoreFiltersPopup extends StatelessWidget {
  final double maxWidth;
  const MoreFiltersPopup({super.key, required this.maxWidth});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PropertiesController>(
      builder: (controller) => AlertDialog(
        surfaceTintColor: Colors.transparent,
        backgroundColor: kNeutralColor100,
        content: SizedBox(
          height: Get.height * 0.7,
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
                  min: 20,
                  max: 2200,
                  activeColor: kPrimaryColor,
                  onChanged: (value) => controller.managePriceFilter(range: value),
                  values: RangeValues(controller.priceSliderMin, controller.priceSliderMax),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: maxWidth * 0.2,
                    child: CustomTextField(
                      hintText: 'Minimum',
                      fieldController: controller.minPriceController,
                      onChanged: (value) => Helper.onSearchDebounce(() => controller.managePriceFilter(min: value)),
                    ),
                  ),
                  const Text('\t\t-\t\t'),
                  SizedBox(
                    width: maxWidth * 0.2,
                    child: CustomTextField(
                      hintText: 'Maximum',
                      fieldController: controller.maxPriceController,
                      onChanged: (value) => Helper.onSearchDebounce(() => controller.managePriceFilter(max: value)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: Paddings.large),
              Divider(color: kNeutralLightColor.withAlpha(150)),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: Paddings.regular),
                child: Text('Beds and bathrooms', style: AppFonts.x18Bold),
              ),
              const Text('Beds', style: AppFonts.x14Regular),
              buildChips(list: [
                'Any',
                ...[1, 2, 3, 4, 5].map((e) => e == 5 ? '5+' : e.toString())
              ], onSelect: (p0) {}, selected: 'Any'),
              const SizedBox(height: Paddings.regular),
              const Text('Bathrooms', style: AppFonts.x14Regular),
              buildChips(list: [
                'Any',
                ...[1, 2, 3, 4, 5].map((e) => e == 5 ? '5+' : e.toString())
              ], onSelect: (p0) {}, selected: 'Any'),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: Paddings.large),
                child: SizedBox(
                  width: maxWidth - 150,
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
    );
  }

  Widget buildChips({required List<String> list, required String selected, required void Function(String) onSelect, EdgeInsets? padding}) => Padding(
        padding: padding ?? const EdgeInsets.symmetric(horizontal: Paddings.exceptional),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: list
              .map(
                (e) => InkWell(
                  onTap: () => onSelect(e),
                  child: Opacity(
                    opacity: 0.75,
                    child: DecoratedBox(
                      decoration: ShapeDecoration(
                        color: e == selected ? kBlackColor : kNeutralColor100,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(width: 0.7, color: kNeutralLightColor),
                          borderRadius: BorderRadius.circular(RadiusSize.circular),
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
              .toList(),
        ),
      );
}
