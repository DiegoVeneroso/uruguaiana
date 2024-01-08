import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uruguaiana/app/core/ui/widgets/custom_picker.dart';
import 'package:uruguaiana/app/modules/about/about_controller.dart';
import 'package:uruguaiana/app/modules/term_of_use/term_of_use_controller.dart';
import 'package:validatorless/validatorless.dart';
import '../../core/colors/services/theme_service.dart';
import '../../core/ui/app_state.dart';
import '../../core/ui/widgets/custom_appbar.dart';
import '../../core/ui/widgets/custom_button.dart';
import '../../core/ui/widgets/custom_textformfield.dart';
import 'package:auto_size_text/auto_size_text.dart';

class TermOfUseAddPage extends StatefulWidget {
  const TermOfUseAddPage({Key? key}) : super(key: key);

  @override
  State<TermOfUseAddPage> createState() => _TermOfUseAddPageState();
}

class _TermOfUseAddPageState
    extends AppState<TermOfUseAddPage, TermOfUseController> {
  final _formKey = GlobalKey<FormState>();
  final _pickedKey = GlobalKey<CustomPickerState>();
  final _titleEC = TextEditingController();
  final _descriptionEC = TextEditingController();

  @override
  void dispose() {
    _titleEC.dispose();
    _descriptionEC.dispose();
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
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Center(
                      child: AutoSizeText(
                        minFontSize: 10,
                        'CADASTRAR TERMO DE USO',
                        style: Get.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Get.theme.colorScheme.surface,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomTextformfield(
                    label: 'Termo de uso',
                    controller: _descriptionEC,
                    validator:
                        Validatorless.required('Termo de uso é obrigatório'),
                    maxlines: 10,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: CustomButton(
                      color: Get.theme.colorScheme.primaryContainer,
                      width: double.infinity,
                      label: 'ADICIONAR',
                      onPressed: () {
                        final formValid =
                            _formKey.currentState?.validate() ?? false;

                        if (formValid) {
                          controller.termOfUseAdd({
                            'description': _descriptionEC.text,
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
