import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:uruguaiana/app/routes/app_pages.dart';

class SplashController extends GetxController {
  GetStorage storage = GetStorage();

  @override
  void onReady() async {
    super.onReady();
    Future.delayed(const Duration(seconds: 3), () async {
      await storage.read('sessionId') == '' ||
              await storage.read('sessionId') == null
          ? Get.offAllNamed(Routes.login)
          : Get.offAllNamed(Routes.home);
    });
  }
}
