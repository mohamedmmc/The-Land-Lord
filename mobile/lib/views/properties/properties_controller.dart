import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:get/get.dart';

import '../../helpers/helper.dart';
import '../../models/property.dart';
import '../../models/property_filter_model.dart';
import '../../repository/property_repository.dart';
import '../../utils/shared_preferences.dart';
import '../property_detail/property_detail_screen.dart';

class PropertiesController extends GetxController {
  PropertyFilterModel? _filter;
  final ScrollController scrollController = ScrollController();
  List<Property> filteredProperties = [];
  List<LayerLink> propertiesMarkerLayer = [];
  MapController mapController = MapController();
  bool isEndList = false;
  bool _isFilterExpanded = false;
  int page = 0;

  PropertyFilterModel? get filter => _filter;
  bool get isFilterExpanded => _isFilterExpanded;

  set isFilterExpanded(bool value) {
    if (value == _isFilterExpanded) return;
    _isFilterExpanded = value;
    update();
  }

  set filter(PropertyFilterModel? filterModel) {
    _filter = filterModel;
    page = 0;
    _getProperties();
  }

  PropertiesController() {
    _filter = PropertyFilterModel();
    scrollController.addListener(() {
      isFilterExpanded = scrollController.position.pixels >= 50;
      if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 50) _loadMore();
    });
    Helper.waitAndExecute(() => !Helper.isLoading.value, () => _getProperties());
  }

  void updateFilter({PropertyFilterModel? filterModel}) {
    if (filterModel?.amenities.isEmpty ?? false) _filter?.amenities.clear();
    filter = PropertyFilterModel(
      location: filterModel?.location ?? filter?.location,
      beds: filterModel?.beds ?? filter?.beds,
      checkin: filterModel?.checkin ?? filter?.checkin,
      checkout: filterModel?.checkout ?? filter?.checkout,
      bathrooms: filterModel?.bathrooms ?? filter?.bathrooms,
      type: filterModel?.type ?? filter?.type,
      guest: filterModel?.guest ?? filter?.guest,
      amenitiesList: filterModel?.amenities != null && filterModel!.amenities.isNotEmpty ? filterModel.amenities : filter?.amenities,
      priceMin: filterModel?.priceMin ?? filter?.priceMin,
      priceMax: filterModel?.priceMax ?? filter?.priceMax,
    );
  }

  Map<String, dynamic>? calculateMidPoint() {
    Map<String, dynamic> calculateMidpoint(List<LatLng> coordinates) {
      if (coordinates.isEmpty) return {};
      double minLat = double.infinity;
      double maxLat = double.negativeInfinity;
      double minLng = double.infinity;
      double maxLng = double.negativeInfinity;

      for (LatLng coord in coordinates) {
        minLat = math.min(minLat, coord.latitude);
        maxLat = math.max(maxLat, coord.latitude);
        minLng = math.min(minLng, coord.longitude);
        maxLng = math.max(maxLng, coord.longitude);
      }

      return {
        'midPoint': LatLng((minLat + maxLat) / 2, (minLng + maxLng) / 2),
        'minLat': minLat,
        'maxLat': maxLat,
        'minLng': minLng,
        'maxLng': maxLng,
      };
    }

    double calculateZoomLevel(LatLng midpoint, double minLat, double maxLat, double minLng, double maxLng) {
      double distanceLatitude = math.max(midpoint.latitude - minLat, maxLat - midpoint.latitude);
      double distanceLongitude = math.max(midpoint.longitude - minLng, maxLng - midpoint.longitude);
      double distance = math.max(distanceLongitude, distanceLatitude);
      if (distance == 0 || distance < 0.01) return 14;
      if (distance < 0.1) return 12;
      if (distance < 0.2) return 11;
      if (distance < 0.3) return 10;
      if (distance < 0.4) return 9.5;
      if (distance < 7) return distance / 150 * 120;
      return 4;
    }

    Map<String, dynamic> result = calculateMidpoint(filteredProperties.map((e) => e.coordinates!).toList());
    if (result.isEmpty) return null;
    LatLng midpoint = result['midPoint'];
    double zoomLevel = calculateZoomLevel(midpoint, result['minLat'], result['maxLat'], result['minLng'], result['maxLng']);
    try {
      mapController.move(midpoint, zoomLevel);
    } catch (e) {
      debugPrint('Error moving map camera');
    }
    return {'midPoint': midpoint, 'zoomLevel': zoomLevel};
  }

  Future<void> _loadMore() async {
    if (isEndList || Helper.blockRequest.value) return;
    Helper.blockRequest.value = true;
    Helper.isLoading.value = true;
    await scrollController.animateTo(scrollController.position.maxScrollExtent + 50, duration: Durations.medium1, curve: Curves.bounceIn);
    isEndList = (await _getProperties()) == 0;
    Helper.isLoading.value = false;
    Future.delayed(Durations.long1, () => Helper.blockRequest.value = false);
  }

  void detailScreen(String id) {
    SharedPreferencesService.find.add('idProperty', id);
    Get.toNamed(PropertyDetailScreen.routeName, arguments: {'id': id});
  }

  Future<int> _getProperties() async {
    final List<Property> properties = await PropertyRepository.find.getAllProperties(
      page: ++page,
      limit: 8,
      from: filter?.checkin != null ? DateFormat('yyyy-MM-dd').format(filter!.checkin!) : null,
      to: filter?.checkout != null ? DateFormat('yyyy-MM-dd').format(filter!.checkout!) : null,
      guest: filter?.guest.totalGuests == 1 ? null : filter?.guest.totalGuests,
      locationId: filter?.location,
      petAllowed: filter!.guest.pets > 0 ? true : null,
      bathrooms: filter?.bathrooms,
      type: filter?.type,
      beds: filter?.beds,
      priceMax: filter?.priceMax,
      priceMin: filter?.priceMin,
      amenities: filter?.amenities.map((e) => int.parse(e.id)).toList(),
    );
    if (properties.isEmpty) isEndList = true;
    if (page == 1) {
      filteredProperties = properties;
    } else {
      filteredProperties.addAll(properties);
    }
    propertiesMarkerLayer = [for (int i = 0; i < filteredProperties.length; i++) LayerLink()];
    update();
    return properties.length;
  }
}
