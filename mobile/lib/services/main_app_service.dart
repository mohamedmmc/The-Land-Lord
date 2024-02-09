import 'package:get/get.dart';
import 'package:the_land_lord_website/helpers/helper.dart';
import 'package:the_land_lord_website/utils/constants/constants.dart';

import '../models/filter_data.dart';
import '../repository/location_repository.dart';

class MainAppServie extends GetxService {
  static MainAppServie get find => Get.find<MainAppServie>();
  bool isReady = false;

  FilterData? filterData;

  // bool get isUserLoggedIn => SharedPreferencesService.find.get('jwt') != null;
  String? getTypeNameById(int id) => filterData!.propertyTypelist.cast<DBObject?>().singleWhere((element) => element?.id == id, orElse: () => null)?.name;

  int getTypeIdByName(String name) => filterData!.propertyTypelist.singleWhere((element) => element.name == name).id;

  String getAmenityNameById(String id) => filterData!.listAmenities.cast<Amenity?>().singleWhere((element) => element?.id == id, orElse: () => null)?.name ?? 'Not Found';

  String getLocationNameById(int id) {
    try {
      if ((laMarsaGrp['children'] as List).contains(id)) return laMarsaGrp['title'] as String;
      return filterData!.locationList.singleWhere((element) => element.id == id).name;
    } catch (e) {
      // TODO fix this
      return 'Error';
    }
  }
  // User? get currentUser => isUserLoggedIn ? User.fromToken(JWT.decode(SharedPreferencesService.find.get('jwt')!).payload) : null;

  MainAppServie() {
    _init();
  }

  Future<void> _init() async {
    filterData = await LocationRepository.find.getAllLocation();
    isReady = true;
    Helper.isLoading.value = false;
  }
}
