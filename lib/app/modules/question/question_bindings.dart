import 'package:get/get.dart';
import './question_controller.dart';

class QuestionBindings implements Bindings {
    @override
    void dependencies() {
        Get.put(QuestionController());
    }
}