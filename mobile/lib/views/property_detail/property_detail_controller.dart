import 'package:get/get.dart';
import 'package:the_land_lord_website/helpers/helper.dart';
import 'package:the_land_lord_website/utils/shared_preferences.dart';

class PropertyDetailController extends GetxController {
  RxString idProperty = ''.obs;

  PropertyDetailController() {
    _init();
  }

  void _init() {
    Helper.waitAndExecute(
      () => SharedPreferencesService.find.isReady,
      () {
        idProperty.value = Get.arguments?['id'] ?? SharedPreferencesService.find.get('idProperty');
        update();
      },
    );
  }
}
