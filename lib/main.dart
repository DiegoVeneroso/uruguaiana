import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'app/core/colors/app_theme.dart';
import 'app/core/colors/services/theme_service.dart';
import 'app/routes/app_pages.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await GetStorage.init();
  await FirebaseMessaging.instance.requestPermission();
  await initializeDateFormatting('pt_BR');

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) => runApp(GetMaterialApp(
            title: 'Realtime modelo',
            initialRoute: AppPages.initial,
            theme: Themes.light,
            darkTheme: Themes.dark,
            themeMode: ThemeService().theme,
            // initialBinding: AppBinding(),
            getPages: AppPages.routes,
            locale: Get.deviceLocale,
            debugShowCheckedModeBanner: false,
          )));
}
