import 'package:get/get.dart';
import 'package:the_land_lord_website/helpers/helper.dart';

import '../models/Location.dart';
import '../models/property.dart';
import '../repository/location_repository.dart';
import '../repository/property_repository.dart';
import '../utils/shared_preferences.dart';

class MainAppServie extends GetxService {
  static MainAppServie get find => Get.find<MainAppServie>();
  bool isReady = false;

  List<LocationData> locationList = [];
  List<Property> propertyList = [];

  bool get isUserLoggedIn => SharedPreferencesService.find.get('jwt') != null;
  String getLocatioNameById(int id) => locationList.singleWhere((element) => element.id == id).name;
  // User? get currentUser => isUserLoggedIn ? User.fromToken(JWT.decode(SharedPreferencesService.find.get('jwt')!).payload) : null;

  MainAppServie() {
    _init();
  }

  Future<void> _init() async {
    locationList = await LocationRepository.find.getAllLocation();
    propertyList = await PropertyRepository.find.getAllProperties();
    isReady = true;
    Helper.isLoading.value = false;
  }
}
