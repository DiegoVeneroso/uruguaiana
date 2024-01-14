import 'package:get/get.dart';
import './donate_controller.dart';

class DonateBindings implements Bindings {
    @override
    void dependencies() {
        Get.put(DonateController());
    }
}