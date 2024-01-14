import 'package:eu_faco_parte/app/modules/donate/donate_controller.dart';
import 'package:eu_faco_parte/app/repository/donate_repositories.dart';
import 'package:eu_faco_parte/app/repository/auth_repository.dart';
import 'package:get/get.dart';

class DonateBindings implements Bindings {
  @override
  void dependencies() {
    Get.put(
      DonateController(
          repository: DonateRepository(), authRepository: AuthRepository()),
    );
  }
}
