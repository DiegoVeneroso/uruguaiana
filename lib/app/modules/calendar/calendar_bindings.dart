import 'package:eu_faco_parte/app/modules/calendar/calendar_controller.dart';
import 'package:get/get.dart';

class CalendarBindings implements Bindings {
  @override
  void dependencies() {
    Get.put(CalendarController());
  }
}
