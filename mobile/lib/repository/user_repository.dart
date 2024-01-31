import 'package:get/get.dart';
import '../helpers/helper.dart';
import '../networking/api_base_helper.dart';

class UserRepository extends GetxService {
  static UserRepository get find => Get.find<UserRepository>();

  Future<String?> login({required String login, required String password}) async {
    final Map<String, String> loginData = {
      'login': login,
      'password': Helper.encryptPassword(password),
    };
    final result = await ApiBaseHelper().request(RequestType.post, '/user/login', body: loginData);

    return result['token'];
  }
}
