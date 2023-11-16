// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';
import 'dart:io';
import 'package:appwrite/appwrite.dart' hide Permission;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uruguaiana/app/repository/auth_repository.dart';
import 'package:uruguaiana/app/routes/app_pages.dart';
import '../../core/config/api_client.dart';
import '../../core/config/constants.dart' as constants;
import '../../core/mixins/dialog_mixin.dart';
import '../../core/mixins/loader_mixin.dart';
import '../../core/mixins/messages_mixin.dart';
import '../../models/about_model.dart';
import '../../repository/about_repositories.dart';
import 'package:http/http.dart' as http;

class AboutController extends GetxController
    with LoaderMixin, MessagesMixin, DialogMixin {
  RealtimeSubscription? subscription;
  AboutRepository repository;
  AuthRepository authRepository;
  final _loading = false.obs;
  final _message = Rxn<MessageModel>();
  final _dialog = Rxn<DialogModel>();
  var aboutList = <AboutModel>[].obs;
  Rx<List<AboutModel>> foundAbout = Rx<List<AboutModel>>([]);

  late Rx<File?> pickedFile;
  File? get profileImage => pickedFile.value;
  XFile? imageFile;

  RxString? valorSelecionadoDropDown = ''.obs;

  RxBool searchVisible = false.obs;

  var isDarkMode = false.obs;

  GetStorage storage = GetStorage();
  RxBool isAdmin = false.obs;

  RxBool imageValidate = false.obs;

  AboutController({
    required this.repository,
    required this.authRepository,
  });

  @override
  onInit() {
    getIsAdmin();
    loaderListener(_loading);
    messageListener(_message);
    dialogListener(_dialog);
    foundAbout.value = aboutList;
    showNotificationPush();

    super.onInit();
  }

  @override
  onReady() {
    subscribe();
    loadData();

    super.onReady();
  }

  Future<void> getIsAdmin() async {
    try {
      var idUser = await storage.read('id_user');

      if (idUser == null) {
        isAdmin.value = false;
      } else {
        var user = await authRepository.getUserById(idUser);

        if (user.profile == 'Administrador') {
          isAdmin.value = true;
        } else {
          isAdmin.value = false;
        }
      }
    } catch (e) {
      log(e.toString());
      rethrow;
    }
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
    required String idAbout,
    required String about,
  }) {
    _dialog(DialogModel(
      id: idAbout,
      title: 'Atenção',
      message: 'Deseja realmente excluir?\n$about',
    ));
  }

  Future<void> filterAbout(String aboutName) async {
    List<AboutModel> results = [];
    if (aboutName.isEmpty) {
      // _loading.toggle();
      results = aboutList;
    } else {
      // _loading.toggle();
      // await Future.delayed(const Duration(seconds: 1));
      // _loading.toggle();

      results = aboutList
          .where((element) => element.title
              .toString()
              .toLowerCase()
              .contains(aboutName.toLowerCase()))
          .toList();
    }
    // _loading.toggle();
    foundAbout.value = results;
  }

  void loadData() async {
    try {
      var result = await repository.loadDataRepository();

      aboutList.assignAll(result);
    } catch (e) {
      _loading.toggle();
      _message(
        MessageModel(
          title: 'Atenção!',
          message: 'Erro carregar dados!',
          type: MessageType.error,
        ),
      );
    }
  }

  void subscribe() {
    final realtime = Realtime(ApiClient.account.client);

    subscription = realtime.subscribe([
      'databases.${constants.DATABASE_ID}.collections.${constants.COLLETION_ABOUT_ID}.documents'
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

  Future<void> aboutAdd(Map map) async {
    try {
      _loading.toggle();

      await repository.aboutAddRepository(map);

      await Future.delayed(const Duration(seconds: 1));
      _loading.toggle();
      Get.offAndToNamed(Routes.about);
      _message(
        MessageModel(
          title: 'Parabéns!',
          message: 'Quem somos adicionado com sucesso!',
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
      Get.offAndToNamed(Routes.about);
    }
  }

  Future aboutDelete(String idabout) async {
    try {
      Get.back();
      _loading.toggle();

      await repository.aboutDeleteRepository(idabout);

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
          title: 'Atenção!',
          message: e.toString(),
          type: MessageType.error,
        ),
      );
      await Future.delayed(const Duration(seconds: 2));
      _loading.toggle();
      Get.offAndToNamed(Routes.about);
    }
  }

  Future<void> aboutUpdate(Map map) async {
    try {
      _loading.toggle();

      await repository.aboutUpdateRepository(map);

      await Future.delayed(const Duration(seconds: 1));
      _loading.toggle();
      Get.offAndToNamed(Routes.about);
      _message(
        MessageModel(
          title: 'Parabéns!',
          message: 'Notícia atualizada com sucesso!',
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
      Get.offAndToNamed(Routes.about);
    }
  }

  Future<String> getTypeUniqueFileUrl(String urlFile) async {
    var response = await http.head(Uri.parse(urlFile));

    if (response.statusCode == 200) {
      return response.headers['content-type'].toString().split('/').last;
    } else {
      return 'Erro ao buscar a extensão';
    }
  }

  getImageXFileByUrl(String url) async {
    String extensionFile = await getTypeUniqueFileUrl(url);

    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    String fileName =
        "image${DateTime.now().millisecondsSinceEpoch}.$extensionFile";
    File fileWrite = File("$tempPath/$fileName");
    Uri uri = Uri.parse(url);
    final response = await http.get(uri);
    fileWrite.writeAsBytesSync(response.bodyBytes);
    final file = XFile("$tempPath/$fileName");
    return file.path;
  }
}
