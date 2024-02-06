import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:the_land_lord_website/models/guest.dart';
import 'package:the_land_lord_website/widgets/custom_buttons.dart';

import '../../models/filter_data.dart';
import '../../services/main_app_service.dart';
import '../../models/property_filter_model.dart';
import '../../utils/constants/sizes.dart';
import '../../utils/enums/booking_steps.dart';
import '../../utils/constants/colors.dart';
import '../../utils/constants/constants.dart';
import '../../utils/enums/property_filter_steps.dart';
import '../custom_text_field.dart';
import '../flutter_counter.dart';
import '../select_date_widget.dart';

class PropertyFilterController extends GetxController {
  void Function(PropertyFilterModel)? updateFilter;
  final TextEditingController searchController = TextEditingController();
  final TextEditingController minPriceController = TextEditingController();
  final TextEditingController maxPriceController = TextEditingController();
  final LayerLink layerLink = LayerLink();
  PropertyFilterSteps _currentStep = PropertyFilterSteps.where;
  List<String> guestInfoList = ['Adults', 'Children', 'Infants', 'Pets'];
  bool _isDropdownOpen = false;
  bool _isExpanded = false;
  PropertyFilterModel? _filter;
  bool _isLoading = false;

  bool get isLoading => _isLoading;
  PropertyFilterModel? get filter => _filter;
  bool get isExpanded => _isExpanded;
  bool get isDropdownOpen => _isDropdownOpen;
  PropertyFilterSteps get currentStep => _currentStep;

  set isLoading(bool value) {
    _isLoading = value;
    update();
  }

  set filter(PropertyFilterModel? filterModel) {
    _filter = filterModel;
    update();
  }

  set isExpanded(bool value) {
    _isExpanded = value;
    if (!_isExpanded) _isDropdownOpen = false;
    update();
  }

  set isDropdownOpen(bool value) {
    _isDropdownOpen = value;
    update();
  }

  PropertyFilterController() {
    _init();
  }

  PropertyFilterModel toggleOverlay() {
    _isDropdownOpen = !_isDropdownOpen;
    update();
    return _filter!;
  }

  void setCurrentStep(PropertyFilterSteps value) {
    // The user needs to set the checkin before the checkout
    if (value == PropertyFilterSteps.checkout && _filter?.checkin == null) value = PropertyFilterSteps.checkin;
    _currentStep = value;
    if (!_isDropdownOpen) toggleOverlay();
    update();
  }

  Widget filterOverlayWidget({required double maxWidth}) {
    Widget menu = _resolveCurrentStepMenu(maxWidth);
    return CompositedTransformFollower(
      link: layerLink,
      showWhenUnlinked: false,
      targetAnchor: currentStep == PropertyFilterSteps.guest ? Alignment.centerRight : Alignment.centerLeft,
      offset: currentStep == PropertyFilterSteps.guest ? const Offset(-230, 40) : const Offset(0, 40),
      child: Material(
        color: kNeutralColor100,
        borderRadius: regularRadius,
        child: DecoratedBox(decoration: BoxDecoration(border: lightBorder, borderRadius: regularRadius), child: menu),
      ),
    );
  }

  Text resolveStepSubtitle(PropertyFilterSteps step) {
    switch (step) {
      case PropertyFilterSteps.where:
        return Text(_filter?.location != null ? MainAppServie.find.getLocationNameById(_filter!.location!) : 'Any Where');
      case PropertyFilterSteps.checkin:
        return Text(_filter?.checkin != null ? DateFormat.yMd().format(_filter!.checkin!) : 'Any Time');
      case PropertyFilterSteps.checkout:
        return Text(_filter?.checkout != null ? DateFormat.yMd().format(_filter!.checkout!) : 'Any Time');
      case PropertyFilterSteps.guest:
        return Text(_filter!.guest.total);
    }
  }

  Widget _resolveCurrentStepMenu(double maxWidth) {
    switch (currentStep) {
      case PropertyFilterSteps.where:
        List<DBObject> filteredLocations = List.of(MainAppServie.find.filterData?.locationList ?? []);
        return GestureDetector(
          child: SizedBox(
            height: 300,
            width: 250,
            child: SingleChildScrollView(
              child: StatefulBuilder(
                builder: (context, setState) => Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: Paddings.regular).copyWith(bottom: Paddings.small),
                      child: CustomTextField(
                        hintText: 'Search Location',
                        fieldController: searchController,
                        onChanged: (value) {
                          filteredLocations = List.of(
                              MainAppServie.find.filterData!.locationList.where((element) => element.name.toLowerCase().contains(searchController.text.toLowerCase())).toList());
                          setState(() {});
                        },
                      ),
                    ),
                    ...List.generate(
                      filteredLocations.length + 1,
                      (index) => ListTile(
                        onTap: () {
                          if (index == 0) {
                            _filter?.location = null;
                          } else {
                            _filter?.location = filteredLocations[index - 1].id;
                          }
                          Get.back();
                          searchController.clear();
                          setCurrentStep(PropertyFilterSteps.checkin);
                        },
                        title: Text(index == 0 ? 'Anywhere' : filteredLocations[index - 1].name),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      case PropertyFilterSteps.checkin:
      case PropertyFilterSteps.checkout:
        return SizedBox(
          height: 400,
          width: maxWidth - 270,
          child: SelectDateWidget(
            initialSelectedRange: PickerDateRange(_filter?.checkin, _filter?.checkout),
            step: BookingStep.selectDate,
            onSelectionChanged: (selection) async {
              if (currentStep == PropertyFilterSteps.checkin) {
                _filter?.checkin = selection.value.startDate;
                setCurrentStep(PropertyFilterSteps.checkout);
              } else {
                _filter?.checkout = selection.value.endDate;
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
          width: 230,
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
                        _filter?.guest.adults = value.toInt();
                        break;
                      case 1:
                        _filter?.guest.children = value.toInt();
                        break;
                      case 2:
                        _filter?.guest.infants = value.toInt();
                        break;
                      case 3:
                        _filter?.guest.pets = value.toInt();
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

  void manageFilter(bool isMobile) {
    if (isMobile) {
      // Get.toNamed(BookingDetailsScreen.routeName);
    } else {
      final filter = toggleOverlay();
      if (isDropdownOpen && !isExpanded) _isExpanded = true;
      if (!isDropdownOpen) updateFilter?.call(filter);
      update();
    }
  }

  void managePriceFilter({RangeValues? range, String? min, String? max}) {
    if (range != null) {
      filter?.priceMin = range.start;
      filter?.priceMax = range.end;
    }
    if (min != null) {
      final minDouble = double.parse(min);
      if (minDouble < filter!.priceMax) filter?.priceMin = minDouble;
    }
    if (max != null) {
      final maxDouble = double.parse(max);
      if (maxDouble > filter!.priceMin) filter?.priceMax = maxDouble;
    }
    minPriceController.text = filter!.priceMin.toStringAsFixed(1);
    maxPriceController.text = filter!.priceMax.toStringAsFixed(1);
    update();
  }

  void resetFilterForm() {
    filter = PropertyFilterModel();
    managePriceFilter(max: maxPriceRange.toString(), min: minPriceRange.toString());
  }

  void _init() {
    filter ??= PropertyFilterModel();
    minPriceController.text = filter!.priceMin.toStringAsFixed(1);
    maxPriceController.text = filter!.priceMax.toStringAsFixed(1);
    isExpanded = GetPlatform.isWeb || GetPlatform.isDesktop || GetPlatform.isMacOS;
  }

  Widget? resolveClearFilterTrailing(PropertyFilterSteps step) {
    switch (currentStep) {
      case PropertyFilterSteps.where:
        if (_filter?.location != null) {
          return Padding(
            padding: const EdgeInsets.only(right: Paddings.regular),
            child: CustomButtons.icon(
              onPressed: () {
                _filter?.location = null;
                update();
              },
              icon: const Icon(Icons.clear, size: 14),
            ),
          );
        }
        break;
      case PropertyFilterSteps.checkin:
        if (_filter?.checkin != null) {
          return Padding(
            padding: const EdgeInsets.only(right: Paddings.regular),
            child: CustomButtons.icon(
              onPressed: () {
                _filter?.checkin = null;
                update();
              },
              icon: const Icon(Icons.clear, size: 14),
            ),
          );
        }
        break;
      case PropertyFilterSteps.checkout:
        if (_filter?.checkout != null) {
          return Padding(
            padding: const EdgeInsets.only(right: Paddings.regular),
            child: CustomButtons.icon(
              onPressed: () {
                _filter?.checkout = null;
                update();
              },
              icon: const Icon(Icons.clear, size: 14),
            ),
          );
        }
        break;
      case PropertyFilterSteps.guest:
        if (_filter!.guest.totalGuests > 1 || _filter!.guest.pets > 0) {
          return CustomButtons.icon(
            onPressed: () {
              _filter?.guest = Guest();
              update();
            },
            icon: const Icon(Icons.clear, size: 14),
          );
        }
        break;
    }
    return null;
  }

  int _resolveInitialValue(int index) {
    switch (index) {
      case 0:
        return _filter!.guest.adults;
      case 1:
        return _filter!.guest.children;
      case 2:
        return _filter!.guest.infants;
      case 3:
        return _filter!.guest.pets;
      default:
        return 0;
    }
  }

  void updateFilterModel({int? bathrooms, int? beds, int? type, PropertyFilterModel? filterModel, Map<String, dynamic>? amenity, bool clearAll = false}) {
    if (clearAll) {
      filter = PropertyFilterModel();
      return;
    }
    if (amenity != null) {
      if (amenity['value']) {
        filter?.amenities.add(amenity['amenity']);
      } else {
        filter?.amenities.remove(amenity['amenity']);
      }
    }
    filter = PropertyFilterModel(
      location: filterModel?.location ?? filter?.location,
      beds: beds ?? filterModel?.beds ?? filter?.beds,
      checkin: filterModel?.checkin ?? filter?.checkin,
      checkout: filterModel?.checkout ?? filter?.checkout,
      bathrooms: bathrooms ?? filterModel?.bathrooms ?? filter?.bathrooms,
      type: type ?? filterModel?.type ?? filter?.type,
      guest: filterModel?.guest ?? filter?.guest,
      amenitiesList: filter?.amenities,
      priceMin: filterModel?.priceMin ?? filter?.priceMin,
      priceMax: filterModel?.priceMax ?? filter?.priceMax,
    );
  }
}
