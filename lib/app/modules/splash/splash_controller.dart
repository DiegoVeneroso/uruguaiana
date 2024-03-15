import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:eu_faco_parte/app/routes/app_pages.dart';

import '../../core/config/api_client.dart';

class SplashController extends GetxController {
  GetStorage storage = GetStorage();

  @override
  void onReady() async {
    super.onReady();

    Future.delayed(const Duration(seconds: 5), () async {
      Get.toNamed(Routes.jobs);
      // if (storage.read('id_user') == null || storage.read('id_user') == '') {
      //   loginAnonymous();
      //   getTokeNotification();
      //   Get.offAllNamed(Routes.news);
      //   onClickBackgroundNotification();
      // } else {
      //   log('usuario anonimo logado admin!');
      //   getTokeNotification();
      //   Get.offAllNamed(Routes.news);
      //   onClickBackgroundNotification();
      // }
    });

    var collaboratesStorage = await storage.read('my_collaborates_list');
    if (collaboratesStorage == null) {
      await storage.write('my_collaborates_list', '[]');
    }
  }

  loginAnonymous() async {
    try {
      await ApiClient.account.createAnonymousSession();
      log('usuario anonimo logado!');
    } on AppwriteException catch (e) {
      log(e.message.toString());
    }
  }

  onClickBackgroundNotification() {
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        _handleNotificationClick(message);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      log('onMessageOpenedApp: ${message.notification!.title.toString()}');
      _handleNotificationClick(message);
    });
  }

  void _handleNotificationClick(RemoteMessage message) {
    final notificationData = message.data;

    if (notificationData.containsKey('screen') &&
        notificationData.containsKey('id_question')) {
      final screen = notificationData['screen'];
      final idQuestion = notificationData['id_question'];

      Get.offAllNamed(screen, parameters: {
        'id_question': idQuestion,
      });
    }
  }
}

getTokeNotification() async {
  try {
    FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
    var token = await firebaseMessaging.getToken();
    // ignore: unused_local_variable
    var subs =
        await firebaseMessaging.subscribeToTopic("br.com.frontapp.uruguaiana");
    log('token');
    log(token.toString());
  } on FirebaseException catch (e) {
    log(e.message.toString());
  }
}
