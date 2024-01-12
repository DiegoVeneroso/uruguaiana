import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:validatorless/validatorless.dart';

import '../../../core/colors/services/theme_service.dart';
import '../../../core/ui/app_state.dart';

import '../../../core/ui/widgets/custom_button.dart';
import '../../../core/ui/widgets/custom_textformfield.dart';
import 'login_controller.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends AppState<LoginPage, LoginController> {
  final _formKey = GlobalKey<FormState>();
  final _emailEC = TextEditingController();
  final _passwordEC = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _emailEC.dispose();
    _passwordEC.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.colorScheme.background,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Get.theme.colorScheme.surface),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: ThemeService().switchTheme,
            icon: const Icon(Icons.contrast),
            color: Get.theme.colorScheme.surface,
          ),
        ],
        backgroundColor: Get.theme.colorScheme.background,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (_, constraints) {
            return ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Center(
                        //   child: SizedBox(
                        //     width: 200,
                        //     height: 200,
                        //     child: Image.asset(
                        //       'assets/images/logo.png',
                        //       width: 80,
                        //     ),
                        //   ),
                        // ),
                        const SizedBox(
                          height: 50,
                        ),
                        AutoSizeText(
                          'ENTRAR',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Get.theme.colorScheme.surface,
                              fontSize: 22),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        CustomTextformfield(
                          label: 'E-mail',
                          controller: _emailEC,
                          validator: Validatorless.multiple([
                            Validatorless.required('E-mail obrigatório'),
                            Validatorless.email('E-mail inválido'),
                          ]),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        CustomTextformfield(
                          label: 'Senha',
                          obscureText: true,
                          visibility: true,
                          controller: _passwordEC,
                          validator: Validatorless.multiple([
                            Validatorless.required('Senha obrigatório'),
                            Validatorless.min(
                                8, 'Senha deve conter pelo menos 8 caracteres'),
                          ]),
                        ),
                        const SizedBox(
                          height: 35,
                        ),
                        Center(
                          child: CustomButton(
                            color: Get.theme.colorScheme.primaryContainer,
                            width: double.infinity,
                            label: 'ENTRAR',
                            onPressed: () {
                              final formValid =
                                  _formKey.currentState?.validate() ?? false;
                              if (formValid) {
                                controller.login(
                                  email: _emailEC.text,
                                  password: _passwordEC.text,
                                );
                              }
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Não possui uma conta?',
                              style: TextStyle(
                                  color: Get.theme.colorScheme.surface),
                            ),
                            TextButton(
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.all(5),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              onPressed: () {
                                controller.moveToRegister();
                              },
                              child: Text(
                                'Cadastre-se',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Get.theme.colorScheme.surface),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Esqueceu a senha?',
                              style: TextStyle(
                                  color: Get.theme.colorScheme.surface),
                            ),
                            TextButton(
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.all(5),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              onPressed: () {
                                controller.moveToRecoveryPassword();
                              },
                              child: Text(
                                'Recupere a senha',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Get.theme.colorScheme.surface),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
