import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eu_faco_parte/app/core/ui/widgets/custom_picker.dart';
import 'package:eu_faco_parte/app/modules/news/news_controller.dart';
import 'package:validatorless/validatorless.dart';
import '../../core/colors/services/theme_service.dart';
import '../../core/ui/app_state.dart';
import '../../core/ui/widgets/custom_appbar.dart';
import '../../core/ui/widgets/custom_button.dart';
import '../../core/ui/widgets/custom_textformfield.dart';
import 'package:auto_size_text/auto_size_text.dart';

class NewsAddPage extends StatefulWidget {
  const NewsAddPage({Key? key}) : super(key: key);

  @override
  State<NewsAddPage> createState() => _NewsAddPageState();
}

class _NewsAddPageState extends AppState<NewsAddPage, NewsController> {
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
              color: Get.theme.colorScheme.background,
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
                        'ADICIONAR NOTÍCIA',
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
                  CustomPicker(
                    key: _pickedKey,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomTextformfield(
                    label: 'Título',
                    controller: _titleEC,
                    validator: Validatorless.required('Título é obrigatório'),
                    maxlines: 2,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomTextformfield(
                    label: 'Descrição',
                    controller: _descriptionEC,
                    validator:
                        Validatorless.required('Descrição é obrigatório'),
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

                        final pickerValid =
                            _pickedKey.currentState?.imageFile?.path != null
                                ? true
                                : false;

                        _pickedKey.currentState
                            ?.setImageValidate(pickerValid.toString());

                        if (formValid & pickerValid) {
                          controller.newsAdd({
                            'title': _titleEC.text,
                            'url_image':
                                _pickedKey.currentState?.imageFile?.path,
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
