import 'package:get/get.dart';
import 'package:eu_faco_parte/app/repository/about_repositories.dart';
import 'package:eu_faco_parte/app/repository/auth_repository.dart';
import './about_controller.dart';

class AboutBindings implements Bindings {
  @override
  void dependencies() {
    Get.put(
      AboutController(
        repository: AboutRepository(),
        authRepository: AuthRepository(),
      ),
    );
  }
}
