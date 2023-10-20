import 'package:get/get.dart';
import './about_controller.dart';

class AboutBindings implements Bindings {
    @override
    void dependencies() {
        Get.put(AboutController());
    }
}