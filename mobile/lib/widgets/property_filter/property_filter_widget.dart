import 'package:the_land_lord_website/models/property_filter_model.dart';
import 'package:the_land_lord_website/services/main_app_service.dart';
import 'package:the_land_lord_website/utils/constants/sizes.dart';
import 'package:the_land_lord_website/widgets/custom_buttons.dart';
import 'package:the_land_lord_website/widgets/property_filter/property_filter_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/constants/colors.dart';
import '../../utils/constants/constants.dart';
import '../../utils/enums/property_filter_steps.dart';

class PropertyFilterWidget extends StatelessWidget {
  final Widget propertiesList;
  final Widget? additionalFilters;
  final void Function()? closeOverlay;
  final BoxConstraints constraints;
  final void Function(PropertyFilterModel) updateFilter;

  const PropertyFilterWidget({
    super.key,
    required this.propertiesList,
    this.additionalFilters,
    this.closeOverlay,
    required this.constraints,
    required this.updateFilter,
  });

  @override
  Widget build(BuildContext context) {
    bool isMobile = GetPlatform.isAndroid || GetPlatform.isIOS || GetPlatform.isMobile;
    final textTheme = Theme.of(context).textTheme;
    return GetBuilder<PropertyFilterController>(
      builder: (controller) => SizedBox(
        width: constraints.maxWidth,
        child: Stack(
          children: [
            if (controller.isExpanded) Positioned.fill(child: GestureDetector(onTap: () => controller.manageFilter(isMobile, updateFilter))),
            Column(
              children: [
                Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: controller.isExpanded ? constraints.maxWidth - 200 : constraints.maxWidth - 100, minWidth: 300),
                    child: GestureDetector(
                      onTap: () => controller.manageFilter(isMobile, updateFilter),
                      child: Hero(
                        tag: 'search',
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: controller.isExpanded ? 60 : 200),
                          padding: controller.isExpanded ? null : const EdgeInsets.symmetric(horizontal: Paddings.large, vertical: Paddings.regular),
                          height: controller.isExpanded ? 80 : 61,
                          width: constraints.maxWidth,
                          decoration: BoxDecoration(
                            color: controller.isExpanded ? kNeutralLightColor : kNeutralColor100,
                            border: Border.all(color: kNeutralLightColor, width: 0.5),
                            borderRadius: circularRadius,
                            // boxShadow: [
                            //   BoxShadow(
                            //     color: kNeutralLightColor.withOpacity(0.5),
                            //     blurRadius: 1,
                            //     spreadRadius: 1,
                            //     offset: const Offset(0.0, 2.0),
                            //   ),
                            // ],
                          ),
                          child: controller.isExpanded
                              ? CompositedTransformTarget(
                                  link: controller.layerLink,
                                  child: Row(
                                    children: List.generate(
                                      PropertyFilterSteps.values.length,
                                      (index) {
                                        final step = PropertyFilterSteps.values[index];
                                        return controller.currentStep == step
                                            ? Expanded(
                                                flex: 3,
                                                child: DecoratedBox(
                                                  decoration: BoxDecoration(color: kNeutralColor100, borderRadius: circularRadius),
                                                  child: Center(
                                                    child: ListTile(
                                                      contentPadding: const EdgeInsets.symmetric(horizontal: Paddings.extraLarge),
                                                      title: Text(step.value),
                                                      titleTextStyle: textTheme.bodyMedium!
                                                          .copyWith(fontWeight: FontWeight.bold, color: controller.isExpanded ? kBlackColor : kNeutralColor100),
                                                      subtitle: controller.resolveStepSubtitle(step),
                                                      subtitleTextStyle: textTheme.bodySmall!.copyWith(color: controller.isExpanded ? kBlackColor : kNeutralColor100),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : Expanded(
                                                flex: 2,
                                                child: InkWell(
                                                  onTap: () => controller.setCurrentStep(step),
                                                  child: Center(
                                                    child: ListTile(
                                                      contentPadding: const EdgeInsets.symmetric(horizontal: Paddings.extraLarge),
                                                      title: Text(step.value),
                                                      titleTextStyle: textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
                                                      subtitle: controller.resolveStepSubtitle(step),
                                                      subtitleTextStyle: textTheme.bodySmall!,
                                                    ),
                                                  ),
                                                ),
                                              );
                                      },
                                    ).followedBy([
                                      Expanded(
                                        child: CustomButtons.icon(
                                          onPressed: () => controller.isExpanded = !controller.isExpanded,
                                          child: const Icon(Icons.search, color: kNeutralColor100),
                                        ),
                                      ),
                                    ]).toList(),
                                  ),
                                )
                              : Row(
                                  children: [
                                    const Icon(Icons.search),
                                    const SizedBox(width: 8.0),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Where to?', style: textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold)),
                                        Text(
                                          '${controller.currentSelection.location != null ? MainAppServie.find.getLocationNameById(controller.currentSelection.location!) : 'Anywhere'} • ${controller.currentSelection.getDuration ?? 'Any week'} • ${controller.currentSelection.guest.total}',
                                          style: textTheme.bodyMedium,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ),
                  ),
                ),
                if (additionalFilters != null) additionalFilters!,
                propertiesList,
              ],
            ),
            Positioned(
              child: controller.filterOverlayWidget(maxWidth: constraints.maxWidth),
            ),
          ],
        ),
      ),
    );
  }
}
