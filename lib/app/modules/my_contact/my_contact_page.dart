import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:eu_faco_parte/app/modules/auth/login/login_controller.dart';
import 'package:eu_faco_parte/app/modules/my_contact/my_contact_controller.dart';
import 'package:eu_faco_parte/app/repository/auth_repository.dart';
import 'package:eu_faco_parte/app/repository/my_contact_repositories.dart';
import 'package:validatorless/validatorless.dart';
import '../../core/colors/services/theme_service.dart';
import '../../core/ui/app_state.dart';
import '../../core/ui/widgets/custom_appbar.dart';
import '../../core/ui/widgets/custom_button.dart';
import '../../core/ui/widgets/custom_textformfield.dart';
import 'package:auto_size_text/auto_size_text.dart';

class MyContactPage extends StatefulWidget {
  const MyContactPage({super.key});

  @override
  State<MyContactPage> createState() => _MyContactPageState();
}

class _MyContactPageState extends AppState<MyContactPage, MyContactController> {
  final _formKey = GlobalKey<FormState>();
  final _faceEC = TextEditingController();
  final _instaEC = TextEditingController();
  final _whatsEC = TextEditingController();

  @override
  void dispose() {
    _faceEC.dispose();
    _instaEC.dispose();
    _whatsEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: context.theme.colorScheme.background,
        appBar: CustomAppbar(
          actionsList: [
            IconButton(
              onPressed: ThemeService().switchTheme,
              icon: const Icon(Icons.contrast),
              color: Get.theme.colorScheme.background,
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: AutoSizeText(
                      minFontSize: 10,
                      'Meus contatos',
                      style: Get.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Get.theme.colorScheme.surface,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomTextformfield(
                    label: 'ID do perfil do Facebook',
                    controller: _faceEC,
                    validator:
                        Validatorless.required('ID do Facebook é obrigatório'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomTextformfield(
                    label: 'Nome da conta do Instagram',
                    controller: _instaEC,
                    validator: Validatorless.required(
                        'Nome da conta do Instagram é obrigatório'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomTextformfield(
                    label: 'Whatsapp',
                    controller: _whatsEC,
                    validator: Validatorless.required('Whatsapp é obrigatório'),
                    cellMask: true,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: CustomButton(
                      color: Get.theme.colorScheme.primaryContainer,
                      width: double.infinity,
                      label: 'CADASTRAR CONTATOS',
                      onPressed: () {
                        final formValid =
                            _formKey.currentState?.validate() ?? false;

                        if (formValid) {
                          controller.myContactAdd({
                            'facebook': _faceEC.text,
                            'instagram': _instaEC.text,
                            'whatsapp': _whatsEC.text,
                          });
                        }
                      },
                    ),
                  ),
                  FutureBuilder(
                    future: controller.getContactFacebook(),
                    builder: (context, snap2) {
                      if (snap2.connectionState == ConnectionState.waiting) {
                        return const SizedBox();
                      }

                      if (snap2.data!.documents.isEmpty) {
                        return const SizedBox();
                      } else {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            const Padding(
                              padding: EdgeInsets.all(12.0),
                              child: Divider(),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Center(
                              child: AutoSizeText(
                                minFontSize: 10,
                                'Teste os icones de contato',
                                style: Get.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Get.theme.colorScheme.surface,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        );
                      }
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FutureBuilder(
                        future: controller.getContactFacebook(),
                        builder: (context, snap2) {
                          if (snap2.connectionState ==
                              ConnectionState.waiting) {
                            return const SizedBox();
                          }

                          if (snap2.data!.documents.isEmpty) {
                            return const SizedBox();
                          } else {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    Uri url = Uri.parse(snap2.data?.documents
                                            .first.data['url'] ??
                                        '');
                                    launchUrl(url);
                                  },
                                  icon: const Icon(FontAwesomeIcons.facebook),
                                  iconSize: 40,
                                  color: Get.theme.colorScheme.primary,
                                ),
                              ],
                            );
                          }
                        },
                      ),
                      FutureBuilder(
                        future: controller.getContactInstagram(),
                        builder: (context, snap3) {
                          if (snap3.connectionState ==
                              ConnectionState.waiting) {
                            return const SizedBox();
                          }

                          if (snap3.data!.documents.isEmpty) {
                            return const SizedBox();
                          } else {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    Uri url = Uri.parse(snap3.data?.documents
                                            .first.data['url'] ??
                                        '');
                                    launchUrl(url);
                                  },
                                  icon: const Icon(FontAwesomeIcons.instagram),
                                  iconSize: 40,
                                  color: Get.theme.colorScheme.primary,
                                ),
                              ],
                            );
                          }
                        },
                      ),
                      FutureBuilder(
                        future: controller.getContactWhatsapp(),
                        builder: (context, snap4) {
                          if (snap4.connectionState ==
                              ConnectionState.waiting) {
                            return const SizedBox();
                          }

                          if (snap4.data!.documents.isEmpty) {
                            return const SizedBox();
                          } else {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    Uri url = Uri.parse(snap4.data?.documents
                                            .first.data['url'] ??
                                        '');
                                    launchUrl(url);
                                  },
                                  icon: const Icon(FontAwesomeIcons.whatsapp),
                                  iconSize: 40,
                                  color: Get.theme.colorScheme.primary,
                                ),
                              ],
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
