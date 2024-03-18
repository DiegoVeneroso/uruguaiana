import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../modules/auth/login/login_controller.dart';
import '../../../repository/auth_repository.dart';

// ignore: must_be_immutable
class CustomFloatingButton extends StatelessWidget {
  LoginController controller = LoginController(AuthRepository());

  CustomFloatingButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: controller.getContactWhatsapp(),
        builder: (context, snap2) {
          if (snap2.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: Get.theme.colorScheme.primary,
              ),
            );
          }

          if (snap2.data!.documents.isEmpty) {
            return const SizedBox();
          } else {
            return Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Get.theme.colorScheme.onPrimaryContainer,
                          blurRadius: 10.0, // soften the shadow
                          spreadRadius: 4.0, //extend the shadow
                          offset: const Offset(
                            1.0, // Move to right 5  horizontally
                            1.0, // Move to bottom 5 Vertically
                          ),
                        )
                      ],
                      borderRadius: BorderRadius.circular(15.0),
                      color: Get.theme.colorScheme.primaryContainer,
                    ),
                    child: Row(
                      children: [
                        const Text(
                          ' Fale conosco',
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Icon(
                          FontAwesomeIcons.arrowRight,
                          color: Get.theme.colorScheme.onPrimaryContainer,
                          size: 18,
                        )
                      ],
                    )),
                SizedBox(
                  height: MediaQuery.of(context).size.width * 0.2,
                  width: MediaQuery.of(context).size.width * 0.2,
                  child: FloatingActionButton(
                    elevation: 0.0,
                    backgroundColor: Colors.transparent,
                    onPressed: () {
                      Uri url = Uri.parse(
                          snap2.data?.documents.first.data['url'] ?? '');
                      launchUrl(url);
                    },
                    child: LottieBuilder.asset('assets/lottie/whats.json'),
                  ),
                ),
              ],
            );
          }
        });
  }
}
