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
import '../../core/mixins/dialog_mixin.dart';
import '../../core/mixins/loader_mixin.dart';
import '../../core/mixins/messages_mixin.dart';
import '../../models/collaborate_model.dart';
import '../../models/term_model.dart';

class ViewPeapleController extends GetxController
    with LoaderMixin, MessagesMixin, DialogMixin {
  RealtimeSubscription? subscription;
  ViewPeapleRepository repository;
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
  onInit() {
    loaderListener(_loading);
    messageListener(_message);
    dialogListener(_dialog);
    foundCollaborate.value = collaborateList;
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

  pickImageFileFromGalery() async {
    imageFile = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 50);

    if (imageFile != null) {
      imageFile = await _cropImage(File(imageFile!.path));
      print('####leg');
      print(imageFile?.length());
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

  Future<void> ViewBuilder(Map<String, dynamic> map) async {
    try {
      _loading.toggle();

      await repository.viewsAddRepository(map);

      await sendPushNotificationToAdmin(
          title: 'Nova colaboração registrada! 💪 👊 ',
          body: "${map['name']} fez uma colaboração");

      await Future.delayed(const Duration(seconds: 1));
      _loading.toggle();
      Get.offAndToNamed(Routes.splash);
      _message(
        MessageModel(
          title: 'Parabéns!',
          message:
              'Proposta cadastrada com sucesso!\nEntraremos em contato em breve!',
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
      _loading.toggle();
      _message(
        MessageModel(
          title: 'ATENÇÃO!',
          message: 'Erro carregar termo de uso!',
          type: MessageType.error,
        ),
      );
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

  Future collaboratesDelete(String idcollaborates) async {
    try {
      Get.back();
      _loading.toggle();

      // await repository.collaboratesDeleteRepository(idcollaborates);

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
      Get.offAndToNamed(Routes.collaborate);
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

  Future<List<ViewModel>> loadData() async {
    try {
      var result = await repository.loadDataRepository(search.toString());

      return result;

      // collaborateList.assignAll(result);
    } catch (e) {
      _loading.toggle();
      _message(
        MessageModel(
          title: 'ATENÇÃO!',
          message: 'Erro carregar dados!',
          type: MessageType.error,
        ),
      );
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






// // ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'dart:developer';
// import 'dart:io';
// import 'dart:typed_data';
// import 'package:auto_size_text/auto_size_text.dart';
// import 'package:appwrite/appwrite.dart' hide Permission;
// import 'package:eu_faco_parte/app/repository/view_peaple_repositories.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:image_cropper/image_cropper.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:eu_faco_parte/app/repository/auth_repository.dart';
// import 'package:eu_faco_parte/app/routes/app_pages.dart';
// import '../../core/config/api_client.dart';
// import '../../core/config/constants.dart' as constants;
// import 'package:http/http.dart' as http;

// import '../../core/mixins/dialog_mixin.dart';
// import '../../core/mixins/loader_mixin.dart';
// import '../../core/mixins/messages_mixin.dart';
// import '../../models/term_model.dart';
// import '../../models/view_model.dart';

// class ViewPeapleController extends GetxController
//     with LoaderMixin, MessagesMixin, DialogMixin {
//   RealtimeSubscription? subscription;
//   ViewPeapleRepository repository;
//   AuthRepository authRepository;
//   final _loading = false.obs;
//   final _message = Rxn<MessageModel>();
//   final _dialog = Rxn<DialogModel>();
//   var newsList = <ViewModel>[].obs;
//   RxList<DropdownMenuItem<String>> listDropdown =
//       <DropdownMenuItem<String>>[].obs;
//   late Rx<File?> pickedFile;
//   File? get profileImage => pickedFile.value;
//   XFile? imageFile;
//   RxString? valorSelecionadoDropDown = ''.obs;
//   RxBool searchVisible = false.obs;
//   var isDarkMode = false.obs;
//   GetStorage storage = GetStorage();
//   RxBool isAdmin = false.obs;
//   Uint8List? thumbnailData;
//   RxBool addImageVisible = false.obs;
//   RxString search = ''.obs;
//   ViewPeapleController({
//     required this.repository,
//     required this.authRepository,
//   });

//   @override
//   onInit() async {
//     await getIsAdmin();
//     loaderListener(_loading);
//     messageListener(_message);
//     dialogListener(_dialog);
//     super.onInit();
//   }

//   @override
//   onReady() {
//     subscribe();
//     loadData();

//     super.onReady();
//   }

//   Future<TermModel> getTermOfUse() async {
//     try {
//       // var result = await repository.getTermOfUseRepository();

//       // return TermModel(descripton: result.documents.first.data['description']);
//       return TermModel(descripton: 'descripton');
//     } catch (e) {
//       _loading.toggle();
//       _message(
//         MessageModel(
//           title: 'ATENÇÃO!',
//           message: 'Erro carregar termo de uso!',
//           type: MessageType.error,
//         ),
//       );
//       rethrow;
//     }
//   }

//   Future<void> getIsAdmin() async {
//     try {
//       var idUser = await storage.read('id_user');

//       log('iduser');
//       log(idUser);

//       if (idUser == '' || idUser == null) {
//         isAdmin.value = false;
//       } else {
//         var user = await authRepository.getUserById(idUser);

//         if (user.profile == 'Administrador') {
//           isAdmin.value = true;
//         } else {
//           isAdmin.value = false;
//         }
//       }
//     } catch (e) {
//       log(e.toString());
//       rethrow;
//     }
//   }

//   pickImageFileFromGalery() async {
//     imageFile = await ImagePicker()
//         .pickImage(source: ImageSource.gallery, imageQuality: 50);

//     if (imageFile != null) {
//       await _cropImage(File(imageFile!.path));
//       _message(
//         MessageModel(
//           title: 'Parabéns!',
//           message: 'Imagem carregada!',
//           type: MessageType.success,
//         ),
//       );
//     }
//   }

//   captureImageFileFromCamera() async {
//     imageFile = await ImagePicker()
//         .pickImage(source: ImageSource.camera, imageQuality: 50);
//     if (imageFile != null) {
//       await _cropImage(File(imageFile!.path));
//       _message(
//         MessageModel(
//           title: 'Parabéns!',
//           message: 'Imagem carregada!',
//           type: MessageType.success,
//         ),
//       );
//     }
//   }

//   _cropImage(File imgFile) async {
//     final croppedFile = await ImageCropper().cropImage(
//         sourcePath: imgFile.path,
//         compressFormat: ImageCompressFormat.png,
//         compressQuality: 50,
//         aspectRatioPresets: Platform.isAndroid
//             ? [CropAspectRatioPreset.ratio16x9]
//             : [CropAspectRatioPreset.ratio16x9],
//         uiSettings: [
//           AndroidUiSettings(
//             toolbarTitle: "Ajustar imagem",
//             toolbarColor: Get.theme.colorScheme.primary,
//             toolbarWidgetColor: Get.theme.colorScheme.onPrimaryContainer,
//             initAspectRatio: CropAspectRatioPreset.ratio4x3,
//             lockAspectRatio: true,
//             // hideBottomControls: true,
//             // statusBarColor: Get.theme.colorScheme.primary,
//             activeControlsWidgetColor: Get.theme.colorScheme.primary,
//             dimmedLayerColor: Get.theme.colorScheme.primary,
//             showCropGrid: false,
//           ),
//           IOSUiSettings(
//             title: "Ajustar imagem",
//           )
//         ]);
//     if (croppedFile != null) {
//       imageCache.clear();
//       imageFile = XFile(croppedFile.path);
//     }
//   }

//   getDialog({
//     required String idNews,
//     required String news,
//   }) {
//     _dialog(DialogModel(
//       id: idNews,
//       title: 'ATENÇÃO',
//       message: 'Deseja realmente excluir?\n$news',
//     ));
//   }

//   Future<void> filterViews(String viewsName) async {
//     List<ViewModel> results = [];
//     if (viewsName.isEmpty) {
//       results = newsList;
//     } else {
//       results = newsList
//           .where((element) => element.title
//               .toString()
//               .toLowerCase()
//               .contains(viewsName.toLowerCase()))
//           .toList();
//     }
//     // foundNews.value = results;
//   }

//   Future<List<ViewModel>> loadData() async {
//     try {
//       var result = await repository.loadDataRepository(search.value);

//       return result;
//     } catch (e) {
//       _loading.toggle();
//       _message(
//         MessageModel(
//           title: 'ATENÇÃO!',
//           message: 'Erro carregar dados!',
//           type: MessageType.error,
//         ),
//       );

//       rethrow;
//     }
//   }

//   void subscribe() {
//     final realtime = Realtime(ApiClient.account.client);

//     subscription = realtime.subscribe([
//       'databases.${constants.DATABASE_ID}.collections.${constants.COLLETION_VIEW}.documents'
//     ]);

//     subscription!.stream.listen((data) {
//       for (var ev in data.events) {
//         switch (ev) {
//           case "databases.*.collections.*.documents.*.create":
//             loadData();
//             break;
//           case "databases.*.collections.*.documents.*.update":
//             loadData();
//             break;
//           case "databases.*.collections.*.documents.*.delete":
//             loadData();
//             break;
//           default:
//             break;
//         }
//       }
//     });
//   }

//   Future<void> viewAdd(Map map) async {
//     try {
//       _loading.toggle();

//       await repository.viewsAddRepository(map);

//       await Future.delayed(const Duration(seconds: 1));
//       _loading.toggle();
//       Get.offAndToNamed(Routes.splash);
//       _message(
//         MessageModel(
//           title: 'Parabéns!',
//           message: 'Visão adicionada com sucesso!',
//           type: MessageType.success,
//         ),
//       );
//     } catch (e) {
//       log(e.toString());

//       _message(
//         MessageModel(
//           title: 'ATENÇÃO!',
//           message: e.toString(),
//           type: MessageType.error,
//         ),
//       );
//       await Future.delayed(const Duration(seconds: 2));
//       _loading.toggle();
//       Get.offAndToNamed(Routes.splash);
//     }
//   }

//   Future newsDelete(String idnews) async {
//     try {
//       Get.back();
//       _loading.toggle();

//       await repository.newsDeleteRepository(idnews);

//       _loading.toggle();
//       await Future.delayed(const Duration(seconds: 1));

//       //manter este snackbar para mostra a resposta, o _message() não funciona!
//       Get.snackbar(
//         'Parabéns!',
//         'Notícia excluída com sucesso!',
//         backgroundColor: Get.theme.colorScheme.primary,
//         colorText: Get.theme.colorScheme.onPrimaryContainer,
//         margin: const EdgeInsets.all(20),
//       );
//     } catch (e) {
//       log(e.toString());

//       _message(
//         MessageModel(
//           title: 'ATENÇÃO!',
//           message: e.toString(),
//           type: MessageType.error,
//         ),
//       );
//       await Future.delayed(const Duration(seconds: 2));
//       _loading.toggle();
//       Get.offAndToNamed(Routes.splash);
//     }
//   }

//   Future<void> newsUpdate(Map map) async {
//     try {
//       _loading.toggle();

//       await repository.newsUpdateRepository(map);

//       await Future.delayed(const Duration(seconds: 1));
//       _loading.toggle();
//       Get.offAndToNamed(Routes.splash);
//       _message(
//         MessageModel(
//           title: 'Parabéns!',
//           message: 'Notícia atualizada com sucesso!',
//           type: MessageType.success,
//         ),
//       );
//     } catch (e) {
//       log(e.toString());

//       _message(
//         MessageModel(
//           title: 'ATENÇÃO!',
//           message: e.toString(),
//           type: MessageType.error,
//         ),
//       );
//       await Future.delayed(const Duration(seconds: 2));
//       _loading.toggle();
//       Get.offAndToNamed(Routes.splash);
//     }
//   }

//   Future<List<DropdownMenuItem<String>>> getDropdowValue(
//       {required String labelAndColecctionList}) async {
//     try {
//       listDropdown = <DropdownMenuItem<String>>[].obs;
//       var result =
//           await repository.getDropdowValueRepository(labelAndColecctionList);

//       for (var res in result.data['value']) {
//         listDropdown.add(DropdownMenuItem(
//           value: res,
//           child: AutoSizeText(
//             minFontSize: 10,
//             res,
//             style: TextStyle(
//               fontSize: 14,
//               color: Get.theme.colorScheme.surface,
//             ),
//           ),
//         ));
//       }

//       return listDropdown;
//     } on AppwriteException catch (e) {
//       log(e.response['type']);

//       throw (e.response['type']);
//     }
//   }

//   Future<Map<String, dynamic>> getVideoTypeFileUrl(String urlFile) async {
//     var response = await http.head(Uri.parse(urlFile));

//     if (response.statusCode == 200 &&
//         response.headers['content-type'].toString().split('/').first ==
//             'video') {
//       return {'type': 'video'};
//     } else {
//       return {'type': 'image'};
//     }
//   }

//   Future<String> getTypeUniqueFileUrl(String urlFile) async {
//     var response = await http.head(Uri.parse(urlFile));

//     if (response.statusCode == 200) {
//       return response.headers['content-type'].toString().split('/').last;
//     } else {
//       return 'Erro ao buscar a extensão';
//     }
//   }

//   getImageXFileByUrl(String url) async {
//     _loading.toggle();

//     String extensionFile = await getTypeUniqueFileUrl(url);

//     Directory tempDir = await getTemporaryDirectory();
//     String tempPath = tempDir.path;
//     String fileName =
//         "image${DateTime.now().millisecondsSinceEpoch}.$extensionFile";
//     File fileWrite = File("$tempPath/$fileName");
//     Uri uri = Uri.parse(url);
//     final response = await http.get(uri);
//     fileWrite.writeAsBytesSync(response.bodyBytes);
//     final file = XFile("$tempPath/$fileName");
//     _loading.toggle();

//     return file.path;
//   }
// }
