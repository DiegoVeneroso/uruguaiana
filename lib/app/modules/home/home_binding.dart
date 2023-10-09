import 'package:get/get.dart';

import '../../repository/home_repositories.dart';
import 'home_controller.dart';

class HomeBindings implements Bindings {
  @override
  void dependencies() {
    Get.put<HomeController>(
      HomeController(repository: HomeRepository()),
    );
  }
}
