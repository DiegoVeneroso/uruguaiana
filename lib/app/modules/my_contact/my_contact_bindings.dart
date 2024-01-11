import 'package:get/get.dart';
import 'package:eu_faco_parte/app/modules/my_contact/my_contact_controller.dart';
import 'package:eu_faco_parte/app/repository/auth_repository.dart';
import 'package:eu_faco_parte/app/repository/my_contact_repositories.dart';

class MyContactBindings implements Bindings {
  @override
  void dependencies() {
    Get.put(MyContactController(
        repository: MyContactRepository(), authRepository: AuthRepository()));
  }
}
