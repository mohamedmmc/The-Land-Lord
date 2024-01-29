import 'package:the_land_lord_website/utils/constants/properties_dummy_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:the_land_lord_website/utils/constants/sizes.dart';

import '../../models/property_filter_model.dart';
import '../../utils/booking_steps.dart';
import '../../utils/constants/colors.dart';
import '../../utils/constants/constants.dart';
import '../../utils/enums/property_filter_steps.dart';
import '../../views/booking_screen.dart';
import '../flutter_counter.dart';
import '../select_date_widget.dart';

class PropertyFilterController extends GetxController {
  final LayerLink layerLink = LayerLink();
  PropertyFilterSteps _currentStep = PropertyFilterSteps.where;
  List<String> guestInfoList = ['Adults', 'Children', 'Infants', 'Pets'];
  bool _isOverlayOpen = false;
  bool _isExpanded = false;

  bool get isExpanded => _isExpanded;

  set isExpanded(bool value) {
    _isExpanded = value;
    update();
  }

  PropertyFilterModel currentSelection = PropertyFilterModel();

  bool get isOverlayOpen => _isOverlayOpen;

  PropertyFilterModel toggleOverlay() {
    _isOverlayOpen = !_isOverlayOpen;
    update();
    return currentSelection;
  }

  PropertyFilterSteps get currentStep => _currentStep;

  void setCurrentStep(PropertyFilterSteps value) {
    // The user needs to set the checkin before the checkout
    if (value == PropertyFilterSteps.checkout && currentSelection.checkin == null) value = PropertyFilterSteps.checkin;
    _currentStep = value;
    toggleOverlay();
  }

  Widget filterOverlayWidget({required double maxWidth}) {
    Widget menu = _resolveCurrentStepMenu(maxWidth);
    return CompositedTransformFollower(
      link: layerLink,
      showWhenUnlinked: false,
      targetAnchor: currentStep == PropertyFilterSteps.guest ? Alignment.centerRight : Alignment.centerLeft,
      offset: currentStep == PropertyFilterSteps.guest ? const Offset(-300, 50) : const Offset(0, 50),
      child: ClipRRect(
        borderRadius: regularRadius,
        child: Material(color: kNeutralColor100, child: DecoratedBox(decoration: BoxDecoration(border: lightBorder, borderRadius: regularRadius), child: menu)),
      ),
    );
  }

  Text resolveStepSubtitle(PropertyFilterSteps step) {
    switch (step) {
      case PropertyFilterSteps.where:
        return Text(currentSelection.location ?? 'Any Where');
      case PropertyFilterSteps.checkin:
        return Text(currentSelection.checkin != null ? DateFormat.yMd().format(currentSelection.checkin!) : 'Any Time');
      case PropertyFilterSteps.checkout:
        return Text(currentSelection.checkout != null ? DateFormat.yMd().format(currentSelection.checkout!) : 'Any Time');
      case PropertyFilterSteps.guest:
        return Text(currentSelection.guest.total);
    }
  }

  Widget _resolveCurrentStepMenu(double maxWidth) {
    switch (currentStep) {
      case PropertyFilterSteps.where:
        final locationsDummyData = propertiesDummyData.map((element) => element.location).toSet().toList();
        return SizedBox(
          height: 300,
          width: 200,
          child: SingleChildScrollView(
            child: Column(
              children: List.generate(
                locationsDummyData.length,
                (index) => ListTile(
                  onTap: () {
                    currentSelection.location = locationsDummyData[index];
                    Get.back();
                    setCurrentStep(PropertyFilterSteps.checkin);
                  },
                  title: Text(locationsDummyData[index] ?? 'NA'),
                  trailing: Text('(${propertiesDummyData.where((element) => element.location == locationsDummyData[index]).length} spots)'),
                ),
              ),
            ),
          ),
        );
      case PropertyFilterSteps.checkin:
      case PropertyFilterSteps.checkout:
        return SizedBox(
          height: 400,
          width: maxWidth - 320,
          child: SelectDateWidget(
            step: BookingStep.selectDate,
            onSelectionChanged: (selection) async {
              if (currentStep == PropertyFilterSteps.checkin) {
                currentSelection.checkin = selection.value.startDate;
                setCurrentStep(PropertyFilterSteps.checkout);
              } else {
                currentSelection.checkout = selection.value.endDate;
                await Future.delayed(const Duration(milliseconds: 400));
                Get.back();
                setCurrentStep(PropertyFilterSteps.guest);
              }
            },
          ),
        );
      case PropertyFilterSteps.guest:
        return SizedBox(
          height: 300,
          width: 200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(
              guestInfoList.length,
              (index) => ListTile(
                title: Text(guestInfoList[index], style: const TextStyle(fontSize: 15)),
                contentPadding: const EdgeInsets.only(left: Paddings.large, right: Paddings.small),
                trailing: Counter(
                  minValue: index == 0 ? 1 : 0, // 1 adult is required for reservation
                  maxValue: 10,
                  decimalPlaces: 0,
                  initialValue: _resolveInitialValue(index),
                  color: kNeutralColor100,
                  step: 1,
                  style: const TextStyle(letterSpacing: 10),
                  onChanged: (value) {
                    switch (index) {
                      case 0:
                        currentSelection.guest.adults = value.toInt();
                        break;
                      case 1:
                        currentSelection.guest.children = value.toInt();
                        break;
                      case 2:
                        currentSelection.guest.infants = value.toInt();
                        break;
                      case 3:
                        currentSelection.guest.pets = value.toInt();
                        break;
                      default:
                    }
                    update();
                  },
                ),
              ),
            ),
          ),
        );
    }
  }

  int _resolveInitialValue(int index) {
    switch (index) {
      case 0:
        return currentSelection.guest.adults;
      case 1:
        return currentSelection.guest.children;
      case 2:
        return currentSelection.guest.infants;
      case 3:
        return currentSelection.guest.pets;
      default:
        return 0;
    }
  }

  void manageFilter(bool isMobile, void Function(PropertyFilterModel filter) updateFilter) {
    if (isMobile) {
      Get.toNamed(BookingDetailsScreen.routeName);
    } else {
      isExpanded = !isExpanded;
      final filter = toggleOverlay();
      if (!isExpanded) updateFilter.call(filter);
      update();
    }
  }
}
