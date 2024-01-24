import 'package:eu_faco_parte/app/repository/auth_repository.dart';
import 'package:eu_faco_parte/app/repository/question_repositories.dart';
import 'package:get/get.dart';
import './question_controller.dart';

class QuestionBindings implements Bindings {
  @override
  void dependencies() {
    Get.put(
      QuestionController(
        repository: QuestionRepository(),
        authRepository: AuthRepository(),
      ),
    );
  }
}
