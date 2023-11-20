// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:uruguaiana/app/core/helpers/video_compress_helper.dart';
import 'package:uruguaiana/app/core/ui/widgets/custom_button.dart';
import 'package:uruguaiana/app/core/ui/widgets/custom_progress_dialog.dart';
import 'package:video_compress/video_compress.dart';

import 'custom_player_video.dart';

class CustomPicker extends StatefulWidget {
  const CustomPicker({
    Key? key,
  }) : super(key: key);

  @override
  State<CustomPicker> createState() => CustomPickerState();
}

class CustomPickerState extends State<CustomPicker> {
  XFile? imageFile;
  RxString? imageValidate = ''.obs;
  MediaInfo? compressedVideoInfo;

  void setImageValidate(String value) {
    setState(() {
      imageValidate?.value = value;
    });
  }

  void setImageFile(String url) {
    setState(() {
      imageFile = XFile(url);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(
          () => Visibility(
            visible: imageFile == null && imageValidate?.value == '',
            child: Container(
              width: double.infinity,
              height: Get.size.height * 0.35,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Get.theme.colorScheme.primary,
                ),
                borderRadius: BorderRadius.circular(20),
                color: Get.theme.colorScheme.onPrimaryContainer,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.image_not_supported,
                      color: Get.theme.colorScheme.primary,
                      size: 80,
                    ),
                    AutoSizeText(
                      minFontSize: 10,
                      'Sem mídia',
                      style: TextStyle(
                          color: Get.theme.colorScheme.primary, fontSize: 16),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.defaultDialog(
                            titlePadding: const EdgeInsets.only(top: 30),
                            title: 'SELECIONE A MÍDIA',
                            backgroundColor:
                                Get.theme.colorScheme.onPrimaryContainer,
                            titleStyle:
                                TextStyle(color: Get.theme.colorScheme.primary),
                            content: Column(
                              children: [
                                Stack(alignment: Alignment.center, children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 20.0),
                                    child: Container(
                                      width: Get.width * 0.5,
                                      height: Get.height * 0.1,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Get.theme.colorScheme
                                              .primaryContainer,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    left: 20,
                                    top: 5,
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          imageFile = null;
                                          imageValidate?.value = '';
                                        });
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Get.theme.colorScheme
                                                  .onPrimaryContainer),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Get.theme.colorScheme
                                              .onPrimaryContainer,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: AutoSizeText(
                                            minFontSize: 10,
                                            'FOTO',
                                            style: TextStyle(
                                                color: Get
                                                    .theme.colorScheme.primary,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    left: 20,
                                    top: 50,
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          imageFile = null;
                                          imageValidate?.value = '';
                                        });
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Get.theme.colorScheme
                                                  .onPrimaryContainer),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Get.theme.colorScheme
                                              .onPrimaryContainer,
                                        ),
                                        child: Center(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              CustomButton(
                                                label: 'Galeria',
                                                height: 40,
                                                // width: 100,
                                                onPressed: () async {
                                                  Get.back();
                                                  Map<Permission,
                                                          PermissionStatus>
                                                      statuses = await [
                                                    Permission.storage,
                                                    Permission.camera,
                                                  ].request();
                                                  if (statuses[Permission
                                                              .storage]!
                                                          .isGranted &&
                                                      statuses[Permission
                                                              .camera]!
                                                          .isGranted) {
                                                    await pickImageFileFromGalery();
                                                    setState(() {
                                                      imageFile;
                                                    });
                                                  } else {
                                                    print('Permissão negada!');
                                                  }
                                                },
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              CustomButton(
                                                label: 'Câmera',
                                                height: 40,
                                                onPressed: () async {
                                                  Get.back();
                                                  Map<Permission,
                                                          PermissionStatus>
                                                      statuses = await [
                                                    Permission.storage,
                                                    Permission.camera,
                                                  ].request();
                                                  if (statuses[Permission
                                                              .storage]!
                                                          .isGranted &&
                                                      statuses[Permission
                                                              .camera]!
                                                          .isGranted) {
                                                    await captureImageFileFromCamera();
                                                    setState(() {
                                                      imageFile;
                                                    });
                                                  } else {
                                                    print('Permissão negada!');
                                                  }
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ]),
                                Stack(alignment: Alignment.center, children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 20.0),
                                    child: Container(
                                      width: Get.width * 0.5,
                                      height: Get.height * 0.1,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Get.theme.colorScheme
                                              .primaryContainer,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    left: 20,
                                    top: 5,
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          imageFile = null;
                                          imageValidate?.value = '';
                                        });
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Get.theme.colorScheme
                                                  .onPrimaryContainer),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Get.theme.colorScheme
                                              .onPrimaryContainer,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: AutoSizeText(
                                            minFontSize: 10,
                                            'VÍDEO',
                                            style: TextStyle(
                                                color: Get
                                                    .theme.colorScheme.primary,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    left: 20,
                                    top: 50,
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          imageFile = null;
                                          imageValidate?.value = '';
                                        });
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Get.theme.colorScheme
                                                  .onPrimaryContainer),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Get.theme.colorScheme
                                              .onPrimaryContainer,
                                        ),
                                        child: Center(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              CustomButton(
                                                label: 'Galeria',
                                                height: 40,
                                                // width: 200,
                                                onPressed: () async {
                                                  Get.back();
                                                  Map<Permission,
                                                          PermissionStatus>
                                                      statuses = await [
                                                    Permission.storage,
                                                    Permission.camera,
                                                  ].request();
                                                  if (statuses[Permission
                                                              .storage]!
                                                          .isGranted &&
                                                      statuses[Permission
                                                              .camera]!
                                                          .isGranted) {
                                                    await pickVideoFileFromGalery();
                                                    setState(() {
                                                      imageFile;
                                                    });
                                                  } else {
                                                    print('Permissão negada!');
                                                  }
                                                },
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              CustomButton(
                                                label: 'Câmera',
                                                height: 40,
                                                onPressed: () async {
                                                  Get.back();
                                                  Map<Permission,
                                                          PermissionStatus>
                                                      statuses = await [
                                                    Permission.storage,
                                                    Permission.camera,
                                                  ].request();
                                                  if (statuses[Permission
                                                              .storage]!
                                                          .isGranted &&
                                                      statuses[Permission
                                                              .camera]!
                                                          .isGranted) {
                                                    await capturaVideoFileFromCamera();
                                                    setState(() {
                                                      imageFile;
                                                    });
                                                  } else {
                                                    print('Permissão negada!');
                                                  }
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ]),
                              ],
                            ));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border:
                              Border.all(color: Get.theme.colorScheme.primary),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: AutoSizeText(
                            minFontSize: 10,
                            'Adicionar',
                            style: TextStyle(
                                color: Get.theme.colorScheme.primary,
                                fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Obx(
          () => Visibility(
            visible: imageFile == null && imageValidate!.value == 'false',
            child: Container(
              width: double.infinity,
              height: Get.size.height * 0.35,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Get.theme.colorScheme.error,
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
                  AutoSizeText(
                    minFontSize: 10,
                    'Sem mídia',
                    style: TextStyle(
                        color: Get.theme.colorScheme.primary, fontSize: 16),
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
                        title: 'Selecione a midia',
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
                                    imageFile;
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
                                    imageFile;
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
                                    imageFile;
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
                                    imageFile;
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
                        child: AutoSizeText(
                          minFontSize: 10,
                          'Adicionar',
                          style: TextStyle(
                            color: Get.theme.colorScheme.primary,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Visibility(
          visible:
              imageFile != null && imageFile?.path.split(".").last == 'mp4',
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              CustomPlayerVideo(
                videoUri: Uri.parse(imageFile?.path ?? ''),
              ),
              Positioned(
                right: 15,
                top: 15,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      imageFile = null;
                      imageValidate?.value = '';
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Get.theme.colorScheme.onPrimaryContainer),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: AutoSizeText(
                        minFontSize: 10,
                        'Remover',
                        style: TextStyle(
                            color: Get.theme.colorScheme.onPrimaryContainer,
                            fontWeight: FontWeight.bold,
                            fontSize: 14),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Visibility(
          visible:
              imageFile != null && imageFile?.path.split(".").last != 'mp4',
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              Container(
                width: double.infinity,
                height: Get.size.height * 0.35,
                decoration: BoxDecoration(
                  border: Border.all(color: Get.theme.colorScheme.primary),
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                    image: FileImage(
                      File(imageFile?.path ?? ''),
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
                      imageFile = null;
                      imageValidate?.value = '';
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Get.theme.colorScheme.onPrimaryContainer),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: AutoSizeText(
                        minFontSize: 10,
                        'Remover',
                        style: TextStyle(
                            color: Get.theme.colorScheme.onPrimaryContainer,
                            fontSize: 14),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Obx(
          () => Visibility(
            visible: imageFile == null && imageValidate!.value == 'false',
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 30, vertical: 8.0),
              child: Row(
                children: [
                  AutoSizeText(
                    minFontSize: 10,
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
    imageFile = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 30);

    if (imageFile != null) {
      await _cropImage(File(imageFile!.path));
    }
  }

  pickVideoFileFromGalery() async {
    imageFile = await ImagePicker().pickVideo(source: ImageSource.gallery);

    if (imageFile != null) {
      await compressVideo();
    }
  }

  capturaVideoFileFromCamera() async {
    imageFile = await ImagePicker().pickVideo(source: ImageSource.camera);
    if (imageFile != null) {
      await compressVideo();
    }
  }

  captureImageFileFromCamera() async {
    imageFile = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 30);

    if (imageFile != null) {
      await _cropImage(File(imageFile!.path));
    }
  }

  compressVideo() async {
    Get.dialog(
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60),
            child: Container(
              decoration: BoxDecoration(
                color: Get.theme.colorScheme.onPrimaryContainer,
                borderRadius: const BorderRadius.all(
                  Radius.circular(20),
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.all(20.0),
                child: Material(
                  child: Column(
                    children: [
                      SizedBox(height: 15),
                      CustomProgressDialog(),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );

    // showDialog(
    //   context: context,
    //   barrierDismissible: false,

    //   builder: (context) => const Dialog(
    //     child: CustomProgressDialog(),
    //   ),
    // );

    final info = await VideoCompressHelper.compressVideo(File(imageFile!.path));

    setState(() => compressedVideoInfo = info);

    // print('size');
    // print(compressedVideoInfo?.filesize);

    // print('compress');
    // print(compressedVideoInfo?.path.toString());
    imageFile = XFile(compressedVideoInfo!.path.toString());
    Navigator.of(context).pop();
  }

  _cropImage(File imgFile) async {
    final croppedFile = await ImageCropper().cropImage(
        sourcePath: imgFile.path,
        aspectRatioPresets: Platform.isAndroid
            ? [
                // CropAspectRatioPreset.original,
                // CropAspectRatioPreset.ratio16x9,
                // CropAspectRatioPreset.ratio7x5,
                // CropAspectRatioPreset.ratio4x3,
                // CropAspectRatioPreset.ratio5x3,
                // CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.ratio5x4,
              ]
            : [CropAspectRatioPreset.ratio5x4],
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: "RECORTAR IMAGEM",
            toolbarColor: Get.theme.colorScheme.primary,
            toolbarWidgetColor: Get.theme.colorScheme.onPrimaryContainer,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: true,
            activeControlsWidgetColor: Get.theme.colorScheme.primary,
            dimmedLayerColor: Get.theme.colorScheme.primary,
            showCropGrid: false,
          ),
          IOSUiSettings(
            title: "RECORTAR IMAGEM",
          )
        ]);
    if (croppedFile != null) {
      imageCache.clear();
      imageFile = XFile(croppedFile.path);
    }
  }
}
