import 'package:get/get.dart';

import '../models/property.dart';
import '../networking/api_base_helper.dart';

class PropertyRepository extends GetxService {
  static PropertyRepository get find => Get.find<PropertyRepository>();

  Future<List<Property>> getAllProperties() async {
    final result = await ApiBaseHelper().request(RequestType.get, '/property');
    return (result['formattedList'] as List).map((e) => Property.fromJson(e)).toList();
  }
}
