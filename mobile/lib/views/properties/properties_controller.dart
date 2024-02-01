import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:the_land_lord_website/services/main_app_service.dart';
import 'package:the_land_lord_website/helpers/helper.dart';
import 'package:the_land_lord_website/models/property_filter_model.dart';
import 'package:the_land_lord_website/utils/enums/property_type.dart';
import 'package:get/get.dart';

import '../../models/property.dart';

class PropertiesController extends GetxController {
  late PropertyFilterModel _filter;
  List<Property> filteredProperties = [];
  List<LayerLink> propertiesMarkerLayer = [];
  MapController mapController = MapController();

  PropertyFilterModel get filter => _filter;

  set filter(PropertyFilterModel filterModel) {
    _filter = filterModel;
    filteredProperties = _filterProperties(List.of(MainAppServie.find.propertyList), _filter);
    propertiesMarkerLayer = [for (int i = 0; i < filteredProperties.length; i++) LayerLink()];
    update();
  }

  PropertiesController() {
    _filter = PropertyFilterModel();
    Helper.waitAndExecute(() => !Helper.isLoading.value, () {
      filteredProperties = List.of(MainAppServie.find.propertyList);
      propertiesMarkerLayer = [for (int i = 0; i < filteredProperties.length; i++) LayerLink()];
      update();
    });
  }

  void updateFilter({int? rooms, int? beds, PropertyType? type, PropertyFilterModel? filterModel}) => filter = PropertyFilterModel(
        location: filterModel?.location ?? filter.location,
        beds: beds ?? filterModel?.beds ?? filter.beds,
        checkin: filterModel?.checkin ?? filter.checkin,
        checkout: filterModel?.checkout ?? filter.checkout,
        rooms: rooms ?? filterModel?.rooms ?? filter.rooms,
        type: type ?? filterModel?.type ?? filter.type,
        guest: filterModel?.guest ?? filter.guest,
      );

  List<Property> _filterProperties(List<Property> propertiesList, PropertyFilterModel filterModel) {
    return propertiesList.where((property) {
      // Apply location filter
      if (filterModel.location != null && property.location != filterModel.location) return false;
      // Apply guest capacity filter
      final totalGuests = filterModel.guest.adults + filterModel.guest.children + filterModel.guest.infants;
      if (property.guests == null || property.guests! < totalGuests) return false;
      // Check pets allowed
      if (property.petsAllowed != null && filterModel.guest.pets > 0 && !property.petsAllowed!) return false;
      // Apply rooms filter
      if (filterModel.rooms != null && property.rooms == null || filterModel.rooms != null && property.rooms! <= filterModel.rooms!) return false;
      // Apply beds filter
      if (filterModel.beds != null && property.beds == null || filterModel.beds != null && property.beds! <= filterModel.beds!) return false;
      // Apply type filter
      if (filterModel.type != null && property.type == null || filterModel.type != null && property.type == filterModel.type!.value) return false;
      // Apply date filters
      if (filterModel.checkin != null && filterModel.checkout != null) {
        // Check if any existing bookings conflict with the desired dates
        // for (Booking booking in property.bookings) {
        //   if (booking.checkIn!.isBefore(filterModel.checkout!) && booking.checkOut!.isAfter(filterModel.checkin!)) {
        //     return false; // Property is unavailable for selected dates
        //   }
        // }
      }
      return true;
    }).toList();
  }

  Map<String, dynamic> calculateMidPoint() {
    Map<String, dynamic> calculateMidpoint(List<LatLng> coordinates) {
      double minLat = double.infinity;
      double maxLat = double.negativeInfinity;
      double minLon = double.infinity;
      double maxLon = double.negativeInfinity;

      for (LatLng coord in coordinates) {
        minLat = math.min(minLat, coord.latitude);
        maxLat = math.max(maxLat, coord.latitude);
        minLon = math.min(minLon, coord.longitude);
        maxLon = math.max(maxLon, coord.longitude);
      }

      return {
        'midPoint': LatLng((minLat + maxLat) / 2, (minLon + maxLon) / 2),
        'minLat': minLat,
        'maxLat': maxLat,
      };
    }

    double calculateZoomLevel(LatLng midpoint, double minLat, double maxLat) {
      double distance = math.max(midpoint.latitude - minLat, maxLat - midpoint.latitude);
      if (distance == 0 || distance < 0.01) return 14;
      if (distance < 1) return 13;
      if (distance < 2) return 12;
      if (distance < 3) return 11;
      if (distance < 4) return 10;
      // if (distance > 5)
      return distance / 200 * 120;
    }

    Map<String, dynamic> result = calculateMidpoint(filteredProperties.map((e) => e.coordinates!).toList());
    LatLng midpoint = result['midPoint'];
    double zoomLevel = calculateZoomLevel(midpoint, result['minLat'], result['maxLat']);
    try {
      mapController.move(midpoint, zoomLevel);
    } catch (e) {
      debugPrint('Error moving map camera');
    }
    return {'midPoint': midpoint, 'zoomLevel': zoomLevel};
  }
}
