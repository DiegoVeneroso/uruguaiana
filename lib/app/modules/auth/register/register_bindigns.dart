import 'package:get/get.dart';
import 'package:uruguaiana/app/modules/auth/login/login_controller.dart';
import 'package:uruguaiana/app/repository/auth_repository.dart';

import 'register_controller.dart';

class RegisterBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RegisterController>(
      // () => SignupController(AuthRepository(AppService())),
      () => RegisterController(AuthRepository()),
    );
    Get.lazyPut<LoginController>(
      // () => LoginController(AuthRepository(AppService())),
      () => LoginController(AuthRepository()),
    );
  }
}
