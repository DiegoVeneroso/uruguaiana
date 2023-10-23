import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uruguaiana/app/modules/collaborate/collaborate_controller.dart';
import 'package:validatorless/validatorless.dart';
import '../../core/colors/services/theme_service.dart';
import '../../core/ui/app_state.dart';
import '../../core/ui/widgets/custom_appbar.dart';
import '../../core/ui/widgets/custom_button.dart';
import '../../core/ui/widgets/custom_textformfield.dart';

class CollaborateAddPage extends StatefulWidget {
  const CollaborateAddPage({Key? key}) : super(key: key);

  @override
  State<CollaborateAddPage> createState() => _NewsAddPageState();
}

class _NewsAddPageState
    extends AppState<CollaborateAddPage, CollaborateController> {
  final _formKey = GlobalKey<FormState>();
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
    return Scaffold(
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
                    child: Text(
                      'Cadastrar proposta',
                      style: Get.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Get.theme.colorScheme.surface,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  controller.imageFile == null
                      ? Obx(
                          () => Visibility(
                            visible: controller.addImageVisible.value,
                            child: Center(
                              child: Container(
                                width: double.infinity,
                                height: 250,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Get.theme.colorScheme.primary,
                                ),
                                child: Icon(
                                  Icons.image_not_supported,
                                  color:
                                      Get.theme.colorScheme.onPrimaryContainer,
                                  size: 130,
                                ),
                              ),
                            ),
                          ),
                        )
                      : Obx(
                          () => Visibility(
                            visible: controller.addImageVisible.value,
                            child: Center(
                              child: Container(
                                width: double.infinity,
                                height: 250,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                    image: FileImage(
                                      File(controller.imageFile!.path),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                  Obx(
                    () => Visibility(
                      visible: controller.addImageVisible.value,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Get.theme.colorScheme.background),
                            ),
                            onPressed: () async {
                              Map<Permission, PermissionStatus> statuses =
                                  await [
                                Permission.storage,
                                Permission.camera,
                              ].request();
                              if (statuses[Permission.storage]!.isGranted &&
                                  statuses[Permission.camera]!.isGranted) {
                                await controller.pickImageFileFromGalery();
                                setState(() {
                                  controller.imageFile;
                                });
                              } else {
                                print('Permissão negada!');
                              }
                            },
                            child: Row(
                              children: [
                                Icon(
                                  Icons.image_outlined,
                                  color: Get.theme.colorScheme.surface,
                                  size: 30,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'Galeria',
                                    style: TextStyle(
                                        color: Get.theme.colorScheme.surface),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Text(
                            '|',
                            style: TextStyle(
                                color: Get.theme.colorScheme.surface,
                                fontWeight: FontWeight.bold,
                                fontSize: 30),
                          ),
                          TextButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Get.theme.colorScheme.background),
                            ),
                            onPressed: () async {
                              Map<Permission, PermissionStatus> statuses =
                                  await [
                                Permission.storage,
                                Permission.camera,
                              ].request();
                              if (statuses[Permission.storage]!.isGranted &&
                                  statuses[Permission.camera]!.isGranted) {
                                await controller.captureImageFileFromCamera();
                                setState(() {
                                  controller.imageFile;
                                });
                              } else {
                                print('Permissão negada!');
                              }
                            },
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'Câmera',
                                    style: TextStyle(
                                        color: Get.theme.colorScheme.surface),
                                  ),
                                ),
                                Icon(
                                  Icons.camera_alt_outlined,
                                  color: Get.theme.colorScheme.surface,
                                  size: 30,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Obx(
                    () => Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: TextButton(
                            onPressed: () {
                              controller.addImageVisible.value
                                  ? controller.addImageVisible.value = false
                                  : controller.addImageVisible.value = true;
                            },
                            child: controller.addImageVisible.value
                                ? const Text('Cancelar imagem')
                                : const Text('Adicionar imagem'),
                          ),
                        ),
                      ],
                    ),
                  ),
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
                    label: 'Telefone',
                    controller: _phoneEC,
                    validator: Validatorless.required('Telefone é obrigatório'),
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
                    maxlines: 10,
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
                        if (formValid) {
                          if (controller.imageFile != null) {
                            controller.collaboratesAdd({
                              'name': _nameEC.text,
                              'phone': _phoneEC.text,
                              'description': _descriptionEC.text,
                              'url_image': controller.imageFile!.path,
                            });
                          } else {
                            controller.collaboratesAdd({
                              'name': _nameEC.text,
                              'phone': _phoneEC.text,
                              'description': _descriptionEC.text,
                              'url_image': '',
                            });
                          }
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
