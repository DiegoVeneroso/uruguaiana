import 'package:get/get.dart';

import '../../../repository/auth_repository.dart';
import 'recovery_password_controller.dart';

class RecoveyPasswordBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RecoveyPasswordController>(
      // () => LoginController(AuthRepository(AppService())),
      () => RecoveyPasswordController(AuthRepository()),
    );
  }
}
