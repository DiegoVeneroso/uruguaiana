import 'package:eu_faco_parte/app/repository/auth_repository.dart';
import 'package:get/get.dart';
import './calendar_controller.dart';

class CalendarBindings implements Bindings {
  @override
  void dependencies() {
    Get.put(CalendarController());
  }
}
