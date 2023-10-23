import 'package:get/get.dart';
import 'package:uruguaiana/app/repository/auth_repository.dart';
import 'package:uruguaiana/app/repository/collaborate_repositories.dart';
import './collaborate_controller.dart';

class CollaborateBindings implements Bindings {
  @override
  void dependencies() {
    Get.put(CollaborateController(
      repository: ColaborateRepository(),
      authRepository: AuthRepository(),
    ));
  }
}
