import 'package:get/get.dart';
import 'package:uruguaiana/app/routes/app_pages.dart';

class SplashController extends GetxController {
  @override
  void onReady() async {
    super.onReady();
    Future.delayed(
        const Duration(seconds: 3), () => Get.offAllNamed(Routes.login));
  }
}
