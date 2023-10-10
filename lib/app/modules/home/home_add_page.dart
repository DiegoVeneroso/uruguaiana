import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:uruguaiana/app/repository/home_repositories.dart';
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

  @override
  void dispose() {
    _nameEC.dispose();
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
                        style: context.textTheme.titleLarge?.copyWith(
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
                            await controller.pickImageFileFromGalery();
                            setState(() {
                              controller.imageFile;
                            });
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
                            await controller.captureImageFileFromCamera();
                            setState(() {
                              controller.imageFile;
                            });
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
                      height: 30,
                    ),
                    FutureBuilder(
                        future: HomeRepository().getDropdowClasse(),
                        builder: (context, snapshot) {
                          return Padding(
                            padding: const EdgeInsets.only(
                                top: 8.0, left: 8.0, right: 8.0, bottom: 8.0),
                            child: DropdownButtonFormField2(
                              style: const TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold),
                              decoration: InputDecoration(
                                isDense: true,
                                labelStyle: const TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold),
                                errorStyle: const TextStyle(
                                    color: Colors.redAccent,
                                    fontWeight: FontWeight.bold),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(23),
                                  borderSide:
                                      const BorderSide(color: Colors.blue),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(23),
                                  borderSide:
                                      const BorderSide(color: Colors.blue),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(23),
                                  borderSide:
                                      const BorderSide(color: Colors.blue),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                              isExpanded: true,
                              hint: const Text(
                                'Classe',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'mplus1',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue),
                              ),
                              icon: const Icon(
                                Icons.arrow_drop_down,
                                color: Colors.blue,
                              ),
                              iconSize: 30,
                              buttonHeight: 25,
                              buttonPadding:
                                  const EdgeInsets.only(left: 0, right: 10),
                              dropdownDecoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(23),
                              ),
                              items: snapshot.data,
                              validator: (value) {
                                if (value == null) {
                                  return 'Selecione a sua classe';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                setState(() {
                                  controller.valorSelecionadoClasse =
                                      value.toString();
                                });
                              },
                            ),
                          );
                        }),
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
                              });
                            } else {
                              controller.itemAdd({
                                'name': _nameEC.text,
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
