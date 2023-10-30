import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uruguaiana/app/modules/proposal/proposal_actions/proposal_actions_controller.dart';
import 'package:validatorless/validatorless.dart';
import '../../../core/colors/services/theme_service.dart';
import '../../../core/ui/app_state.dart';
import '../../../core/ui/widgets/custom_appbar.dart';
import '../../../core/ui/widgets/custom_button.dart';
import '../../../core/ui/widgets/custom_player_video.dart';
import '../../../core/ui/widgets/custom_textformfield.dart';

class ProposalActionsEditPage extends StatefulWidget {
  const ProposalActionsEditPage({Key? key}) : super(key: key);

  @override
  State<ProposalActionsEditPage> createState() =>
      _ProposalActionsEditPageState();
}

class _ProposalActionsEditPageState
    extends AppState<ProposalActionsEditPage, ProposalActionsController> {
  final _formKey = GlobalKey<FormState>();
  final _titleEC = TextEditingController(text: Get.parameters['title']);
  final _descriptionEC =
      TextEditingController(text: Get.parameters['description']);

  @override
  void dispose() {
    _titleEC.dispose();
    _descriptionEC.dispose();
    controller.imageFile = null;
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
                      'ALTERAR AÇÃO',
                      style: Get.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Get.theme.colorScheme.surface,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: Text(
                      Get.parameters['proposal_pilar_name'].toString(),
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
                      ? Stack(
                          clipBehavior: Clip.none,
                          alignment: Alignment.center,
                          children: [
                            CustomPlayerVideo(
                              videoUri: Uri.parse(
                                  Get.parameters['url_image'].toString()),
                            ),
                            Positioned(
                              right: 15,
                              top: 15,
                              child: GestureDetector(
                                onTap: () async {
                                  Map<Permission, PermissionStatus> statuses =
                                      await [
                                    Permission.storage,
                                    Permission.camera,
                                  ].request();
                                  if (statuses[Permission.storage]!.isGranted &&
                                      statuses[Permission.camera]!.isGranted) {
                                    await controller.pickVideoFileFromGalery();
                                    setState(() {
                                      controller.imageFile;
                                    });
                                  }
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Get.theme.colorScheme
                                            .onPrimaryContainer),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'Alterar',
                                      style: TextStyle(
                                          color: Get.theme.colorScheme
                                              .primaryContainer),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      : Stack(
                          clipBehavior: Clip.none,
                          alignment: Alignment.center,
                          children: [
                            CustomPlayerVideo(
                              videoUri: Uri.parse(controller.imageFile!.path),
                            ),
                            Positioned(
                              right: 15,
                              top: 15,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    controller.pickVideoFileFromGalery();
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Get.theme.colorScheme
                                            .onPrimaryContainer),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'Alterar',
                                      style: TextStyle(
                                          color: Get.theme.colorScheme
                                              .primaryContainer),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                  Obx(
                    () => Visibility(
                      visible: controller.imageValidate.value,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 8.0),
                        child: Row(
                          children: [
                            Text(
                              'midia é obrigatória',
                              style: TextStyle(
                                color: Get.theme.colorScheme.error,
                                fontSize: 12,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
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
                      label: 'ALTERAR',
                      onPressed: () {
                        final formValid =
                            _formKey.currentState?.validate() ?? false;

                        // controller.imageValidate.value =
                        //     controller.imageFile == null ? true : false;
                        controller.imageValidate.value =
                            Get.parameters['url_image'].toString() == null
                                ? true
                                : false;
                        if (formValid &&
                            controller.imageValidate.value == false) {
                          controller.proposalActionUpdate({
                            'title': _titleEC.text,
                            // 'url_image': controller.imageFile!.path,
                            'url_image': Get.parameters['url_image'].toString(),
                            'description': _descriptionEC.text,
                            'id_proposal_base':
                                Get.parameters['id_proposal_base'].toString(),
                            'id_proposal_action':
                                Get.parameters['id_proposal_action'].toString(),
                            'proposal_pilar_name': Get
                                .parameters['proposal_pilar_name']
                                .toString(),
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
