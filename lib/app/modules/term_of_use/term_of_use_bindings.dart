import 'package:get/get.dart';
import 'package:eu_faco_parte/app/modules/term_of_use/term_of_use_controller.dart';
import 'package:eu_faco_parte/app/repository/auth_repository.dart';
import 'package:eu_faco_parte/app/repository/termo_of_use_repositories.dart';

class TermOfUseBindings implements Bindings {
  @override
  void dependencies() {
    Get.put(
      TermOfUseController(
        repository: TermOfUseRepository(),
        authRepository: AuthRepository(),
      ),
    );
  }
}
