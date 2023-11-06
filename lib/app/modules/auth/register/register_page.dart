import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:validatorless/validatorless.dart';
import '../../../core/colors/services/theme_service.dart';
import '../../../core/ui/app_state.dart';
import '../../../core/ui/widgets/custom_button.dart';
import '../../../core/ui/widgets/custom_textformfield.dart';
import 'register_controller.dart';
import 'package:auto_size_text/auto_size_text.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends AppState<RegisterPage, RegisterController> {
  final _formKey = GlobalKey<FormState>();
  final _nameEC = TextEditingController();
  final _emailEC = TextEditingController();
  final _passwordEC = TextEditingController();

  @override
  void dispose() {
    _nameEC.dispose();
    _emailEC.dispose();
    _passwordEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.colorScheme.background,
      appBar: AppBar(
        backgroundColor: Get.theme.colorScheme.background,
        iconTheme: IconThemeData(
          color: Get.theme.colorScheme.surface,
        ),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: ThemeService().switchTheme,
            icon: const Icon(Icons.contrast),
            color: Get.theme.colorScheme.surface,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: SizedBox(
                    width: 200,
                    height: 200,
                    child: Image.asset(
                      'assets/images/logo.png',
                      width: 80,
                    ),
                  ),
                ),
                Center(
                  child: AutoSizeText(
                    minFontSize: 10,
                    'CADASTRE-SE',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Get.theme.colorScheme.surface,
                      fontSize: 22,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomTextformfield(
                  label: 'Nome',
                  controller: _nameEC,
                  validator: Validatorless.required('Nome Obrigatório'),
                ),
                const SizedBox(
                  height: 15,
                ),
                CustomTextformfield(
                  label: 'E-mail',
                  controller: _emailEC,
                  validator: Validatorless.multiple([
                    Validatorless.required('E-mail obrigatório'),
                    Validatorless.email('E-mail inválido')
                  ]),
                ),
                const SizedBox(
                  height: 15,
                ),
                CustomTextformfield(
                  label: 'Senha',
                  controller: _passwordEC,
                  obscureText: true,
                  visibility: true,
                  validator: Validatorless.multiple([
                    Validatorless.required('Senha obrigatório'),
                    Validatorless.min(
                        8, 'Senha deve conter pelo menos 8 caracteres'),
                  ]),
                ),
                const SizedBox(
                  height: 15,
                ),
                CustomTextformfield(
                  label: 'Confirma senha',
                  obscureText: true,
                  visibility: true,
                  validator: Validatorless.multiple([
                    Validatorless.required('Confirma senha obrigatória'),
                    Validatorless.compare(
                        _passwordEC, 'Senha diferente de confirma senha'),
                  ]),
                ),
                const SizedBox(
                  height: 30,
                ),
                Center(
                  child: CustomButton(
                    color: Get.theme.colorScheme.primaryContainer,
                    width: double.infinity,
                    label: 'CADASTRAR',
                    onPressed: () {
                      final formValid =
                          _formKey.currentState?.validate() ?? false;
                      if (formValid) {
                        controller.register(
                          email: _emailEC.text,
                          password: _passwordEC.text,
                          name: _nameEC.text,
                        );
                      }
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
