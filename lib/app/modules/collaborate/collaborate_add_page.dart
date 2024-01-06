import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:uruguaiana/app/modules/collaborate/collaborate_controller.dart';
import 'package:validatorless/validatorless.dart';
import '../../core/colors/services/theme_service.dart';
import '../../core/ui/app_state.dart';
import '../../core/ui/widgets/custom_appbar.dart';
import '../../core/ui/widgets/custom_button.dart';
import '../../core/ui/widgets/custom_picker.dart';
import '../../core/ui/widgets/custom_textformfield.dart';

class CollaborateAddPage extends StatefulWidget {
  const CollaborateAddPage({Key? key}) : super(key: key);

  @override
  State<CollaborateAddPage> createState() => _NewsAddPageState();
}

class _NewsAddPageState
    extends AppState<CollaborateAddPage, CollaborateController> {
  final _formKey = GlobalKey<FormState>();
  final _pickedKey = GlobalKey<CustomPickerState>();
  final _nameEC = TextEditingController();
  final _phoneEC = TextEditingController();
  final _descriptionEC = TextEditingController();

  @override
  void dispose() {
    _nameEC.dispose();
    _phoneEC.dispose();
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
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: AutoSizeText(
                        'CADASTRAR PROPOSTA',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Get.theme.colorScheme.surface,
                          fontSize: 22,
                        ),
                        minFontSize: 10,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  controller.addImageVisible.value
                      ? Obx(
                          () => Visibility(
                            visible: controller.addImageVisible.value,
                            child: CustomPicker(
                              key: _pickedKey,
                            ),
                          ),
                        )
                      : const SizedBox(),
                  const SizedBox(
                    height: 10,
                  ),
                  controller.addImageVisible.value == false
                      ? Obx(
                          () => Visibility(
                            visible: controller.addImageVisible.value == true,
                            child: Stack(children: [
                              CustomPicker(
                                key: _pickedKey,
                              ),
                              Positioned(
                                right: 15,
                                top: 15,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      controller.addImageVisible.value == false
                                          ? controller.addImageVisible.value =
                                              true
                                          : controller.addImageVisible.value =
                                              false;
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Get.theme.colorScheme
                                              .onPrimaryContainer),
                                      borderRadius: BorderRadius.circular(30),
                                      color: Get
                                          .theme.colorScheme.onPrimaryContainer,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Icon(
                                        Icons.close,
                                        color: Get
                                            .theme.colorScheme.primaryContainer,
                                        size: 30,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ]),
                          ),
                        )
                      : const SizedBox(),
                  controller.addImageVisible.value == false
                      ? Obx(
                          () => Visibility(
                              visible:
                                  controller.addImageVisible.value == false,
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(23),
                                  ),
                                  minimumSize: const Size.fromHeight(50),
                                  backgroundColor:
                                      Get.theme.colorScheme.onPrimaryContainer,
                                  side: BorderSide(
                                    width: 1,
                                    color: Get.theme.colorScheme.primary,
                                  ),
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.only(left: 15),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Adicionar imagem ou video',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ),
                                ),
                                onPressed: () {
                                  controller.addImageVisible.value == false
                                      ? controller.addImageVisible.value = true
                                      : controller.addImageVisible.value =
                                          false;
                                },
                              )),
                        )
                      : const SizedBox(),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomTextformfield(
                    label: 'Nome completo',
                    controller: _nameEC,
                    validator:
                        Validatorless.required('Nome completo é obrigatório'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomTextformfield(
                    label: 'Whatsapp',
                    controller: _phoneEC,
                    validator: Validatorless.required('Whatsapp é obrigatório'),
                    cellMask: true,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomTextformfield(
                    label: 'Descrição da proposta',
                    controller: _descriptionEC,
                    validator: Validatorless.required(
                        'Descrição da proposta é obrigatório'),
                    maxlines: 6,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: CustomButton(
                      color: Get.theme.colorScheme.primaryContainer,
                      width: double.infinity,
                      label: 'CADASTRAR',
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
                          controller.collaboratesAdd({
                            'name': _nameEC.text,
                            'phone': _phoneEC.text,
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
