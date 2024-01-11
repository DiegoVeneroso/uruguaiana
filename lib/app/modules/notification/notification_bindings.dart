import 'package:get/get.dart';
import 'package:eu_faco_parte/app/modules/notification/notification_controller.dart';
import 'package:eu_faco_parte/app/repository/auth_repository.dart';
import 'package:eu_faco_parte/app/repository/notification_repositories.dart';

class NotificationBindings implements Bindings {
  @override
  void dependencies() {
    Get.put(NotificationController(
      repository: NotificationRepository(),
      authRepository: AuthRepository(),
    ));
  }
}
