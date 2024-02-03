import 'package:get/get.dart';

import '../models/filter_data.dart';
import '../networking/api_base_helper.dart';

class LocationRepository extends GetxService {
  static LocationRepository get find => Get.find<LocationRepository>();

  Future<FilterData> getAllLocation() async {
    final result = await ApiBaseHelper().request(RequestType.get, '/location');
    return FilterData.fromJson(result);
  }
}