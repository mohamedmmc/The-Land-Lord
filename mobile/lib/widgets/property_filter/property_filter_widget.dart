import 'package:lottie/lottie.dart';
import 'package:the_land_lord_website/helpers/helper.dart';
import 'package:the_land_lord_website/models/property_filter_model.dart';
import 'package:the_land_lord_website/services/main_app_service.dart';
import 'package:the_land_lord_website/utils/constants/sizes.dart';
import 'package:the_land_lord_website/widgets/custom_buttons.dart';
import 'package:the_land_lord_website/widgets/on_hover.dart';
import 'package:the_land_lord_website/widgets/property_filter/components/more_filters_popup.dart';
import 'package:the_land_lord_website/widgets/property_filter/property_filter_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/constants/assets.dart';
import '../../utils/constants/colors.dart';
import '../../utils/constants/constants.dart';
import '../../utils/enums/property_filter_steps.dart';

class PropertyFilterWidget extends StatelessWidget {
  final Widget propertiesList;
  final void Function()? closeOverlay;
  final BoxConstraints constraints;
  final void Function(PropertyFilterModel) updateFilter;
  final bool? toggleExpandFilter;
  final ScrollController scrollController;

  const PropertyFilterWidget({
    super.key,
    required this.propertiesList,
    required this.scrollController,
    this.toggleExpandFilter,
    this.closeOverlay,
    required this.constraints,
    required this.updateFilter,
  });

  @override
  Widget build(BuildContext context) {
    bool isMobile = GetPlatform.isAndroid || GetPlatform.isIOS || GetPlatform.isMobile;
    final textTheme = Theme.of(context).textTheme;
    return GetBuilder<PropertyFilterController>(
      didChangeDependencies: (state) => state.controller?.updateFilter ??= updateFilter,
      didUpdateWidget: (oldWidget, state) => WidgetsBinding.instance.addPostFrameCallback((timeStamp) => state.controller?.isExpanded = !(toggleExpandFilter ?? false)),
      builder: (controller) => SizedBox(
        width: constraints.maxWidth,
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: controller.isExpanded ? constraints.maxWidth - 150 : constraints.maxWidth - 100, minWidth: 300),
                      child: GestureDetector(
                        onTap: () => controller.manageFilter(isMobile),
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: controller.isExpanded ? 60 : 150),
                          padding: controller.isExpanded ? null : const EdgeInsets.symmetric(horizontal: Paddings.large, vertical: Paddings.regular),
                          height: controller.isExpanded ? 65 : 61,
                          width: constraints.maxWidth,
                          decoration: BoxDecoration(
                            color: kNeutralColor100,
                            border: lightBorder,
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
                                        return controller.currentStep == step && controller.isDropdownOpen
                                            ? Expanded(
                                                flex: 3,
                                                child: DecoratedBox(
                                                  decoration: BoxDecoration(color: kNeutralLightColor, borderRadius: circularRadius),
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                        flex: 4,
                                                        child: Center(
                                                          child: ListTile(
                                                            contentPadding: const EdgeInsets.only(left: Paddings.exceptional),
                                                            title: Text(step.value),
                                                            titleTextStyle: textTheme.bodyMedium!
                                                                .copyWith(fontWeight: FontWeight.bold, color: controller.isExpanded ? kBlackColor : kNeutralColor100),
                                                            subtitle: controller.resolveStepSubtitle(step),
                                                            subtitleTextStyle: textTheme.bodySmall!.copyWith(color: controller.isExpanded ? kBlackColor : kNeutralColor100),
                                                            trailing: controller.resolveClearFilterTrailing(step),
                                                          ),
                                                        ),
                                                      ),
                                                      if (index == PropertyFilterSteps.values.length - 1)
                                                        Padding(
                                                          padding: const EdgeInsets.only(right: Paddings.regular),
                                                          child: CustomButtons.icon(
                                                            padding: const EdgeInsets.all(Paddings.small),
                                                            onPressed: () => controller.manageFilter(isMobile),
                                                            child: Icon(Icons.search, color: controller.isDropdownOpen ? kNeutralColor100 : kBlackColor),
                                                          ),
                                                        ),
                                                    ],
                                                  ),
                                                ),
                                              )
                                            : Expanded(
                                                flex: index == 0 || index == PropertyFilterSteps.values.length - 1 ? 3 : 2,
                                                child: OnHover(
                                                  builder: (isHovered) => DecoratedBox(
                                                    decoration: BoxDecoration(
                                                      color: isHovered
                                                          ? kNeutralLightColor.withAlpha(150)
                                                          : controller.currentStep == step && controller.isDropdownOpen
                                                              ? kNeutralLightColor
                                                              : kNeutralColor100,
                                                      borderRadius: circularRadius,
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                          flex: 2,
                                                          child: InkWell(
                                                            onTap: () => controller.setCurrentStep(step),
                                                            child: Center(
                                                              child: ListTile(
                                                                contentPadding: const EdgeInsets.only(left: Paddings.exceptional),
                                                                title: Text(step.value),
                                                                titleTextStyle: textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
                                                                subtitle: controller.resolveStepSubtitle(step),
                                                                subtitleTextStyle: textTheme.bodySmall!.copyWith(color: kNeutralColor),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        if (index == PropertyFilterSteps.values.length - 1)
                                                          Expanded(
                                                            child: CustomButtons.icon(
                                                              onPressed: () => controller.manageFilter(isMobile),
                                                              child: const Icon(Icons.search, color: kBlackColor),
                                                            ),
                                                          ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );
                                      },
                                    ),
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
                                          '${controller.filter?.location != null ? MainAppServie.find.getLocationNameById(controller.filter!.location!) : 'Anywhere'} • ${controller.filter?.getDuration ?? 'Any week'} • ${controller.filter?.guest.total}',
                                          style: textTheme.bodyMedium,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: Paddings.exceptional),
                      child: DecoratedBox(
                        decoration: BoxDecoration(border: lightBorder, borderRadius: circularRadius, color: kNeutralColor100),
                        child: CustomButtons.icon(
                          padding: const EdgeInsets.all(Paddings.large),
                          icon: const Icon(Icons.tune_outlined),
                          onPressed: () => Get.bottomSheet(MoreFiltersPopup(maxWidth: constraints.maxWidth), isScrollControlled: true),
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: Paddings.large),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(right: Paddings.regular),
                    controller: scrollController,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: Paddings.exceptional * 1.5, vertical: Paddings.regular),
                          child: Text(
                            "Découvrez notre sélection pour vos vacances",
                            style: TextStyle(
                              fontSize: 26.0,
                              height: 1.5,
                              color: Color.fromRGBO(33, 45, 82, 1),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        propertiesList,
                        Obx(
                          () => Helper.isLoading.value
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(vertical: Paddings.large, horizontal: Paddings.exceptional * 1.5),
                                  child: Center(child: Lottie.asset(Assets.fetchingData, height: 100)),
                                )
                              : const SizedBox(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            if (controller.isDropdownOpen) Positioned.fill(child: GestureDetector(onTap: () => controller.manageFilter(isMobile))),
            if (controller.isDropdownOpen) Positioned(child: controller.filterOverlayWidget(maxWidth: constraints.maxWidth)),
          ],
        ),
      ),
    );
  }
}
