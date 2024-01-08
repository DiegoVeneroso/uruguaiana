import 'package:get/get.dart';
import 'package:uruguaiana/app/modules/term_of_use/term_of_use_controller.dart';
import 'package:uruguaiana/app/repository/auth_repository.dart';
import 'package:uruguaiana/app/repository/termo_of_use_repositories.dart';

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
