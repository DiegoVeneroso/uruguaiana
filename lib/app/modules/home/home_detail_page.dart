import 'dart:io';

import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../core/colors/services/theme_service.dart';
import '../../core/ui/app_state.dart';
import '../../core/ui/widgets/custom_appbar.dart';
import 'home_controller.dart';
import 'package:auto_size_text/auto_size_text.dart';

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
                    child: AutoSizeText(
                      minFontSize: 10,
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
                            AutoSizeText(
                              minFontSize: 10,
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
                            AutoSizeText(
                              minFontSize: 10,
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
                            AutoSizeText(
                              minFontSize: 10,
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
                            AutoSizeText(
                              minFontSize: 10,
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
