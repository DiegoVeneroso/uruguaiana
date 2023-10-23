import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uruguaiana/app/modules/about/about_controller.dart';
import 'package:validatorless/validatorless.dart';
import '../../core/colors/services/theme_service.dart';
import '../../core/ui/app_state.dart';
import '../../core/ui/widgets/custom_appbar.dart';
import '../../core/ui/widgets/custom_button.dart';
import '../../core/ui/widgets/custom_textformfield.dart';

class AboutAddPage extends StatefulWidget {
  const AboutAddPage({Key? key}) : super(key: key);

  @override
  State<AboutAddPage> createState() => _AboutAddPageState();
}

class _AboutAddPageState extends AppState<AboutAddPage, AboutController> {
  final _formKey = GlobalKey<FormState>();
  final _titleEC = TextEditingController();
  final _descriptionEC = TextEditingController();
  RxBool imageValidate = false.obs;

  @override
  void dispose() {
    _titleEC.dispose();
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
                      'Adicionar quem somos',
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
                      ? Center(
                          child: Container(
                            width: double.infinity,
                            height: 250,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: imageValidate.value
                                    ? Get.theme.colorScheme.error
                                    : Get.theme.colorScheme.primary,
                              ),
                              borderRadius: BorderRadius.circular(20),
                              color: Get.theme.colorScheme.onPrimaryContainer,
                            ),
                            child: Icon(
                              Icons.image_not_supported,
                              color: Get.theme.colorScheme.primary,
                              size: 130,
                            ),
                          ),
                        )
                      : Center(
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
                  Visibility(
                    visible: imageValidate.value,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 8.0),
                      child: Row(
                        children: [
                          Text(
                            'Imagem é obrigatória',
                            style: TextStyle(
                              color: Get.theme.colorScheme.error,
                              fontSize: 12,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () async {
                          Map<Permission, PermissionStatus> statuses = await [
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
                        icon: Icon(
                          Icons.image_outlined,
                          color: Get.theme.colorScheme.surface,
                          size: 30,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      IconButton(
                        onPressed: () async {
                          Map<Permission, PermissionStatus> statuses = await [
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
                        icon: Icon(
                          Icons.camera_alt_outlined,
                          color: Get.theme.colorScheme.surface,
                          size: 30,
                        ),
                      ),
                    ],
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
                        if (formValid) {
                          if (controller.imageFile != null) {
                            controller.aboutAdd({
                              'title': _titleEC.text,
                              'url_image': controller.imageFile!.path,
                              'description': _descriptionEC.text,
                            });
                          } else {
                            controller.aboutAdd({
                              'title': _titleEC.text,
                              'description': _descriptionEC.text,
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
