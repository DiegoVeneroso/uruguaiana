import 'package:eu_faco_parte/app/modules/calendar/calendar_controller.dart';
import 'package:eu_faco_parte/app/repository/auth_repository.dart';
import 'package:eu_faco_parte/app/repository/calendar_repositories.dart';
import 'package:get/get.dart';

class CalendarBindings implements Bindings {
  @override
  void dependencies() {
    Get.put(CalendarController(
      repository: CalendarRepository(),
      authRepository: AuthRepository(),
    ));
  }
}
