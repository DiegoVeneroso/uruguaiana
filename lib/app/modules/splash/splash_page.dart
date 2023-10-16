import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uruguaiana/app/modules/splash/splash_controller.dart';

class SplashPage extends GetView<SplashController> {
  const SplashPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.theme.colorScheme.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: SizedBox(
                width: 250,
                height: 250,
                child: Image.asset(
                  'assets/images/logo.png',
                  width: 80,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
