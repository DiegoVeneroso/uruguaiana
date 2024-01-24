import 'package:eu_faco_parte/app/modules/question/question_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:validatorless/validatorless.dart';
import '../../core/colors/services/theme_service.dart';
import '../../core/ui/app_state.dart';
import '../../core/ui/widgets/custom_appbar.dart';
import '../../core/ui/widgets/custom_button.dart';
import '../../core/ui/widgets/custom_textformfield.dart';
import 'package:auto_size_text/auto_size_text.dart';

class QuestionAddPage extends StatefulWidget {
  const QuestionAddPage({Key? key}) : super(key: key);

  @override
  State<QuestionAddPage> createState() => _ProposalAddPageState();
}

class _ProposalAddPageState
    extends AppState<QuestionAddPage, QuestionController> {
  final _formKey = GlobalKey<FormState>();
  final _questionEC = TextEditingController();
  final _option1 = TextEditingController();
  final _option2 = TextEditingController();
  final _option3 = TextEditingController();
  final _option4 = TextEditingController();
  final _option5 = TextEditingController();

  @override
  void dispose() {
    _questionEC.dispose();
    _option1.dispose();
    _option2.dispose();
    _option3.dispose();
    _option4.dispose();
    _option5.dispose();
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
                    height: 15,
                  ),
                  Center(
                    child: AutoSizeText(
                      minFontSize: 10,
                      'CRIAR ENQUETE',
                      style: Get.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Get.theme.colorScheme.surface,
                        fontSize: 22,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Center(
                    child: AutoSizeText(
                      minFontSize: 10,
                      'Formule uma pergunta para a enquete.',
                      style: Get.textTheme.titleLarge?.copyWith(
                        color: Get.theme.colorScheme.surface,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomTextformfield(
                    label: 'Pergunta',
                    controller: _questionEC,
                    validator: Validatorless.required('Pergunta é obrigatório'),
                    maxlines: 3,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: AutoSizeText(
                      minFontSize: 10,
                      'Digite as opções de resposta.',
                      style: Get.textTheme.titleLarge?.copyWith(
                        color: Get.theme.colorScheme.surface,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomTextformfield(
                    label: 'Opção 1 (obrigatória)',
                    controller: _option1,
                    validator: Validatorless.required('Opção 1 é obrigatório'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomTextformfield(
                    label: 'Opção 2 (obrigatória)',
                    controller: _option2,
                    validator: Validatorless.required('Opção 2 é obrigatório'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomTextformfield(
                    label: 'Opção 3 (opcional)',
                    controller: _option3,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomTextformfield(
                    label: 'Opção 4 (opcional)',
                    controller: _option4,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomTextformfield(
                    label: 'Opção 5 (opcional)',
                    controller: _option5,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: CustomButton(
                      color: Get.theme.colorScheme.primaryContainer,
                      width: double.infinity,
                      label: 'CRIAR ENQUETE',
                      onPressed: () {
                        final formValid =
                            _formKey.currentState?.validate() ?? false;

                        if (formValid) {
                          controller.questionAdd({
                            'question': _questionEC.text,
                            'option_1': _option1.text,
                            'option_2': _option2.text,
                            'option_3': _option3.text,
                            'option_4': _option4.text,
                            'option_5': _option5.text,
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
