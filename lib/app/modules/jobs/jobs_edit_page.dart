import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eu_faco_parte/app/core/ui/widgets/custom_picker.dart';
import 'package:eu_faco_parte/app/modules/jobs/jobs_controller.dart';
import 'package:validatorless/validatorless.dart';
import '../../core/colors/services/theme_service.dart';
import '../../core/ui/app_state.dart';
import '../../core/ui/widgets/custom_appbar.dart';
import '../../core/ui/widgets/custom_button.dart';
import '../../core/ui/widgets/custom_textformfield.dart';
import 'package:auto_size_text/auto_size_text.dart';

class JobsEditPage extends StatefulWidget {
  const JobsEditPage({Key? key}) : super(key: key);

  @override
  State<JobsEditPage> createState() => _NewsAddPageState();
}

class _NewsAddPageState extends AppState<JobsEditPage, JobsController> {
  final _formKey = GlobalKey<FormState>();
  final _pickedKeyAvatar = GlobalKey<CustomPickerState>();
  final _pickedKeyDocument = GlobalKey<CustomPickerState>();
  final _nameEC = TextEditingController();
  final _cpfEC = TextEditingController();
  final _phoneEC = TextEditingController();
  final _pixEC = TextEditingController();
  final _idadeEC = TextEditingController();
  final _numberIdentityEC = TextEditingController();
  final _addressEC = TextEditingController();
  final _initActivityEC = TextEditingController();

  @override
  void dispose() {
    _nameEC.dispose();
    _cpfEC.dispose();
    _phoneEC.dispose();
    _pixEC.dispose();
    _idadeEC.dispose();
    _numberIdentityEC.dispose();
    _addressEC.dispose();
    _numberIdentityEC.dispose();
    _initActivityEC.dispose();
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
                        'EDITAR TRABALHADOR',
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
                    key: _pickedKeyDocument,
                    label: 'Adicionar foto do trabalhador',
                    validatorMesssage: 'Foto do trabalhador é obrigatório',
                    pickerImageGalery: true,
                    pickerImageCamera: true,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomTextformfield(
                    label: 'Nome completo',
                    controller: _nameEC,
                    validator:
                        Validatorless.required('Nome completo é obrigatório'),
                    maxlines: 2,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomTextformfield(
                    label: 'Telefone',
                    controller: _cpfEC,
                    validator: Validatorless.required('Telefone é obrigatório'),
                    maxlines: 1,
                    cellMask: true,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomTextformfield(
                    label: 'Endereço',
                    controller: _addressEC,
                    validator: Validatorless.required('Endereço é obrigatório'),
                    maxlines: 2,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomTextformfield(
                    label: 'CPF',
                    controller: _cpfEC,
                    validator: Validatorless.required('CPF é obrigatório'),
                    maxlines: 1,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomTextformfield(
                    label: 'RG',
                    controller: _cpfEC,
                    validator: Validatorless.required('RG é obrigatório'),
                    maxlines: 1,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomTextformfield(
                    label: 'Idade',
                    controller: _phoneEC,
                    validator: Validatorless.required('Idade é obrigatório'),
                    maxlines: 1,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomTextformfield(
                    label: 'Início das atividades',
                    controller: _initActivityEC,
                    validator: Validatorless.required(
                        'Início das atividades é obrigatório'),
                    maxlines: 1,
                    dateMask: true,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomPicker(
                    key: _pickedKeyAvatar,
                    label: 'Adicionar foto do identidade',
                    validatorMesssage: 'Foto da identidade é obrigatório',
                    pickerImageCamera: true,
                    pickerImageGalery: true,
                  ),
                  const SizedBox(
                    height: 10,
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

                        final pickerValidAvatar =
                            _pickedKeyAvatar.currentState?.imageFile?.path !=
                                    null
                                ? true
                                : false;

                        final pickerValidDocument =
                            _pickedKeyDocument.currentState?.imageFile?.path !=
                                    null
                                ? true
                                : false;

                        _pickedKeyAvatar.currentState
                            ?.setImageValidate(pickerValidAvatar.toString());

                        _pickedKeyDocument.currentState
                            ?.setImageValidate(pickerValidDocument.toString());

                        if (formValid &
                            pickerValidAvatar &
                            pickerValidDocument) {
                          controller.jobsAdd({
                            'name': _nameEC.text,
                            'cpf': _cpfEC.text,
                            'phone': _phoneEC.text,
                            'idade': _idadeEC.text,
                            'url_image_avatar':
                                _pickedKeyAvatar.currentState?.imageFile?.path,
                            'url_image_a':
                                _pickedKeyAvatar.currentState?.imageFile?.path,
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
