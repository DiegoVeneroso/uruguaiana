// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';
import 'dart:io';

import 'package:appwrite/appwrite.dart' hide Permission;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:eu_faco_parte/app/core/mixins/loader_message_mixin.dart';
import 'package:eu_faco_parte/app/repository/auth_repository.dart';
import 'package:eu_faco_parte/app/repository/proposal_actions_repositories.dart';
import 'package:eu_faco_parte/app/routes/app_pages.dart';
import '../../../core/config/api_client.dart';
import '../../../core/config/constants.dart' as constants;
import '../../../core/mixins/dialog_mixin.dart';
import '../../../core/mixins/loader_mixin.dart';
import '../../../core/mixins/messages_mixin.dart';
import '../../../models/proposal_action_model.dart';
import 'package:http/http.dart' as http;

class ProposalActionsController extends GetxController
    with LoaderMessageMixin, LoaderMixin, MessagesMixin, DialogMixin {
  RealtimeSubscription? subscription;
  ProposalActionsRepository repository;
  AuthRepository authRepository;
  final loading = false.obs;
  final loadingMessage = false.obs;
  final _message = Rxn<MessageModel>();
  final _dialog = Rxn<DialogModel>();
  var proposalList = <ProposalActionModel>[].obs;
  Rx<List<ProposalActionModel>> foundProposal =
      Rx<List<ProposalActionModel>>([]);
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

  String idProposalBase;

  RxBool imageValidate = true.obs;
  RxString imageValid = ''.obs;
  ProposalActionsController({
    required this.repository,
    required this.authRepository,
    required this.idProposalBase,
  });

  @override
  onInit() {
    getIsAdmin();
    loaderListener(loading);
    loaderMessageListener(loadingMessage);
    messageListener(_message);
    dialogListener(_dialog);
    foundProposal.value = proposalList;
    // notificationPush();

    super.onInit();
  }

  @override
  onReady() {
    // login();
    subscribe();
    loadData();

    super.onReady();
  }

  @override
  onClose() {
    imageFile = null;
    imageValidate.value = false;
    super.onClose();
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

  // notificationPush() {
  //   FirebaseMessaging.onMessage.listen((message) async {
  //     log(message.data.values
  //         .toString()); //recebe o valor dos dados personalidados da notificação

  //     if (message.notification != null) {
  //       Get.snackbar(
  //         onTap: (snack) {
  //           // Get.toNamed('/noticias');
  //         },
  //         message.notification!.title.toString(),
  //         message.notification!.body.toString(),
  //         backgroundColor: Colors.blue,
  //         colorText: Colors.white,
  //         margin: const EdgeInsets.all(20),
  //       );
  //     }
  //   });
  // }

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

  pickVideoFileFromGalery() async {
    imageFile = await ImagePicker().pickVideo(source: ImageSource.gallery);

    _message(
      MessageModel(
        title: 'Parabéns!',
        message: 'Video carregado!',
        type: MessageType.success,
      ),
    );
  }

  capturaVideoFileFromCamera() async {
    imageFile = await ImagePicker().pickVideo(source: ImageSource.camera);

    _message(
      MessageModel(
        title: 'Parabéns!',
        message: 'Video carregado!',
        type: MessageType.success,
      ),
    );
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
      imageFile = XFile(croppedFile.path);
    }
  }

  getDialog({
    required String idProposal,
    required String proposal,
  }) {
    _dialog(DialogModel(
      id: idProposal,
      title: 'ATENÇÃO',
      message: 'Deseja realmente excluir a ação?\n$proposal',
    ));
  }

  Future<void> filterProposal(String proposalName) async {
    List<ProposalActionModel> results = [];
    if (proposalName.isEmpty) {
      // loading.toggle();
      results = proposalList;
    } else {
      // loading.toggle();
      // await Future.delayed(const Duration(seconds: 1));
      // loading.toggle();

      results = proposalList
          .where((element) => element.title
              .toString()
              .toLowerCase()
              .contains(proposalName.toLowerCase()))
          .toList();
    }
    // loading.toggle();
    foundProposal.value = results;
  }

  // login() async {
  //   try {
  //     loading.toggle();
  //     await ApiClient.account.createAnonymousSession();
  //     log('usuario anonimo logado!');
  //   } on AppwriteException catch (e) {
  //     loading.toggle();
  //     log(e.message);
  //   }
  // }

  void loadData() async {
    try {
      var result = await repository.loadDataRepository(idProposalBase);

      proposalList.assignAll(result);
    } catch (e) {
      loading.toggle();
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
      'databases.${constants.DATABASE_ID}.collections.${constants.COLLETION_PROPOSAL_ACTIONS_ID}.documents'
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

  Future<void> proposalActionAdd(Map map) async {
    try {
      loadingMessage.toggle();

      await repository.proposalActionAddRepository(map);

      await Future.delayed(const Duration(seconds: 1));
      loadingMessage.toggle();

      Get.offAllNamed(Routes.splash);

      // Get.offAndToNamed(Routes.proposal_actions, parameters: {
      //   'proposal_pilar_name': map['proposal_pilar_name'],
      // });
      _message(
        MessageModel(
          title: 'Parabéns!',
          message: 'Ação adicionada com sucesso!',
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
      loadingMessage.toggle();

      Get.offAndToNamed(Routes.splash);

      // Get.offAndToNamed(Routes.proposal_actions,
      //     parameters: {'proposal_pilar_name': map['proposal_pilar_name']});
    }
  }

  Future proposalActionDelete(Map map) async {
    try {
      Get.back();
      loading.toggle();

      await repository
          .proposalActionsDeleteRepository(map['idProposal'].toString());

      loading.toggle();
      await Future.delayed(const Duration(seconds: 1));

      Get.toNamed(Routes.proposal_actions, parameters: {
        'proposal_pilar_name': map['proposal_pilar_name'].toString(),
      });

      //manter este snackbar para mostra a resposta, o _message() não funciona!
      Get.snackbar(
        'Parabéns!',
        'Ação excluída com sucesso!',
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
      loading.toggle();
      Get.offAndToNamed(Routes.splash);
    }
  }

  Future<void> proposalActionUpdate(Map map) async {
    try {
      loading.toggle();

      await repository.proposalActionsUpdateRepository(map);

      await Future.delayed(const Duration(seconds: 1));
      loading.toggle();
      Get.toNamed(Routes.splash, parameters: {
        'proposal_pilar_name': map['proposal_pilar_name'].toString(),
      });
      _message(
        MessageModel(
          title: 'Parabéns!',
          message: 'Ação alterada com sucesso!',
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
      loading.toggle();
      Get.offAndToNamed(Routes.splash);
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
