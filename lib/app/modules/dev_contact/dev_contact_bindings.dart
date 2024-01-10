import 'package:get/get.dart';
import './dev_contact_controller.dart';

class DevContactBindings implements Bindings {
    @override
    void dependencies() {
        Get.put(DevContactController());
    }
}