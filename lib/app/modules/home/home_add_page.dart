import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uruguaiana/app/core/ui/widgets/custom_dropdown_button.dart';
import 'package:validatorless/validatorless.dart';
import '../../core/ui/app_state.dart';
import '../../core/ui/widgets/custom_button.dart';
import '../../core/ui/widgets/custom_textformfield.dart';
import 'home_controller.dart';

class HomeAddPage extends StatefulWidget {
  const HomeAddPage({Key? key}) : super(key: key);

  @override
  State<HomeAddPage> createState() => _HomeAddPageState();
}

class _HomeAddPageState extends AppState<HomeAddPage, HomeController> {
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
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Realtime modelo'),
        ),
        backgroundColor: Colors.white,
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
                        'Adicionar item',
                        style: Get.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: context.theme.primaryColorDark),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    controller.imageFile == null
                        ? const Center(
                            child: CircleAvatar(
                              radius: 80,
                              backgroundImage: AssetImage(
                                  'assets/images/profile_avatar.jpg'),
                              backgroundColor: Colors.black,
                            ),
                          )
                        : Center(
                            child: Container(
                              width: 180,
                              height: 180,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.grey,
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
                              print('Permissão negada!');
                            }
                          },
                          icon: const Icon(
                            Icons.image_outlined,
                            color: Colors.grey,
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
                          icon: const Icon(
                            Icons.camera_alt_outlined,
                            color: Colors.grey,
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
                      label: 'Selecione a cidade',
                      futureListDropdown: controller.getDropdowValue(
                          labelAndColecctionList: 'Cidade'),
                      validator: Validatorless.required('Cidade é obrigatória'),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomTextformfield(
                      label: 'Telefone',
                      controller: _telefoneEC,
                      cellMask: true,
                      validator: Validatorless.required('Telefone Obrigatório'),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Center(
                      child: CustomButton(
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
                    const SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: CustomButton(
                        width: double.infinity,
                        label: 'VOLTAR',
                        onPressed: () {
                          Get.back();
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
