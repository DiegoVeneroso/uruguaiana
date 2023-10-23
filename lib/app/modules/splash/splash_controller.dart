import 'package:appwrite/appwrite.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:uruguaiana/app/routes/app_pages.dart';

import '../../core/config/api_client.dart';

class SplashController extends GetxController {
  GetStorage storage = GetStorage();

  @override
  void onReady() async {
    super.onReady();

    Future.delayed(const Duration(seconds: 3), () async {
      if (storage.read('id_user') == null || storage.read('id_user') == '') {
        loginAnonymous();
        Get.offAllNamed(Routes.news);
      } else {
        print('usuario anonimo logado admin!');
        Get.offAllNamed(Routes.news);
      }
    });
  }

  loginAnonymous() async {
    try {
      await ApiClient.account.createAnonymousSession();
      print('usuario anonimo logado!');
    } on AppwriteException catch (e) {
      print(e.message);
    }
  }
}
