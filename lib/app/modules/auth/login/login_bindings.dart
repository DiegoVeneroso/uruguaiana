import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../repository/auth_repository.dart';
import './login_controller.dart';

class LoginBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginController>(
      // () => LoginController(AuthRepository(AppService())),
      () => LoginController(
        AuthRepository(),
      ),
    );
  }
}
