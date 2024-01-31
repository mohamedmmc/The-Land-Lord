import 'package:get/get.dart';

import '../models/Location.dart';
import '../networking/api_base_helper.dart';

class LocationRepository extends GetxService {
  static LocationRepository get find => Get.find<LocationRepository>();

  Future<List<LocationData>> getAllLocation() async {
    final result = await ApiBaseHelper().request(RequestType.get, '/location');
    return (result as List).map((e) => LocationData.fromJson(e)).toList();
  }
}
