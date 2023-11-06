import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:validatorless/validatorless.dart';
import '../../../core/colors/services/theme_service.dart';
import '../../../core/ui/app_state.dart';
import '../../../core/ui/widgets/custom_button.dart';
import '../../../core/ui/widgets/custom_textformfield.dart';
import 'recovery_password_controller.dart';

class RecoveyPasswordPage extends StatefulWidget {
  const RecoveyPasswordPage({Key? key}) : super(key: key);

  @override
  State<RecoveyPasswordPage> createState() => _RecoveyPasswordPageState();
}

class _RecoveyPasswordPageState
    extends AppState<RecoveyPasswordPage, RecoveyPasswordController> {
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
        backgroundColor: Get.theme.colorScheme.background,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Get.theme.colorScheme.surface,
        ),
        actions: [
          IconButton(
            onPressed: ThemeService().switchTheme,
            icon: const Icon(Icons.contrast),
            color: Get.theme.colorScheme.surface,
          ),
        ],
      ),
      //
      body: LayoutBuilder(
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
                          'RECUPERAR SENHA',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Get.theme.colorScheme.surface,
                              fontSize: 22),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      CustomTextformfield(
                        label: 'E-mail cadastrado',
                        controller: _emailEC,
                        validator: Validatorless.multiple([
                          Validatorless.required('E-mail obrigatório'),
                          Validatorless.email('E-mail inválido'),
                        ]),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Center(
                        child: CustomButton(
                          color: Get.theme.colorScheme.primaryContainer,
                          width: double.infinity,
                          label: 'RECUPERAR SENHA',
                          onPressed: () {
                            final formValid =
                                _formKey.currentState?.validate() ?? false;
                            if (formValid) {
                              controller.recoveryPassword(email: _emailEC.text);
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
        },
      ),
    );
  }
}
