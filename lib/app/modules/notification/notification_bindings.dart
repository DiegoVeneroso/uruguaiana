import 'package:get/get.dart';
import 'package:uruguaiana/app/modules/notification/notification_controller.dart';
import 'package:uruguaiana/app/repository/auth_repository.dart';
import 'package:uruguaiana/app/repository/notification_repositories.dart';

class NotificationBindings implements Bindings {
  @override
  void dependencies() {
    Get.put(NotificationController(
      repository: NotificationRepository(),
      authRepository: AuthRepository(),
    ));
  }
}
