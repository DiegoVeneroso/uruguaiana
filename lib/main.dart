import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'app/core/bindings/app_binding.dart';
import 'app/core/config/app_ui.dart';
import 'app/routes/app_pages.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await GetStorage.init();

  runApp(GetMaterialApp(
    title: 'Auth_appwrite',
    initialRoute: AppPages.initial,
    theme: AppUi.theme,
    initialBinding: AppBinding(),
    getPages: AppPages.routes,
    // theme: ThemeData(primarySwatch: Colors.pink),
    debugShowCheckedModeBanner: false,
  ));
}
