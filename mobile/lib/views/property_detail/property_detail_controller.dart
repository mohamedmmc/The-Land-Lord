import 'package:get/get.dart';
import 'package:the_land_lord_website/helpers/helper.dart';
import 'package:the_land_lord_website/repository/property_repository.dart';
import 'package:the_land_lord_website/utils/shared_preferences.dart';

import '../../models/dto/property_detail_dto.dart';

class PropertyDetailController extends GetxController {
  RxString idProperty = ''.obs;

  late PropertyDetailDTO propertyDetailDTO;

  PropertyDetailController() {
    _init();
  }

  void _init() {
    Helper.waitAndExecute(() => SharedPreferencesService.find.isReady, () async {
      idProperty.value = Get.arguments?['id'] ?? SharedPreferencesService.find.get('idProperty');
      propertyDetailDTO = await PropertyRepository.find.getDetailProperty(idProperty: idProperty.value);
      update();
    });
  }
}
