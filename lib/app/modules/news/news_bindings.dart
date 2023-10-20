import 'package:get/get.dart';
import '../../repository/auth_repository.dart';
import '../../repository/news_repositories.dart';
import './news_controller.dart';

class NewsBindings implements Bindings {
  @override
  void dependencies() {
    Get.put<NewsController>(
      NewsController(
        repository: NewsRepository(),
        authRepository: AuthRepository(),
      ),
    );
  }
}
