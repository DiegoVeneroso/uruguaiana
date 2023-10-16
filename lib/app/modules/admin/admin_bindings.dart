import 'package:get/get.dart';
import './admin_controller.dart';

class AdminBindings implements Bindings {
    @override
    void dependencies() {
        Get.put(AdminController());
    }
}