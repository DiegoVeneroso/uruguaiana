import 'package:get/get.dart';
import 'package:uruguaiana/app/repository/about_repositories.dart';
import 'package:uruguaiana/app/repository/auth_repository.dart';
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
