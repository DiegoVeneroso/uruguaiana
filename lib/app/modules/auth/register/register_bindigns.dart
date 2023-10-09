import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:uruguaiana/app/modules/auth/login/login_controller.dart';
import 'package:uruguaiana/app/repository/auth_repository.dart';

import 'register_controller.dart';

class RegisterBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RegisterController>(
      () => RegisterController(AuthRepository(), GetStorage()),
    );
    Get.lazyPut<LoginController>(
      () => LoginController(
        AuthRepository(),
      ),
    );
  }
}
