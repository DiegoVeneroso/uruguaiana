import 'dart:io';

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

class HomeDetailPage extends StatefulWidget {
  const HomeDetailPage({Key? key}) : super(key: key);

  @override
  State<HomeDetailPage> createState() => _HomeDetailPageState();
}

class _HomeDetailPageState extends AppState<HomeDetailPage, HomeController> {
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
                    child: Text(
                      'Visualizar item',
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
                  const SizedBox(
                    height: 30,
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Row(
                          children: [
                            Text(
                              'Nome:',
                              style: TextStyle(
                                fontSize: 18,
                                color: Get.theme.colorScheme.surface,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              Get.parameters['name'].toString(),
                              style: TextStyle(
                                fontSize: 18,
                                color: Get.theme.colorScheme.surface,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Row(
                          children: [
                            Text(
                              'Cidade:',
                              style: TextStyle(
                                fontSize: 18,
                                color: Get.theme.colorScheme.surface,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              Get.parameters['cidade'].toString(),
                              style: TextStyle(
                                fontSize: 18,
                                color: Get.theme.colorScheme.surface,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
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
