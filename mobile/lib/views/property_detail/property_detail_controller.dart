import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:the_land_lord_website/helpers/helper.dart';
import 'package:the_land_lord_website/repository/property_repository.dart';
import 'package:the_land_lord_website/utils/shared_preferences.dart';

import '../../models/dto/property_detail_dto.dart';

class PropertyDetailController extends GetxController {
  final ScrollController scrollController = ScrollController();
  String? idProperty;
  PropertyDetailDTO? propertyDetailDTO;
  MapController mapController = MapController();
  DateTimeRange selectedDuration = DateTimeRange(start: DateTime.now(), end: DateTime.now().add(const Duration(days: 3)));

  PropertyDetailController() {
    _init();
  }

  void _init() {
    Helper.waitAndExecute(() => SharedPreferencesService.find.isReady, () async {
      idProperty = Get.arguments?['id'] ?? SharedPreferencesService.find.get('idProperty');
      if (idProperty != null) {
        propertyDetailDTO = await PropertyRepository.find.getDetailProperty(idProperty: idProperty!);
      }
      update();
    });
  }

  double getTotalPrice() =>
      (propertyDetailDTO?.mappedProperties.pricePerNight ?? 280) * Helper.getDurationInRange(selectedDuration) + (propertyDetailDTO?.mappedProperties.cleaningPrice != null ? double.parse(propertyDetailDTO!.mappedProperties.cleaningPrice) : 50);
}
