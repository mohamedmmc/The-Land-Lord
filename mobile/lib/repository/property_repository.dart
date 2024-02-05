import 'dart:convert';

import 'package:get/get.dart';
import 'package:the_land_lord_website/models/dto/property_detail_dto.dart';

import '../models/property.dart';
import '../networking/api_base_helper.dart';

class PropertyRepository extends GetxService {
  static PropertyRepository get find => Get.find<PropertyRepository>();

  Future<List<Property>> getAllProperties({
    int page = 0,
    int limit = 8,
    String? from,
    String? to,
    int? locationId,
    int? guest,
    int? room,
    bool? petAllowed,
    bool? smokingAllowed,
    int? type,
    List<int>? amenities,
  }) async {
    final result = await ApiBaseHelper().request(
      RequestType.get,
      '/property?pageQuery=$page&limitQuery=$limit${from != null ? '&dateFrom=$from' : ''}${to != null ? '&dateTo=$to' : ''}${locationId != null ? '&location=$locationId' : ''}${guest != null ? '&guest=$guest' : ''}${room != null ? '&room=$room' : ''}${type != null ? '&typeProperty=$type' : ''}${amenities != null && amenities.isNotEmpty ? '&amenities=${jsonEncode(amenities)}' : ''}${petAllowed != null ? '&petAllowed=${petAllowed ? "allowed" : "not allowed"}' : ''}${smokingAllowed != null ? '&smokeAllowed=${smokingAllowed ? "allowed" : "not allowed"}' : ''}',
    );
    return (result['formattedList'] as List).map((e) => Property.fromJson(e)).toList();
  }

  Future<PropertyDetailDTO> getDetailProperty({required String idProperty}) async {

    final result = await ApiBaseHelper().request(RequestType.get, '/property/$idProperty');

    return PropertyDetailDTO.fromJson(result);

  }
}
