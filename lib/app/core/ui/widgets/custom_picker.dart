// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:uruguaiana/app/core/ui/widgets/custom_button.dart';

import 'custom_player_video.dart';

class CustomPicker extends StatefulWidget {
  XFile? imageFile;
  RxBool? imageValidate = false.obs;
  final FormFieldValidator<String>? validator;

  CustomPicker({
    Key? key,
    this.imageFile,
    this.imageValidate,
    this.validator,
  }) : super(key: key);

  @override
  State<CustomPicker> createState() => _CustomPickerState();
}

class _CustomPickerState extends State<CustomPicker> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        widget.imageFile == null
            ? Container(
                width: double.infinity,
                height: 250,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: widget.imageValidate!.value
                        ? Get.theme.colorScheme.error
                        : Get.theme.colorScheme.primary,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  color: Get.theme.colorScheme.onPrimaryContainer,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.image_not_supported,
                      color: Get.theme.colorScheme.primary,
                      size: 80,
                    ),
                    Text(
                      'Sem mídia',
                      style: TextStyle(color: Get.theme.colorScheme.primary),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.defaultDialog(
                          titlePadding: const EdgeInsets.only(top: 30),
                          contentPadding:
                              const EdgeInsets.only(top: 30, bottom: 20),
                          title: 'Selecione a origem',
                          backgroundColor:
                              Get.theme.colorScheme.onPrimaryContainer,
                          titleStyle:
                              TextStyle(color: Get.theme.colorScheme.primary),
                          content: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomButton(
                                label: 'Imagem da Galeria',
                                height: 40,
                                onPressed: () async {
                                  Get.back();
                                  Map<Permission, PermissionStatus> statuses =
                                      await [
                                    Permission.storage,
                                    Permission.camera,
                                  ].request();
                                  if (statuses[Permission.storage]!.isGranted &&
                                      statuses[Permission.camera]!.isGranted) {
                                    await pickImageFileFromGalery();
                                    setState(() {
                                      widget.imageFile;
                                    });
                                  } else {
                                    print('Permissão negada!');
                                  }
                                },
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              CustomButton(
                                label: 'Foto da Câmera',
                                height: 40,
                                onPressed: () async {
                                  Get.back();
                                  Map<Permission, PermissionStatus> statuses =
                                      await [
                                    Permission.storage,
                                    Permission.camera,
                                  ].request();
                                  if (statuses[Permission.storage]!.isGranted &&
                                      statuses[Permission.camera]!.isGranted) {
                                    await captureImageFileFromCamera();
                                    setState(() {
                                      widget.imageFile;
                                    });
                                  } else {
                                    print('Permissão negada!');
                                  }
                                },
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              CustomButton(
                                label: 'Vídeo da Galeria',
                                height: 40,
                                onPressed: () async {
                                  Get.back();
                                  Map<Permission, PermissionStatus> statuses =
                                      await [
                                    Permission.storage,
                                    Permission.camera,
                                  ].request();
                                  if (statuses[Permission.storage]!.isGranted &&
                                      statuses[Permission.camera]!.isGranted) {
                                    await pickVideoFileFromGalery();
                                    setState(() {
                                      widget.imageFile;
                                    });
                                  } else {
                                    print('Permissão negada!');
                                  }
                                },
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              CustomButton(
                                label: 'Gravar video da Câmera',
                                height: 40,
                                onPressed: () async {
                                  Get.back();
                                  Map<Permission, PermissionStatus> statuses =
                                      await [
                                    Permission.storage,
                                    Permission.camera,
                                  ].request();
                                  if (statuses[Permission.storage]!.isGranted &&
                                      statuses[Permission.camera]!.isGranted) {
                                    await capturaVideoFileFromCamera();
                                    setState(() {
                                      widget.imageFile;
                                    });
                                  } else {
                                    print('Permissão negada!');
                                  }
                                },
                              ),
                            ],
                          ),
                          radius: 20,
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border:
                              Border.all(color: Get.theme.colorScheme.primary),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Adicionar',
                            style:
                                TextStyle(color: Get.theme.colorScheme.primary),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : widget.imageFile!.path.split(".").last == 'mp4'
                ? Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.center,
                    children: [
                      CustomPlayerVideo(
                        videoUri: Uri.parse(widget.imageFile!.path),
                      ),
                      Positioned(
                        right: 15,
                        top: 15,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              widget.imageFile = null;
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color:
                                      Get.theme.colorScheme.onPrimaryContainer),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Remover',
                                style: TextStyle(
                                  color:
                                      Get.theme.colorScheme.onPrimaryContainer,
                                  fontWeight: FontWeight.bold,
                                ),
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
                      Container(
                        width: double.infinity,
                        height: 250,
                        decoration: BoxDecoration(
                          border:
                              Border.all(color: Get.theme.colorScheme.primary),
                          borderRadius: BorderRadius.circular(20),
                          image: DecorationImage(
                            image: FileImage(
                              File(widget.imageFile!.path),
                            ),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      Positioned(
                        right: 15,
                        top: 15,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              widget.imageFile = null;
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color:
                                      Get.theme.colorScheme.onPrimaryContainer),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Remover',
                                style: TextStyle(
                                    color: Get
                                        .theme.colorScheme.onPrimaryContainer),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
        Obx(
          () => Visibility(
            visible: widget.imageValidate!.value,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 30, vertical: 8.0),
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
      ],
    );
  }

  pickImageFileFromGalery() async {
    widget.imageFile = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 50);

    if (widget.imageFile != null) {
      await _cropImage(File(widget.imageFile!.path));
      // _message(
      //   MessageModel(
      //     title: 'Parabéns!',
      //     message: 'Imagem carregada!',
      //     type: MessageType.success,
      //   ),
      // );
    }
  }

  pickVideoFileFromGalery() async {
    widget.imageFile =
        await ImagePicker().pickVideo(source: ImageSource.gallery);

    // _message(
    //   MessageModel(
    //     title: 'Parabéns!',
    //     message: 'Video carregado!',
    //     type: MessageType.success,
    //   ),
    // );
  }

  capturaVideoFileFromCamera() async {
    widget.imageFile =
        await ImagePicker().pickVideo(source: ImageSource.camera);

    // _message(
    //   MessageModel(
    //     title: 'Parabéns!',
    //     message: 'Video carregado!',
    //     type: MessageType.success,
    //   ),
    // );
  }

  captureImageFileFromCamera() async {
    widget.imageFile = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 50);
    if (widget.imageFile != null) {
      await _cropImage(File(widget.imageFile!.path));
      // _message(
      //   MessageModel(
      //     title: 'Parabéns!',
      //     message: 'Imagem carregada!',
      //     type: MessageType.success,
      //   ),
      // );
    }
  }

  _cropImage(File imgFile) async {
    final croppedFile = await ImageCropper().cropImage(
        sourcePath: imgFile.path,
        aspectRatioPresets: Platform.isAndroid
            ? [CropAspectRatioPreset.ratio16x9]
            : [CropAspectRatioPreset.ratio16x9],
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: "Ajustar imagem",
            toolbarColor: Get.theme.colorScheme.primary,
            toolbarWidgetColor: Get.theme.colorScheme.onPrimaryContainer,
            initAspectRatio: CropAspectRatioPreset.ratio16x9,
            lockAspectRatio: true,
            activeControlsWidgetColor: Get.theme.colorScheme.primary,
            dimmedLayerColor: Get.theme.colorScheme.primary,
            showCropGrid: false,
          ),
          IOSUiSettings(
            title: "Ajustar imagem",
          )
        ]);
    if (croppedFile != null) {
      imageCache.clear();
      widget.imageFile = XFile(croppedFile.path);
    }
  }
}
