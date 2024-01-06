import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uruguaiana/app/modules/my_contact/my_contact_controller.dart';
import 'package:validatorless/validatorless.dart';
import '../../core/colors/services/theme_service.dart';
import '../../core/ui/app_state.dart';
import '../../core/ui/widgets/custom_appbar.dart';
import '../../core/ui/widgets/custom_button.dart';
import '../../core/ui/widgets/custom_textformfield.dart';
import 'package:auto_size_text/auto_size_text.dart';

class MyContactPage extends StatefulWidget {
  const MyContactPage({Key? key}) : super(key: key);

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
              color: Get.theme.colorScheme.onBackground,
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
                    label: 'Link do Facebook',
                    controller: _faceEC,
                    validator: Validatorless.required(
                        'Link do Facebook é obrigatório'),
                    maxlines: 2,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomTextformfield(
                    label: 'Link do Instagram',
                    controller: _instaEC,
                    validator: Validatorless.required(
                        'Link do Instagram é obrigatório'),
                    maxlines: 2,
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
                      label: 'SALVAR',
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
