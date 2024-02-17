import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eu_faco_parte/app/modules/splash/splash_controller.dart';
import 'package:lottie/lottie.dart';

class SplashPage extends GetView<SplashController> {
  const SplashPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.bottomRight,
              end: Alignment.topLeft,
              colors: [
            Color.fromARGB(255, 255, 251, 247),
            Color.fromARGB(255, 255, 205, 141),
          ])),
      child: Scaffold(
        // backgroundColor: Get.theme.colorScheme.background,
        backgroundColor: const Color(0xFFF7F7F7),

        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                LottieBuilder.asset(
                  'assets/lottie/splash_animate.json',
                  repeat: false,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
