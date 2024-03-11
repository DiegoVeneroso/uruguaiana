import 'package:get/get.dart';
import './activities_controller.dart';

class ActivitiesBindings implements Bindings {
    @override
    void dependencies() {
        Get.put(ActivitiesController());
    }
}