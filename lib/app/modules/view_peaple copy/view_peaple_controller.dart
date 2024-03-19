// ignore_for_file: public_member_api_docs, sort_constructors_first, deprecated_member_use
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:eu_faco_parte/app/models/view_model.dart';
import 'package:eu_faco_parte/app/repository/view_peaple_repositories.dart';
import 'package:http/http.dart' as http;
import 'package:appwrite/appwrite.dart' hide Permission;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:eu_faco_parte/app/repository/auth_repository.dart';
import 'package:eu_faco_parte/app/routes/app_pages.dart';
import '../../core/config/api_client.dart';
import '../../core/config/constants.dart' as constants;
import '../../models/term_model.dart';
import 'package:path_provider/path_provider.dart';

class ViewPeapleController extends GetxController {
  RealtimeSubscription? subscription;
  ViewPeapleRepository repository;
  AuthRepository authRepository;

  late Rx<File?> pickedFile;
  File? get profileImage => pickedFile.value;
  XFile? imageFile;

  RxString search = ''.obs;

  RxBool searchVisible = false.obs;
  RxBool addImageVisible = false.obs;

  var isDarkMode = false.obs;

  GetStorage storage = GetStorage();
  RxBool isAdmin = false.obs;

  ViewPeapleController({
    required this.repository,
    required this.authRepository,
  });

  @override
  onReady() {
    subscribe();
    loadData();

    super.onReady();
  }

  captureImageFileFromCamera() async {
    imageFile = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 50);
    if (imageFile != null) {
      await _cropImage(File(imageFile!.path));

      messagenovo('Parabéns', 'Imagem carregada!');
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

  Future<void> ViewBuilder(Map<String, dynamic> map) async {
    try {
      loadingnovo(true);

      await repository.viewsAddRepository(map);

      await sendPushNotificationToAdmin(
          title: 'Nova colaboração registrada! 💪 👊 ',
          body: "${map['name']} fez uma colaboração");

      await Future.delayed(const Duration(seconds: 1));
      loadingnovo(false);
      Get.offAndToNamed(Routes.splash);

      messagenovo('Parabéns!',
          'Proposta cadastrada com sucesso!\nEntraremos em contato em breve!');
    } catch (e) {
      log(e.toString());

      messagenovo('ATENÇÃO!', e.toString());

      await Future.delayed(const Duration(seconds: 2));
      loadingnovo(true);
      Get.offAndToNamed(Routes.splash);
    }
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

  Future<TermModel> getTermOfUse() async {
    try {
      var result = await repository.getTermOfUseRepository();

      return TermModel(descripton: result.documents.first.data['description']);
    } catch (e) {
      loadingnovo(false);

      messagenovo('ATENÇÃO!', 'Erro carregar termo de uso!');
      rethrow;
    }
  }

  loadingnovo(bool state) async {
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

  messagenovo(String title, String message) {
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

  Future<void> viewAdd(Map<String, dynamic> map) async {
    try {
      loadingnovo(true);
      await repository.viewsAddRepository(map);

      await sendPushNotificationToAdmin(
          title: 'Nova visão/reclamação registrada! 💪 👊 ',
          body: "Aprove pra ser publicada");

      await Future.delayed(const Duration(seconds: 1));
      loadingnovo(false);
      Get.offAndToNamed(Routes.splash);

      messagenovo('Parabéns!',
          'Visão cadastrada com sucesso!\nEntraremos em contato em breve!');
    } catch (e) {
      log(e.toString());

      messagenovo('ATENÇÃO!', e.toString());

      await Future.delayed(const Duration(seconds: 2));
      loadingnovo(false);
      Get.offAndToNamed(Routes.splash);
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
    loadingnovo(true);
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
    loadingnovo(false);

    return file.path;
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

  Future<List<ViewModel>> loadData() async {
    try {
      var result = await repository.loadDataRepository(search.toString());
      return result;

      // collaborateList.assignAll(result);
    } catch (e) {
      loadingnovo(false);
      messagenovo('ATENÇÃO!', 'Erro carregar dados!');
      rethrow;
    }
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

  // Future<TermModel> getTermOfUse() async {
  //   try {
  //     // var result = await repository.getTermOfUseRepository();

  //     // return TermModel(descripton: result.documents.first.data['description']);
  //   } catch (e) {
  //     _loading.toggle();
  //     _message(
  //       MessageModel(
  //         title: 'ATENÇÃO!',
  //         message: 'Erro carregar termo de uso!',
  //         type: MessageType.error,
  //       ),
  //     );
  //     rethrow;
  //   }
  // }

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
            break;
          case "databases.*.collections.*.documents.*.update":
            print('update2');
            update();
            Get.toNamed(Routes.view_people);
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
