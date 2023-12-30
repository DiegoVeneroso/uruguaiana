// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:io';

import 'package:appwrite/appwrite.dart' hide Permission;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uruguaiana/app/repository/auth_repository.dart';
import 'package:uruguaiana/app/routes/app_pages.dart';
import '../../core/config/api_client.dart';
import '../../core/config/constants.dart' as constants;
import '../../core/mixins/dialog_mixin.dart';
import '../../core/mixins/loader_mixin.dart';
import '../../core/mixins/messages_mixin.dart';
import '../../models/collaborate_model.dart';
import '../../repository/collaborate_repositories.dart';

class CollaborateController extends GetxController
    with LoaderMixin, MessagesMixin, DialogMixin {
  RealtimeSubscription? subscription;
  ColaborateRepository repository;
  AuthRepository authRepository;
  final _loading = false.obs;
  final _message = Rxn<MessageModel>();
  final _dialog = Rxn<DialogModel>();
  var collaborateList = <CollaborateModel>[].obs;
  var mycollaborateList = <CollaborateModel>[].obs;
  Rx<List<CollaborateModel>> foundCollaborate = Rx<List<CollaborateModel>>([]);
  RxList<DropdownMenuItem<String>> listDropdown =
      <DropdownMenuItem<String>>[].obs;

  late Rx<File?> pickedFile;
  File? get profileImage => pickedFile.value;
  XFile? imageFile;

  RxString? valorSelecionadoDropDown = ''.obs;

  RxBool searchVisible = false.obs;
  RxBool addImageVisible = false.obs;

  var isDarkMode = false.obs;

  GetStorage storage = GetStorage();
  RxBool isAdmin = false.obs;

  CollaborateController({
    required this.repository,
    required this.authRepository,
  });

  @override
  onInit() {
    loaderListener(_loading);
    messageListener(_message);
    dialogListener(_dialog);
    foundCollaborate.value = collaborateList;
    showNotificationPush();
    getCollaborateFromStorage();

    super.onInit();
  }

  @override
  onReady() {
    subscribe();
    loadData();

    super.onReady();
  }

  Future<void> getCollaborateFromStorage() async {
    var result = await storage.read('my_collaborates_list');

    if (result != null) {
      dynamic jsonData = jsonDecode(result);
      mycollaborateList = jsonData
          .map((value) => CollaborateModel.fromJson(value))
          .toList()
          .obs;
    } else {
      mycollaborateList.value = [];
    }
  }

  Future<void> saveCollaborateToStorage(Map<String, dynamic> map) async {
    mycollaborateList.add(CollaborateModel(
        name: map['name'],
        description: map['description'],
        urlImage: map['urlImage']));

    var collaborateAsMap =
        mycollaborateList.map((value) => value.toJson()).toList();
    String jsonString = jsonEncode(collaborateAsMap);
    await storage.write('my_collaborates_list', jsonString);
  }

  showNotificationPush() {
    FirebaseMessaging.onMessage.listen((message) async {
      print(message.data.values
          .toString()); //recebe o valor dos dados personalidados da notificação

      if (message.notification != null) {
        _message(
          MessageModel(
            title: message.notification!.title.toString(),
            message: message.notification!.body.toString(),
            type: MessageType.success,
          ),
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
          message: 'Imagem carregada!',
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
          message: 'Imagem carregada!',
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
                CropAspectRatioPreset.ratio4x3,
              ]
            : [
                CropAspectRatioPreset.ratio4x3,
              ],
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: "Ajustar imagem",
            toolbarColor: Get.theme.colorScheme.primary,
            toolbarWidgetColor: Get.theme.colorScheme.onPrimaryContainer,
            initAspectRatio: CropAspectRatioPreset.ratio4x3,
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
      imageFile = XFile(croppedFile.path);
    }
  }

  getDialog({
    required String idcollaborates,
    required String collaborates,
  }) {
    _dialog(DialogModel(
      id: idcollaborates,
      title: 'ATENÇÃO',
      message: 'Deseja realmente excluir?\n$collaborates',
    ));
  }

  Future<void> filtercollaborates(String collaboratesName) async {
    List<CollaborateModel> results = [];
    if (collaboratesName.isEmpty) {
      results = collaborateList;
    } else {
      results = collaborateList
          .where((element) => element.name
              .toString()
              .toLowerCase()
              .contains(collaboratesName.toLowerCase()))
          .toList();
    }
    foundCollaborate.value = results;
  }

  Future<void> collaboratesAdd(Map<String, dynamic> map) async {
    try {
      _loading.toggle();

      await repository.collaboratesAddRepository(map);

      //add

      for (var e in [map]) {
        // print('teste');
        // print(e.toString());
        mycollaborateList.add(
          CollaborateModel(
            idCollaborate: '1223123',
            name: e['name'],
            phone: e['phone'],
            description: e['description'],
            urlImage: e['url_image'],
            dateTimeCreated: DateTime.now().toString(),
          ),
        );
      }

      await storage.write(
          'my_collaborates_list', jsonEncode(mycollaborateList));
      // .forEach(
      //   (e) => CollaborateModel(
      //     idCollaborate: e[0]['idCollaborate'],
      //     name: e[0]['name'],
      //     phone: e[0]['phone'],
      //     description: e[0]['description'],
      //     urlImage: e[0]['url_image'],
      //     dateTimeCreated: DateTime.now().toString(),
      //   ),
      // )
      // .toList();

      // jsonDecode(storage.read('my_collaborates_list').toString())
      //     .forEach((e) => collaborateList.add(CollaborateModel.fromJson(e)));

      await Future.delayed(const Duration(seconds: 1));
      _loading.toggle();
      Get.offAndToNamed(Routes.my_collaborate);
      _message(
        MessageModel(
          title: 'Parabéns!',
          message:
              'Proposta cadastrada com sucesso!\nEntraremos em contato em breve!',
          type: MessageType.success,
        ),
      );
    } catch (e) {
      print(e.toString());

      _message(
        MessageModel(
          title: 'ATENÇÃO!',
          message: e.toString(),
          type: MessageType.error,
        ),
      );
      await Future.delayed(const Duration(seconds: 2));
      _loading.toggle();
      Get.offAndToNamed(Routes.collaborate);
    }
  }

  Future collaboratesDelete(String idcollaborates) async {
    try {
      Get.back();
      _loading.toggle();

      await repository.collaboratesDeleteRepository(idcollaborates);

      _loading.toggle();
      await Future.delayed(const Duration(seconds: 1));

      //manter este snackbar para mostra a resposta, o _message() não funciona!
      Get.snackbar(
        'Parabéns!',
        'Notícia excluída com sucesso!',
        backgroundColor: Get.theme.colorScheme.primary,
        colorText: Get.theme.colorScheme.onPrimaryContainer,
        margin: const EdgeInsets.all(20),
      );
    } catch (e) {
      print(e.toString());

      _message(
        MessageModel(
          title: 'ATENÇÃO!',
          message: e.toString(),
          type: MessageType.error,
        ),
      );
      await Future.delayed(const Duration(seconds: 2));
      _loading.toggle();
      Get.offAndToNamed(Routes.collaborate);
    }
  }

  void loadData() async {
    try {
      var result = await repository.loadDataRepository();

      collaborateList.assignAll(result);
    } catch (e) {
      _loading.toggle();
      _message(
        MessageModel(
          title: 'ATENÇÃO!',
          message: 'Erro carregar dados!',
          type: MessageType.error,
        ),
      );
    }
  }

  void subscribe() {
    final realtime = Realtime(ApiClient.account.client);

    subscription = realtime.subscribe([
      'databases.${constants.DATABASE_ID}.collections.${constants.COLLETION_COLLABORATE_ID}.documents'
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
}
