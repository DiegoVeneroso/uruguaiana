import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uruguaiana/app/core/ui/widgets/custom_picker.dart';
import 'package:uruguaiana/app/modules/proposal/proposal_actions/proposal_actions_controller.dart';
import 'package:validatorless/validatorless.dart';
import '../../../core/colors/services/theme_service.dart';
import '../../../core/ui/app_state.dart';
import '../../../core/ui/widgets/custom_appbar.dart';
import '../../../core/ui/widgets/custom_button.dart';
import '../../../core/ui/widgets/custom_player_video.dart';
import '../../../core/ui/widgets/custom_textformfield.dart';

class ProposalActionsAddPage extends StatefulWidget {
  const ProposalActionsAddPage({Key? key}) : super(key: key);

  @override
  State<ProposalActionsAddPage> createState() => _ProposalActionsAddPageState();
}

class _ProposalActionsAddPageState
    extends AppState<ProposalActionsAddPage, ProposalActionsController> {
  final _formKey = GlobalKey<FormState>();
  final _titleEC = TextEditingController();
  final _descriptionEC = TextEditingController();

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
                      'ADICIONAR AÇÃO',
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
                  // controller.imageFile == null
                  //     ? Container(
                  //         width: double.infinity,
                  //         height: 250,
                  //         decoration: BoxDecoration(
                  //           border: Border.all(
                  //             color: controller.imageValidate.value
                  //                 ? Get.theme.colorScheme.error
                  //                 : Get.theme.colorScheme.primary,
                  //           ),
                  //           borderRadius: BorderRadius.circular(20),
                  //           color: Get.theme.colorScheme.onPrimaryContainer,
                  //         ),
                  //         child: Column(
                  //           mainAxisAlignment: MainAxisAlignment.center,
                  //           children: [
                  //             Icon(
                  //               Icons.image_not_supported,
                  //               color: Get.theme.colorScheme.primary,
                  //               size: 80,
                  //             ),
                  //             Text(
                  //               'Sem mídia',
                  //               style: TextStyle(
                  //                   color: Get.theme.colorScheme.primary),
                  //             ),
                  //             const SizedBox(
                  //               height: 30,
                  //             ),
                  //             GestureDetector(
                  //               onTap: () {
                  //                 Get.defaultDialog(
                  //                   titlePadding:
                  //                       const EdgeInsets.only(top: 30),
                  //                   contentPadding: const EdgeInsets.only(
                  //                       top: 30, bottom: 20),
                  //                   title: 'Selecione a origem',
                  //                   backgroundColor: Get
                  //                       .theme.colorScheme.onPrimaryContainer,
                  //                   titleStyle: TextStyle(
                  //                       color: Get.theme.colorScheme.primary),
                  //                   content: Column(
                  //                     mainAxisAlignment:
                  //                         MainAxisAlignment.center,
                  //                     children: [
                  //                       CustomButton(
                  //                         label: 'Imagem da Galeria',
                  //                         height: 40,
                  //                         onPressed: () async {
                  //                           Get.back();
                  //                           Map<Permission, PermissionStatus>
                  //                               statuses = await [
                  //                             Permission.storage,
                  //                             Permission.camera,
                  //                           ].request();
                  //                           if (statuses[Permission.storage]!
                  //                                   .isGranted &&
                  //                               statuses[Permission.camera]!
                  //                                   .isGranted) {
                  //                             await controller
                  //                                 .pickImageFileFromGalery();
                  //                             setState(() {
                  //                               controller.imageFile;
                  //                             });
                  //                           } else {
                  //                             print('Permissão negada!');
                  //                           }
                  //                         },
                  //                       ),
                  //                       const SizedBox(
                  //                         width: 20,
                  //                       ),
                  //                       const SizedBox(
                  //                         height: 10,
                  //                       ),
                  //                       CustomButton(
                  //                         label: 'Foto da Câmera',
                  //                         height: 40,
                  //                         onPressed: () async {
                  //                           Get.back();
                  //                           Map<Permission, PermissionStatus>
                  //                               statuses = await [
                  //                             Permission.storage,
                  //                             Permission.camera,
                  //                           ].request();
                  //                           if (statuses[Permission.storage]!
                  //                                   .isGranted &&
                  //                               statuses[Permission.camera]!
                  //                                   .isGranted) {
                  //                             await controller
                  //                                 .captureImageFileFromCamera();
                  //                             setState(() {
                  //                               controller.imageFile;
                  //                             });
                  //                           } else {
                  //                             print('Permissão negada!');
                  //                           }
                  //                         },
                  //                       ),
                  //                       const SizedBox(
                  //                         height: 10,
                  //                       ),
                  //                       CustomButton(
                  //                         label: 'Vídeo da Galeria',
                  //                         height: 40,
                  //                         onPressed: () async {
                  //                           Get.back();
                  //                           Map<Permission, PermissionStatus>
                  //                               statuses = await [
                  //                             Permission.storage,
                  //                             Permission.camera,
                  //                           ].request();
                  //                           if (statuses[Permission.storage]!
                  //                                   .isGranted &&
                  //                               statuses[Permission.camera]!
                  //                                   .isGranted) {
                  //                             await controller
                  //                                 .pickVideoFileFromGalery();
                  //                             setState(() {
                  //                               controller.imageFile;
                  //                             });
                  //                           } else {
                  //                             print('Permissão negada!');
                  //                           }
                  //                         },
                  //                       ),
                  //                       const SizedBox(
                  //                         height: 10,
                  //                       ),
                  //                       CustomButton(
                  //                         label: 'Gravar video da Câmera',
                  //                         height: 40,
                  //                         onPressed: () async {
                  //                           Get.back();
                  //                           Map<Permission, PermissionStatus>
                  //                               statuses = await [
                  //                             Permission.storage,
                  //                             Permission.camera,
                  //                           ].request();
                  //                           if (statuses[Permission.storage]!
                  //                                   .isGranted &&
                  //                               statuses[Permission.camera]!
                  //                                   .isGranted) {
                  //                             await controller
                  //                                 .capturaVideoFileFromCamera();
                  //                             setState(() {
                  //                               controller.imageFile;
                  //                             });
                  //                           } else {
                  //                             print('Permissão negada!');
                  //                           }
                  //                         },
                  //                       ),
                  //                     ],
                  //                   ),
                  //                   radius: 20,
                  //                 );
                  //               },
                  //               child: Container(
                  //                 decoration: BoxDecoration(
                  //                   border: Border.all(
                  //                       color: Get.theme.colorScheme.primary),
                  //                   borderRadius: BorderRadius.circular(10),
                  //                 ),
                  //                 child: Padding(
                  //                   padding: const EdgeInsets.all(8.0),
                  //                   child: Text(
                  //                     'Adicionar',
                  //                     style: TextStyle(
                  //                         color: Get.theme.colorScheme.primary),
                  //                   ),
                  //                 ),
                  //               ),
                  //             ),
                  //           ],
                  //         ),
                  //       )
                  //     : controller.imageFile!.path.split(".").last == 'mp4'
                  //         ? Stack(
                  //             clipBehavior: Clip.none,
                  //             alignment: Alignment.center,
                  //             children: [
                  //               CustomPlayerVideo(
                  //                 videoUri:
                  //                     Uri.parse(controller.imageFile!.path),
                  //               ),
                  //               Positioned(
                  //                 right: 15,
                  //                 top: 15,
                  //                 child: GestureDetector(
                  //                   onTap: () {
                  //                     setState(() {
                  //                       controller.imageFile = null;
                  //                     });
                  //                   },
                  //                   child: Container(
                  //                     decoration: BoxDecoration(
                  //                       border: Border.all(
                  //                           color: Get.theme.colorScheme
                  //                               .onPrimaryContainer),
                  //                       borderRadius: BorderRadius.circular(10),
                  //                     ),
                  //                     child: Padding(
                  //                       padding: const EdgeInsets.all(8.0),
                  //                       child: Text(
                  //                         'Remover',
                  //                         style: TextStyle(
                  //                           color: Get.theme.colorScheme
                  //                               .onPrimaryContainer,
                  //                           fontWeight: FontWeight.bold,
                  //                         ),
                  //                       ),
                  //                     ),
                  //                   ),
                  //                 ),
                  //               ),
                  //             ],
                  //           )
                  //         : Stack(
                  //             clipBehavior: Clip.none,
                  //             alignment: Alignment.center,
                  //             children: [
                  //               Container(
                  //                 width: double.infinity,
                  //                 height: 250,
                  //                 decoration: BoxDecoration(
                  //                   border: Border.all(
                  //                       color: Get.theme.colorScheme.primary),
                  //                   borderRadius: BorderRadius.circular(20),
                  //                   image: DecorationImage(
                  //                     image: FileImage(
                  //                       File(controller.imageFile!.path),
                  //                     ),
                  //                     fit: BoxFit.fill,
                  //                   ),
                  //                 ),
                  //               ),
                  //               Positioned(
                  //                 right: 15,
                  //                 top: 15,
                  //                 child: GestureDetector(
                  //                   onTap: () {
                  //                     setState(() {
                  //                       controller.imageFile = null;
                  //                     });
                  //                   },
                  //                   child: Container(
                  //                     decoration: BoxDecoration(
                  //                       border: Border.all(
                  //                           color: Get.theme.colorScheme
                  //                               .onPrimaryContainer),
                  //                       borderRadius: BorderRadius.circular(10),
                  //                     ),
                  //                     child: Padding(
                  //                       padding: const EdgeInsets.all(8.0),
                  //                       child: Text(
                  //                         'Remover',
                  //                         style: TextStyle(
                  //                             color: Get.theme.colorScheme
                  //                                 .onPrimaryContainer),
                  //                       ),
                  //                     ),
                  //                   ),
                  //                 ),
                  //               ),
                  //             ],
                  //           ),
                  // Obx(
                  //   () => Visibility(
                  //     visible: controller.imageValidate.value,
                  //     child: Padding(
                  //       padding: const EdgeInsets.symmetric(
                  //           horizontal: 30, vertical: 8.0),
                  //       child: Row(
                  //         children: [
                  //           Text(
                  //             'midia é obrigatória',
                  //             style: TextStyle(
                  //               color: Get.theme.colorScheme.error,
                  //               fontSize: 12,
                  //             ),
                  //           )
                  //         ],
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  CustomPicker(
                    imageFile: controller.imageFile,
                    imageValidate: controller.imageValidate,
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

                        controller.imageValidate.value =
                            controller.imageFile == null ? true : false;
                        if (formValid &&
                            controller.imageValidate.value == false) {
                          controller.proposalActionAdd({
                            'title': _titleEC.text,
                            'url_image': controller.imageFile!.path,
                            'description': _descriptionEC.text,
                            'id_proposal_base':
                                Get.parameters['id_proposal_base'].toString(),
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
