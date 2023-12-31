import 'package:get/get.dart';
import 'package:uruguaiana/app/repository/auth_repository.dart';

import '../../repository/home_repositories.dart';
import 'home_controller.dart';

class HomeBindings implements Bindings {
  @override
  void dependencies() {
    Get.put<HomeController>(
      HomeController(
        repository: HomeRepository(),
        authRepository: AuthRepository(),
      ),
    );
  }
}
