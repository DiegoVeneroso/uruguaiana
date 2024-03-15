import 'package:eu_faco_parte/app/repository/auth_repository.dart';
import 'package:eu_faco_parte/app/repository/jobs_repositories.dart';
import 'package:get/get.dart';
import './jobs_controller.dart';

class JobsBindings implements Bindings {
  @override
  void dependencies() {
    Get.put(JobsController(
      repository: JobsRepository(),
      authRepository: AuthRepository(),
    ));
  }
}
