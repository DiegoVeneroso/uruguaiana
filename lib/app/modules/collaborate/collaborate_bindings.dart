import 'package:get/get.dart';
import './collaborate_controller.dart';

class CollaborateBindings implements Bindings {
    @override
    void dependencies() {
        Get.put(CollaborateController());
    }
}