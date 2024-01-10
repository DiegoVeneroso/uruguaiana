import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uruguaiana/app/modules/dev_contact/dev_contact_controller.dart';
import 'package:uruguaiana/app/routes/app_pages.dart';
import 'package:validatorless/validatorless.dart';
import '../../core/colors/services/theme_service.dart';
import '../../core/ui/app_state.dart';
import '../../core/ui/widgets/custom_appbar.dart';
import '../../core/ui/widgets/custom_button.dart';
import '../../core/ui/widgets/custom_textformfield.dart';
import 'package:auto_size_text/auto_size_text.dart';

class DevContactPage extends StatefulWidget {
  const DevContactPage({super.key});

  @override
  State<DevContactPage> createState() => _DevContactPageState();
}

class _DevContactPageState
    extends AppState<DevContactPage, DevContactController> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: context.theme.colorScheme.background,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: Get.height * .30,
                ),
                AutoSizeText(
                  minFontSize: 16,
                  'ATENÇÃO',
                  style: Get.textTheme.titleLarge?.copyWith(
                      color: Get.theme.colorScheme.surface,
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: RichText(
                    text: TextSpan(
                      text:
                          'Entre em contato com o desenvolvedor para ter acesso liberado como administrador do sistema.',
                      style: TextStyle(
                        color: Get.theme.colorScheme.surface,
                        fontSize: 20,
                      ),
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Center(
                  child: CustomButton(
                    color: Get.theme.colorScheme.primaryContainer,
                    width: Get.width * .8,
                    label: 'SOLICITAR ACESSO',
                    onPressed: () {
                      var message = Uri.encodeFull(
                          'Olá, gostaria de liberação de acesso como administrador para o e-mail ${Get.parameters['email']}');
                      Uri url = Uri.parse(
                          'https://wa.me/5555984598383?text=$message');
                      launchUrl(url);
                    },
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: CustomButton(
                    color: Get.theme.colorScheme.primaryContainer,
                    width: Get.width * .8,
                    label: 'ENTRAR',
                    onPressed: () {
                      Get.offAndToNamed(Routes.login);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
