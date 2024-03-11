import 'package:get/get.dart';
import './collaborators_controller.dart';

class CollaboratorsBindings implements Bindings {
    @override
    void dependencies() {
        Get.put(CollaboratorsController());
    }
}