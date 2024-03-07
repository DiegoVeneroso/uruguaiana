import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:eu_faco_parte/app/core/helpers/video_compress_helper.dart';
import 'package:eu_faco_parte/app/core/ui/widgets/custom_button.dart';
import 'package:eu_faco_parte/app/core/ui/widgets/custom_progress_dialog.dart';
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

  bool isStoragePermission = true;
  bool isVideosPermission = true;
  bool isPhotosPermission = true;

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

  Future<void> storageCheck() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      if (androidInfo.version.sdkInt >= 33) {
        isVideosPermission = await Permission.videos.status.isGranted;
        isPhotosPermission = await Permission.photos.status.isGranted;
      } else {
        isStoragePermission = await Permission.storage.status.isGranted;
      }
    } else {
      isVideosPermission = await Permission.videos.status.isGranted;
      isPhotosPermission = await Permission.photos.status.isGranted;
      isStoragePermission = await Permission.storage.status.isGranted;
    }
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
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.image_not_supported,
                        color: Get.theme.colorScheme.primary,
                        size: 60,
                      ),
                      AutoSizeText(
                        minFontSize: 10,
                        'Sem mídia',
                        style: TextStyle(
                            color: Get.theme.colorScheme.primary, fontSize: 16),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.defaultDialog(
                              titlePadding:
                                  const EdgeInsets.only(top: 15, bottom: 10),
                              title: 'SELECIONE',
                              backgroundColor:
                                  Get.theme.colorScheme.onPrimaryContainer,
                              titleStyle: TextStyle(
                                  color: Get.theme.colorScheme.primary,
                                  fontSize: 20),
                              content: Column(
                                children: [
                                  Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        CustomButton(
                                          label: 'Foto da Galeria',
                                          height: 40,
                                          width: Get.width * .50,
                                          onPressed: () async {
                                            Get.back();
                                            await storageCheck();

                                            if (isStoragePermission &&
                                                isVideosPermission &&
                                                isPhotosPermission) {
                                            } else {
                                              await pickImageFileFromGalery();
                                              setState(
                                                () {
                                                  imageFile;
                                                },
                                              );
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        imageFile = null;
                                        imageValidate?.value = '';
                                      });
                                    },
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          CustomButton(
                                            label: 'Video da Galeria',
                                            height: 40,
                                            width: Get.width * .50,
                                            onPressed: () async {
                                              Get.back();

                                              await storageCheck();

                                              if (isStoragePermission &&
                                                  isVideosPermission &&
                                                  isPhotosPermission) {
                                              } else {
                                                await pickVideoFileFromGalery();
                                                setState(
                                                  () {
                                                    imageFile;
                                                  },
                                                );
                                              }
                                            },
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          CustomButton(
                                            label: 'Tirar Foto',
                                            height: 40,
                                            width: Get.width * .50,
                                            onPressed: () async {
                                              Get.back();

                                              await storageCheck();

                                              if (isStoragePermission &&
                                                  isVideosPermission &&
                                                  isPhotosPermission) {
                                              } else {
                                                await captureImageFileFromCamera();
                                                setState(
                                                  () {
                                                    imageFile;
                                                  },
                                                );
                                              }
                                            },
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          CustomButton(
                                            label: 'Gravar video',
                                            height: 40,
                                            width: Get.width * .50,
                                            onPressed: () async {
                                              Get.back();

                                              await storageCheck();

                                              if (isStoragePermission &&
                                                  isVideosPermission &&
                                                  isPhotosPermission) {
                                              } else {
                                                await capturaVideoFileFromCamera();
                                                setState(
                                                  () {
                                                    imageFile;
                                                  },
                                                );
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ));
                        },
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Get.theme.colorScheme.primary),
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
                                await storageCheck();

                                if (isStoragePermission &&
                                    isVideosPermission &&
                                    isPhotosPermission) {
                                } else {
                                  await pickImageFileFromGalery();
                                  setState(
                                    () {
                                      imageFile;
                                    },
                                  );
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

                                await storageCheck();

                                if (isStoragePermission &&
                                    isVideosPermission &&
                                    isPhotosPermission) {
                                } else {
                                  await captureImageFileFromCamera();
                                  setState(
                                    () {
                                      imageFile;
                                    },
                                  );
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

                                await storageCheck();

                                if (isStoragePermission &&
                                    isVideosPermission &&
                                    isPhotosPermission) {
                                } else {
                                  await pickVideoFileFromGalery();
                                  setState(
                                    () {
                                      imageFile;
                                    },
                                  );
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

                                await storageCheck();

                                if (isStoragePermission &&
                                    isVideosPermission &&
                                    isPhotosPermission) {
                                } else {
                                  await capturaVideoFileFromCamera();
                                  setState(
                                    () {
                                      imageFile;
                                    },
                                  );
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
    await compressVideo();
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

    final info = await VideoCompressHelper.compressVideo(File(imageFile!.path));

    setState(() => compressedVideoInfo = info);

    imageFile = XFile(compressedVideoInfo!.path.toString());
    Navigator.of(context).pop();
  }

  _cropImage(File imgFile) async {
    final croppedFile = await ImageCropper().cropImage(
        sourcePath: imgFile.path,
        compressFormat: ImageCompressFormat.png,
        compressQuality: 50,
        aspectRatioPresets: Platform.isAndroid
            ? [
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
