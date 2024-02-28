import 'dart:developer';
import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:validatorless/validatorless.dart';
import '../../core/colors/services/theme_service.dart';
import '../../core/ui/app_state.dart';
import '../../core/ui/widgets/custom_appbar.dart';
import '../../core/ui/widgets/custom_button.dart';
import '../../core/ui/widgets/custom_dropdown_button.dart';
import '../../core/ui/widgets/custom_textformfield.dart';
import 'home_controller.dart';

class HomeEditPage extends StatefulWidget {
  const HomeEditPage({Key? key}) : super(key: key);

  @override
  State<HomeEditPage> createState() => _HomeAddPageState();
}

class _HomeAddPageState extends AppState<HomeEditPage, HomeController> {
  final _formKey = GlobalKey<FormState>();
  final _nameEC = TextEditingController(text: Get.parameters['name']);

  @override
  void dispose() {
    _nameEC.dispose();
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
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: AutoSizeText(
                      minFontSize: 10,
                      'Atualizar item',
                      style: Get.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Get.theme.colorScheme.surface,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  controller.imageFile == null
                      ? Center(
                          child: CircleAvatar(
                            radius: 80,
                            backgroundImage: NetworkImage(
                                Get.parameters['image'].toString()),
                            backgroundColor: Get.theme.colorScheme.primary,
                          ),
                        )
                      : Center(
                          child: Container(
                            width: 180,
                            height: 180,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Get.theme.colorScheme.primary,
                                image: DecorationImage(
                                  fit: BoxFit.fitHeight,
                                  image: FileImage(
                                    File(controller.imageFile!.path),
                                  ),
                                )),
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
                            log('Permissão negada!');
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
                            log('Permissão negada!');
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
                    height: 30,
                  ),
                  CustomTextformfield(
                    label: 'Nome',
                    controller: _nameEC,
                    validator: Validatorless.required('Nome Obrigatório'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomDropdownButton(
                    value: Get.parameters['cidade'].toString(),
                    futureListDropdown: controller.getDropdowValue(
                        labelAndColecctionList: 'Cidade'),
                    validator: Validatorless.required('Cidade é obrigatória'),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Center(
                    child: CustomButton(
                      color: Get.theme.colorScheme.primaryContainer,
                      width: double.infinity,
                      label: 'ATUALIZAR',
                      onPressed: () {
                        final formValid =
                            _formKey.currentState?.validate() ?? false;
                        if (formValid) {
                          controller.itemUpdate({
                            'id': Get.parameters['id'],
                            'name': _nameEC.text,
                            'imagePath': controller.imageFile == null
                                ? ''
                                : controller.imageFile!.path,
                            'cidade':
                                controller.valorSelecionadoDropDown?.value ??
                                    Get.parameters['cidade'],
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
