import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;

  // Buscando, armazenando em cache e ativando a configuração remota
  void _initConfig() async {
    await _remoteConfig.setConfigSettings(RemoteConfigSettings(
      // tempo de atualização do cache
      fetchTimeout: const Duration(seconds: 1),
      // uma busca esperará até 10 segundos antes de expirar
      minimumFetchInterval: const Duration(seconds: 10),
    ));
    await _remoteConfig.fetchAndActivate();
  }

  @override
  void initState() {
    _initConfig();
    super.initState();
  }

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
        // backgroundColor: const Color(0xFFF7F7F7),
        backgroundColor: _remoteConfig
                .getString('background_color_app')
                .isNotEmpty
            ? Color(int.parse(_remoteConfig.getString('background_color_app')))
            : const Color(0xFFF7F7F7),

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


// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:eu_faco_parte/app/modules/splash/splash_controller.dart';
// import 'package:lottie/lottie.dart';

// class SplashPage extends GetView<SplashController> {
//   const SplashPage({Key? key}) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: const BoxDecoration(
//           gradient: LinearGradient(
//               begin: Alignment.bottomRight,
//               end: Alignment.topLeft,
//               colors: [
//             Color.fromARGB(255, 255, 251, 247),
//             Color.fromARGB(255, 255, 205, 141),
//           ])),
//       child: Scaffold(
//         // backgroundColor: Get.theme.colorScheme.background,
//         backgroundColor: const Color(0xFFF7F7F7),

//         body: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 LottieBuilder.asset(
//                   'assets/lottie/splash_animate.json',
//                   repeat: false,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
