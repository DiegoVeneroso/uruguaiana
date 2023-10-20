import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uruguaiana/app/core/ui/widgets/custom_dropdown_button.dart';
import 'package:uruguaiana/app/modules/news/news_controller.dart';
import 'package:validatorless/validatorless.dart';
import '../../core/colors/services/theme_service.dart';
import '../../core/ui/app_state.dart';
import '../../core/ui/widgets/custom_appbar.dart';
import '../../core/ui/widgets/custom_button.dart';
import '../../core/ui/widgets/custom_textformfield.dart';

class NewsAddPage extends StatefulWidget {
  const NewsAddPage({Key? key}) : super(key: key);

  @override
  State<NewsAddPage> createState() => _NewsAddPageState();
}

class _NewsAddPageState extends AppState<NewsAddPage, NewsController> {
  final _formKey = GlobalKey<FormState>();
  final _nameEC = TextEditingController();
  final _telefoneEC = TextEditingController();

  @override
  void dispose() {
    _nameEC.dispose();
    _telefoneEC.dispose();
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
                    child: Text(
                      'Adicionar notícia',
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
                          child: Container(
                            width: double.infinity,
                            height: 250,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: const DecorationImage(
                                image: AssetImage(
                                    'assets/images/profile_avatar.png'),
                                fit: BoxFit.cover,
                              ),
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
                    height: 20,
                  ),
                  CustomTextformfield(
                    label: 'Título',
                    controller: _nameEC,
                    validator: Validatorless.required('Título é obrigatório'),
                    maxlines: 2,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomTextformfield(
                    label: 'Descrição',
                    controller: _telefoneEC,
                    validator:
                        Validatorless.required('Descrição é obrigatório'),
                    maxlines: 6,
                  ),
                  const SizedBox(
                    height: 30,
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
                            controller.itemAdd({
                              'name': _nameEC.text,
                              'imagePath': controller.imageFile!.path,
                              'cidade':
                                  controller.valorSelecionadoDropDown?.value,
                            });
                          } else {
                            controller.itemAdd({
                              'name': _nameEC.text,
                              'dropdownCidade':
                                  controller.valorSelecionadoDropDown?.value,
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
