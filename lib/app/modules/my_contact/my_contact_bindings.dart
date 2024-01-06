import 'package:get/get.dart';
import 'package:uruguaiana/app/modules/my_contact/my_contact_controller.dart';
import 'package:uruguaiana/app/repository/auth_repository.dart';
import 'package:uruguaiana/app/repository/my_contact_repositories.dart';

class MyContactBindings implements Bindings {
  @override
  void dependencies() {
    Get.put(MyContactController(
        repository: MyContactRepository(), authRepository: AuthRepository()));
  }
}
