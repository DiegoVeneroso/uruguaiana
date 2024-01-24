import 'package:appwrite/appwrite.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:eu_faco_parte/app/routes/app_pages.dart';

import '../../core/config/api_client.dart';

class SplashController extends GetxController {
  GetStorage storage = GetStorage();

  @override
  void onReady() async {
    super.onReady();

    Future.delayed(const Duration(seconds: 3), () async {
      if (storage.read('id_user') == null || storage.read('id_user') == '') {
        loginAnonymous();
        getTokeNotification();
        Get.offAllNamed(Routes.news);
        onClickBackgroundNotification();
      } else {
        print('usuario anonimo logado admin!');
        getTokeNotification();
        Get.offAllNamed(Routes.news);
        onClickBackgroundNotification();
      }
    });

    var collaboratesStorage = await storage.read('my_collaborates_list');
    if (collaboratesStorage == null) {
      await storage.write('my_collaborates_list', '[]');
    }
  }

  loginAnonymous() async {
    try {
      await ApiClient.account.createAnonymousSession();
      print('usuario anonimo logado!');
    } on AppwriteException catch (e) {
      print(e.message);
    }
  }

  onClickBackgroundNotification() {
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        _handleNotificationClick(message);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint(
          'onMessageOpenedApp: ${message.notification!.title.toString()}');
      _handleNotificationClick(message);
    });
  }

  void _handleNotificationClick(RemoteMessage message) {
    final notificationData = message.data;

    if (notificationData.containsKey('screen')) {
      final screen = notificationData['screen'];

      Get.toNamed(screen);
    }
  }
}

getTokeNotification() async {
  try {
    FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
    var token = await firebaseMessaging.getToken();
    var subs =
        await firebaseMessaging.subscribeToTopic("br.com.frontapp.uruguaiana");
    print('token');
    print(token);
  } on FirebaseException catch (e) {
    print(e.message);
  }
}
