// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:appwrite/appwrite.dart' hide Permission;
import 'package:eu_faco_parte/app/repository/view_peaple_repositories.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:eu_faco_parte/app/repository/auth_repository.dart';
import 'package:eu_faco_parte/app/routes/app_pages.dart';
import '../../core/config/api_client.dart';
import '../../core/config/constants.dart' as constants;
import '../../core/mixins/dialog_mixin.dart';
import '../../core/mixins/loader_mixin.dart';
import '../../core/mixins/messages_mixin.dart';
import 'package:http/http.dart' as http;

import '../../core/ui/widgets/custom_button.dart';
import '../../models/term_model.dart';
import '../../models/view_model.dart';

class ViewPeapleController extends GetxController
    with LoaderMixin, MessagesMixin, DialogMixin {
  RealtimeSubscription? subscription;
  ViewPeapleRepository repository;
  AuthRepository authRepository;
  final _loading = false.obs;
  final _message = Rxn<MessageModel>();
  final _dialog = Rxn<DialogModel>();
  var viewsList = <ViewModel>[].obs;
  var adminViewsList = <ViewModel>[].obs;
  Rx<List<ViewModel>> foundNews = Rx<List<ViewModel>>([]);
  Rx<List<ViewModel>> adminFoundNews = Rx<List<ViewModel>>([]);
  RxList<DropdownMenuItem<String>> listDropdown =
      <DropdownMenuItem<String>>[].obs;
  late Rx<File?> pickedFile;
  File? get profileImage => pickedFile.value;
  XFile? imageFile;
  RxString? valorSelecionadoDropDown = ''.obs;
  RxBool searchVisible = false.obs;
  var isDarkMode = false.obs;
  GetStorage storage = GetStorage();
  RxBool isAdmin = false.obs;
  Uint8List? thumbnailData;
  RxBool addImageVisible = false.obs;

  ViewPeapleController({
    required this.repository,
    required this.authRepository,
  });

  @override
  onInit() {
    getIsAdmin();
    loaderListener(_loading);
    messageListener(_message);
    dialogListener(_dialog);
    foundNews.value = viewsList;
    adminFoundNews.value = adminViewsList;
    showNotificationPush();
    super.onInit();
  }

  @override
  onReady() {
    // login();
    subscribe();
    loadData();
    adminLoadData();

    super.onReady();
  }

  Future<TermModel> getTermOfUse() async {
    try {
      var result = await repository.getTermOfUseRepository();

      return TermModel(descripton: result.documents.first.data['description']);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> setAprovedViewPeaple(Map map) async {
    try {
      loading(true);
      await repository.setAprovedViewPeapleRepository(map);
      Get.back();
      loading(false);
      message('Parabéns!', 'Visão publicada!');
    } catch (e) {
      loading(false);
      Get.back();
      message('Erro!', e.toString());

      rethrow;
    }
  }

  Future<void> deleteViewPeaple(Map map) async {
    try {
      loading(true);
      await repository.viewPeapleDeleteRepository(map);
      Get.back();
      loading(false);
      message('Atenção!', 'Visão excluida!');
    } catch (e) {
      loading(false);
      Get.back();
      message('Erro!', e.toString());

      rethrow;
    }
  }

  Future<void> getIsAdmin() async {
    try {
      var idUser = await storage.read('id_user');

      log('iduser');
      log(idUser);

      if (idUser == '' || idUser == null) {
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
      if (message.notification != null) {
        _message(
          MessageModel(
            title: message.data['title'],
            message: message.data['body'],
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
        compressFormat: ImageCompressFormat.png,
        compressQuality: 50,
        aspectRatioPresets: Platform.isAndroid
            ? [CropAspectRatioPreset.ratio16x9]
            : [CropAspectRatioPreset.ratio16x9],
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
    required String idView,
    required String name,
    required String title,
    required String message,
    required String label,
    required Callback onPressed,
  }) {
    Get.defaultDialog(
      titlePadding: const EdgeInsets.only(top: 10),
      contentPadding: const EdgeInsets.only(top: 30, bottom: 20),
      title: title,
      middleText: message,
      backgroundColor: Get.theme.colorScheme.onPrimaryContainer,
      titleStyle: TextStyle(color: Get.theme.colorScheme.onSurface),
      middleTextStyle: TextStyle(color: Get.theme.colorScheme.onSurface),
      radius: 30,
      confirm: CustomButton(
        color: Get.theme.colorScheme.onError,
        height: 40,
        width: 100,
        label: label,
        onPressed: onPressed,
      ),
    );
  }

  getDialogDelete({
    required String idView,
    required String name,
  }) {
    _dialog(DialogModel(
      id: idView,
      title: 'ATENÇÃO',
      message: 'Deseja realmente excluir a publicação de:\n$name',
    ));
  }

  Future<void> filterNews(String newsName) async {
    List<ViewModel> results = [];
    if (newsName.isEmpty) {
      // _loading.toggle();
      results = viewsList;
    } else {
      // _loading.toggle();
      // await Future.delayed(const Duration(seconds: 1));
      // _loading.toggle();

      results = viewsList
          .where((element) => element.title
              .toString()
              .toLowerCase()
              .contains(newsName.toLowerCase()))
          .toList();
    }
    // _loading.toggle();
    foundNews.value = results;
  }

  // login() async {
  //   try {
  //     _loading.toggle();
  //     await ApiClient.account.createAnonymousSession();
  //     log('usuario anonimo logado!');
  //   } on AppwriteException catch (e) {
  //     _loading.toggle();
  //     log(e.message);
  //   }
  // }

  void loadData() async {
    try {
      var result = await repository.loadDataRepository();

      viewsList.assignAll(result);
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

  void adminLoadData() async {
    try {
      var result = await repository.adminLoadDataRepository();

      adminViewsList.assignAll(result);
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
      'databases.${constants.DATABASE_ID}.collections.${constants.COLLETION_VIEW}.documents'
    ]);

    subscription!.stream.listen((data) {
      for (var ev in data.events) {
        switch (ev) {
          case "databases.*.collections.*.documents.*.create":
            loadData();
            adminLoadData();

            break;
          case "databases.*.collections.*.documents.*.update":
            loadData();
            adminLoadData();
            break;
          case "databases.*.collections.*.documents.*.delete":
            loadData();
            adminLoadData();
            break;
          default:
            break;
        }
      }
    });
  }

  loading(bool state) async {
    if (state == true) {
      return Get.dialog(
        WillPopScope(
          onWillPop: () async => false,
          child: Center(
            child: FractionallySizedBox(
              widthFactor: 0.5,
              heightFactor: 0.2,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Get.theme.colorScheme.onPrimaryContainer,
                  boxShadow: [
                    BoxShadow(
                        color: Get.theme.colorScheme.primary, blurRadius: 5)
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      color: Get.theme.colorScheme.primary,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Material(
                      child: AutoSizeText(
                        "Carregando...",
                        style: TextStyle(
                          color: Get.theme.colorScheme.primary,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        minFontSize: 10,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        barrierDismissible: false,
      );
    } else {
      Get.back();
    }
  }

  message(String title, String message) {
    return Get.snackbar(
      title,
      message,
      backgroundColor: Get.theme.colorScheme.primaryContainer,
      colorText: Get.theme.colorScheme.onPrimaryContainer,
      margin: const EdgeInsets.all(20),
      borderColor: Get.theme.colorScheme.onPrimaryContainer,
      borderWidth: 1,
      boxShadows: [
        BoxShadow(
            color: Get.theme.colorScheme.onPrimaryContainer, blurRadius: 3)
      ],
    );
  }

  Future<String> getTokenIsAdmin() async {
    try {
      var res = await authRepository.getTokenAdminUserRepository();
      String token = res.documents.first.data['token_push'];

      return token;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<bool> sendPushNotificationToAdmin(
      {required String title, required String body}) async {
    const postUrl = 'https://fcm.googleapis.com/fcm/send';
    final data = {
      // "to":
      //     "eTyvEVg8QDuE8ts3_UMNMi:APA91bHVYPFwfEqU4l2qepd4In01F5mROWmZjDV0eEW8mwaVMaUOEOTJuI9h8xQAfGydwmDGPuPSpJiPd69lBE-8JnaDsGrbud6cn8BzdDv5uQk6Om6a6YqBzDH2UJR1IKZ15lUeuT-s",
      "to": await getTokenIsAdmin(),
      "notification": {
        "title": title,
        "body": body,
        "screen": "/proposal",
      },
      "data": {
        "title": title,
        "body": body,
        "screen": "/proposal",
        // "click_action": 'FLUTTER_NOTIFICATION_CLICK'
      }
    };

    final headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization':
          'key=AAAANQf4ge4:APA91bE-LywHQosV6dq1l8cbYjthVP85bTXo5kAokzK8jXOqchENT9VUIoFqFssRpgX5IIDpxiVbPaQLhBltG5EWs3mgbbemOAYpvx4Sk06lidPskgj20-K-B0PlWEnnoBtBnUqSrBCj',
    };

    final response = await http.post(
      Uri.parse(postUrl),
      body: json.encode(data),
      encoding: Encoding.getByName('utf-8'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      log('notificação enviada!');

      return true;
    } else {
      log(' erro ao enviar notificação!');
      return false;
    }
  }

  Future<void> viewAdd(Map map) async {
    try {
      loading(true);

      await repository.viewAddRepository(map);

      await sendPushNotificationToAdmin(
          title: 'Nova colaboração registrada! 💪 👊 ',
          body: "${map['name']} fez uma colaboração");

      await Future.delayed(const Duration(seconds: 1));
      loading(false);
      Get.offAndToNamed(Routes.splash);
      message(
        'Parabéns!',
        'Visão adicionada com sucesso!',
      );
    } catch (e) {
      log(e.toString());

      _message(
        MessageModel(
          title: 'ATENÇÃO!',
          message: e.toString(),
          type: MessageType.error,
        ),
      );
      await Future.delayed(const Duration(seconds: 2));
      _loading.toggle();
      Get.offAndToNamed(Routes.splash);
    }
  }

  Future<void> newsUpdate(Map map) async {
    try {
      _loading.toggle();

      // await repository.newsUpdateRepository(map);

      await Future.delayed(const Duration(seconds: 1));
      _loading.toggle();
      Get.offAndToNamed(Routes.splash);
      _message(
        MessageModel(
          title: 'Parabéns!',
          message: 'Notícia atualizada com sucesso!',
          type: MessageType.success,
        ),
      );
    } catch (e) {
      log(e.toString());

      _message(
        MessageModel(
          title: 'ATENÇÃO!',
          message: e.toString(),
          type: MessageType.error,
        ),
      );
      await Future.delayed(const Duration(seconds: 2));
      _loading.toggle();
      Get.offAndToNamed(Routes.splash);
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
          child: AutoSizeText(
            minFontSize: 10,
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

  Future<Map<String, dynamic>> getVideoTypeFileUrl(String urlFile) async {
    var response = await http.head(Uri.parse(urlFile));

    if (response.statusCode == 200 &&
        response.headers['content-type'].toString().split('/').first ==
            'video') {
      return {'type': 'video'};
    } else {
      return {'type': 'image'};
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
    _loading.toggle();

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
    _loading.toggle();

    return file.path;
  }
}
