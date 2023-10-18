// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';
import 'dart:io';

import 'package:appwrite/appwrite.dart' hide Permission;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/config/api_client.dart';
import '../../core/config/constants.dart' as constants;
import '../../core/mixins/dialog_mixin.dart';
import '../../core/mixins/loader_mixin.dart';
import '../../core/mixins/messages_mixin.dart';
import '../../models/item_model.dart';
import '../../repository/home_repositories.dart';

class HomeController extends GetxController
    with LoaderMixin, MessagesMixin, DialogMixin {
  RealtimeSubscription? subscription;
  HomeRepository repository;
  final _loading = false.obs;
  final _message = Rxn<MessageModel>();
  final _dialog = Rxn<DialogModel>();
  var itemList = <ItemModel>[].obs;
  Rx<List<ItemModel>> foundItem = Rx<List<ItemModel>>([]);
  RxList<DropdownMenuItem<String>> listDropdown =
      <DropdownMenuItem<String>>[].obs;

  late Rx<File?> pickedFile;
  File? get profileImage => pickedFile.value;
  XFile? imageFile;

  RxString? valorSelecionadoDropDown = ''.obs;

  RxBool searchVisible = false.obs;

  var isDarkMode = false.obs;

  HomeController({
    required this.repository,
  });

  @override
  onInit() {
    loaderListener(_loading);
    messageListener(_message);
    dialogListener(_dialog);
    foundItem.value = itemList;
    notificationPush();
    super.onInit();
  }

  @override
  onReady() {
    // login();

    subscribe();
    loadData();

    super.onReady();
  }

  notificationPush() {
    FirebaseMessaging.onMessage.listen((message) async {
      print(message.data.values
          .toString()); //recebe o valor dos dados personalidados da notificação

      if (message.notification != null) {
        Get.snackbar(
          onTap: (snack) {
            // Get.toNamed('/noticias');
          },
          message.notification!.title.toString(),
          message.notification!.body.toString(),
          backgroundColor: Colors.blue,
          colorText: Colors.white,
          margin: const EdgeInsets.all(20),
        );
      }
    });
  }

  pickImageFileFromGalery() async {
    imageFile = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 50);
    if (imageFile != null) {
      await _cropImage(File(imageFile!.path));
      _message(
        MessageModel(
          title: 'Parabéns!',
          message: 'Imagem adicionada!',
          type: MessageType.success,
        ),
      );
    }
  }

  captureImageFileFromCamera() async {
    imageFile = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 50);
    if (imageFile != null) {
      await _cropImage(File(imageFile!.path));
      _message(
        MessageModel(
          title: 'Parabéns!',
          message: 'Imagem adicionada!',
          type: MessageType.success,
        ),
      );
    }
  }

  _cropImage(File imgFile) async {
    final croppedFile = await ImageCropper().cropImage(
        sourcePath: imgFile.path,
        aspectRatioPresets: Platform.isAndroid
            ? [
                // CropAspectRatioPreset.square,
                // CropAspectRatioPreset.ratio3x2,
                // CropAspectRatioPreset.original,
                CropAspectRatioPreset.ratio4x3,
                // CropAspectRatioPreset.ratio16x9
              ]
            : [
                // CropAspectRatioPreset.original,
                // CropAspectRatioPreset.square,
                // CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.ratio4x3,
                // CropAspectRatioPreset.ratio5x3,
                // CropAspectRatioPreset.ratio5x4,
                // CropAspectRatioPreset.ratio7x5,
                // CropAspectRatioPreset.ratio16x9
              ],
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: "Ajustar imagem",
            toolbarColor: Get.theme.colorScheme.primary,
            toolbarWidgetColor: Get.theme.colorScheme.onPrimaryContainer,
            initAspectRatio: CropAspectRatioPreset.ratio4x3,
            lockAspectRatio: true,
            // hideBottomControls: true,
            // statusBarColor: Get.theme.colorScheme.primary,
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
      imageFile = XFile(croppedFile.path);
    }
  }

  getDialog({
    required String idItem,
    required String item,
  }) {
    _dialog(DialogModel(
      id: idItem,
      title: 'Atenção',
      message: 'Deseja realmente excluir o item?\n$item',
    ));
  }

  void filterItem(String itemName) {
    List<ItemModel> results = [];
    if (itemName.isEmpty) {
      // _loading.toggle();
      results = itemList;
    } else {
      // _loading.toggle();
      results = itemList
          .where((element) => element.name
              .toString()
              .toLowerCase()
              .contains(itemName.toLowerCase()))
          .toList();
    }
    // _loading.toggle();
    foundItem.value = results;
  }

  // login() async {
  //   try {
  //     _loading.toggle();
  //     await ApiClient.account.createAnonymousSession();
  //     print('usuario anonimo logado!');
  //   } on AppwriteException catch (e) {
  //     _loading.toggle();
  //     print(e.message);
  //   }
  // }

  void loadData() async {
    try {
      var result = await repository.loadDataRepository();

      itemList.assignAll(result);
    } catch (e) {
      _loading.toggle();
      _message(
        MessageModel(
          title: 'Atenção!',
          message: 'Erro ao adicionar!',
          type: MessageType.success,
        ),
      );
    }
  }

  void subscribe() {
    final realtime = Realtime(ApiClient.account.client);

    subscription = realtime.subscribe([
      'databases.${constants.DATABASE_ID}.collections.${constants.COLLETION_ITEM_ID}.documents'
    ]);

    subscription!.stream.listen((data) {
      for (var ev in data.events) {
        switch (ev) {
          case "databases.*.collections.*.documents.*.create":
            loadData();
            break;
          case "databases.*.collections.*.documents.*.update":
            loadData();
            break;
          case "databases.*.collections.*.documents.*.delete":
            loadData();
            break;
          default:
            break;
        }
      }
    });
  }

  Future<void> itemAdd(Map map) async {
    try {
      _loading.toggle();

      await repository.itemAddRepository(map);

      await Future.delayed(const Duration(seconds: 1));
      _loading.toggle();
      Get.offAndToNamed('/home');
      _message(
        MessageModel(
          title: 'Parabéns!',
          message: 'Item adicionado com sucesso!',
          type: MessageType.success,
        ),
      );
    } catch (e) {
      print(e.toString());

      _message(
        MessageModel(
          title: 'Atenção!',
          message: e.toString(),
          type: MessageType.error,
        ),
      );
      await Future.delayed(const Duration(seconds: 2));
      _loading.toggle();
      Get.offAndToNamed('/home');
    }
  }

  Future itemDelete(String idItem) async {
    try {
      Get.back();
      _loading.toggle();

      await repository.itemDeleteRepository(idItem);

      _loading.toggle();
      await Future.delayed(const Duration(seconds: 1));
      Get.snackbar(
        'Atenção!',
        'Item excluído com sucesso!',
        backgroundColor: Colors.red[800]!,
        colorText: Colors.white,
        margin: const EdgeInsets.all(20),
      );
    } catch (e) {
      print(e.toString());

      _message(
        MessageModel(
          title: 'Atenção!',
          message: e.toString(),
          type: MessageType.error,
        ),
      );
      await Future.delayed(const Duration(seconds: 2));
      _loading.toggle();
      Get.offAndToNamed('/home');
    }
  }

  Future<void> itemUpdate(Map map) async {
    try {
      _loading.toggle();

      await repository.itemUpdateRepository(map);

      await Future.delayed(const Duration(seconds: 1));
      _loading.toggle();
      Get.offAndToNamed('/home');
      _message(
        MessageModel(
          title: 'Parabéns!',
          message: 'Item atualizado com sucesso!',
          type: MessageType.success,
        ),
      );
    } catch (e) {
      print(e.toString());

      _message(
        MessageModel(
          title: 'Atenção!',
          message: e.toString(),
          type: MessageType.error,
        ),
      );
      await Future.delayed(const Duration(seconds: 2));
      _loading.toggle();
      Get.offAndToNamed('/home');
    }
  }

  Future<List<DropdownMenuItem<String>>> getDropdowValue(
      {required String labelAndColecctionList}) async {
    try {
      listDropdown = <DropdownMenuItem<String>>[].obs;
      var result =
          await repository.getDropdowValueRepository(labelAndColecctionList);

      for (var res in result.data['value']) {
        listDropdown.add(DropdownMenuItem(
          value: res,
          child: Text(
            res,
            style: TextStyle(
              fontSize: 14,
              color: Get.theme.colorScheme.surface,
            ),
          ),
        ));
      }

      return listDropdown;
    } on AppwriteException catch (e) {
      log(e.response['type']);

      throw (e.response['type']);
    }
  }
}
