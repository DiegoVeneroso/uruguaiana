import 'package:get/get.dart';
import 'package:eu_faco_parte/app/modules/my_colaborate/my_colaborate_controller.dart';
import 'package:eu_faco_parte/app/repository/auth_repository.dart';
import 'package:eu_faco_parte/app/repository/my_collaborate_repositories.dart';

class MyCollaborateBindings implements Bindings {
  @override
  void dependencies() {
    Get.put(MyCollaborateController(
      repository: MyColaborateRepository(),
      authRepository: AuthRepository(),
    ));
  }
}
