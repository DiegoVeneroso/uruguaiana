import 'package:get/get.dart';
import 'package:eu_faco_parte/app/repository/profile_repositories.dart';
import './profile_controller.dart';

class ProfileBindings implements Bindings {
  @override
  void dependencies() {
    Get.put(ProfileController(repository: ProfileRepository()));
  }
}
