import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uruguaiana/app/modules/notification/notification_controller.dart';
import 'package:validatorless/validatorless.dart';
import '../../core/colors/services/theme_service.dart';
import '../../core/ui/app_state.dart';
import '../../core/ui/widgets/custom_appbar.dart';
import '../../core/ui/widgets/custom_button.dart';
import '../../core/ui/widgets/custom_textformfield.dart';
import 'package:auto_size_text/auto_size_text.dart';

class NotificationAddPage extends StatefulWidget {
  const NotificationAddPage({Key? key}) : super(key: key);

  @override
  State<NotificationAddPage> createState() => _ProposalAddPageState();
}

class _ProposalAddPageState
    extends AppState<NotificationAddPage, NotificationController> {
  final _formKey = GlobalKey<FormState>();
  final _titleEC = TextEditingController();
  final _messageEC = TextEditingController();

  @override
  void dispose() {
    _titleEC.dispose();
    _messageEC.dispose();
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
          child: IntrinsicHeight(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: AutoSizeText(
                        minFontSize: 10,
                        'Enviar notificação',
                        style: Get.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Get.theme.colorScheme.surface,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    CustomTextformfield(
                      label: 'Título',
                      controller: _titleEC,
                      validator: Validatorless.required('Título é obrigatório'),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomTextformfield(
                      label: 'Mensagem',
                      controller: _messageEC,
                      validator:
                          Validatorless.required('Mensagem é obrigatório'),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: CustomButton(
                        color: Get.theme.colorScheme.primaryContainer,
                        width: double.infinity,
                        label: 'ENVIAR',
                        onPressed: () {
                          final formValid =
                              _formKey.currentState?.validate() ?? false;

                          if (formValid) {
                            controller.notificationsAdd({
                              'title': _titleEC.text,
                              'message': _messageEC.text,
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
      ),
    );
  }
}
