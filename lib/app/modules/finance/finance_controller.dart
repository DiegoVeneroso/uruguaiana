// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:developer';
import 'dart:ffi';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:appwrite/appwrite.dart' hide Permission;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:eu_faco_parte/app/models/term_model.dart';
import 'package:eu_faco_parte/app/repository/auth_repository.dart';
import 'package:eu_faco_parte/app/routes/app_pages.dart';
import '../../core/config/api_client.dart';
import '../../core/config/constants.dart' as constants;
import '../../core/mixins/dialog_mixin.dart';
import '../../core/mixins/loader_mixin.dart';
import '../../core/mixins/messages_mixin.dart';
import '../../models/finance_model.dart';
import '../../repository/Finance_repositories.dart';

class FinanceController extends GetxController
    with LoaderMixin, MessagesMixin, DialogMixin {
  RealtimeSubscription? subscription;
  FinanceRepository repository;
  AuthRepository authRepository;
  final _loading = false.obs;
  final _message = Rxn<MessageModel>();
  final _dialog = Rxn<DialogModel>();
  var FinanceList = <FinanceModel>[].obs;
  var myFinanceList = <FinanceModel>[].obs;
  Rx<List<FinanceModel>> foundFinance = Rx<List<FinanceModel>>([]);
  RxList<DropdownMenuItem<String>> listDropdown =
      <DropdownMenuItem<String>>[].obs;

  late Rx<File?> pickedFile;
  File? get profileImage => pickedFile.value;
  XFile? imageFile;

  RxBool addImageVisible = false.obs;

  var isDarkMode = false.obs;

  FinanceController({
    required this.repository,
    required this.authRepository,
  });

  @override
  onInit() {
    loaderListener(_loading);
    messageListener(_message);
    dialogListener(_dialog);
    super.onInit();
  }

  @override
  onReady() {
    subscribe();
    loadDataPlus();

    super.onReady();
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
    required String idFinances,
    required String Finances,
  }) {
    _dialog(DialogModel(
      id: idFinances,
      title: 'ATENÇÃO',
      message: 'Deseja realmente excluir?\n$Finances',
    ));
  }

  Future<void> FinancesAdd(Map<String, dynamic> map) async {
    try {
      _loading.toggle();

      // await repository.FinancesAddRepository(map);

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

  Future FinancesDelete(String idFinances) async {
    try {
      Get.back();
      _loading.toggle();

      // await repository.FinancesDeleteRepository(idFinances);

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
      Get.offAndToNamed(Routes.finance);
    }
  }

  loadDataPlus() async {
    try {
      var result = await repository.loadDataPlusRepository();
      return result;
    } catch (e) {
      _message(
        MessageModel(
          title: 'ATENÇÃO!',
          message: 'Erro carregar lista de receitas!',
          type: MessageType.error,
        ),
      );
      Get.toNamed(Routes.splash);
    }
  }

  loadDataMinus() async {
    try {
      var result = await repository.loadDataMinusRepository();
      return result;
    } catch (e) {
      _message(
        MessageModel(
          title: 'ATENÇÃO!',
          message: 'Erro carregar lista de despesas!',
          type: MessageType.error,
        ),
      );
      Get.toNamed(Routes.splash);
    }
  }

  Future<double> getValuesPlus() async {
    try {
      var result = await repository.loadDataPlusRepository();

      double totalPlus = 0;
      for (var res in result) {
        totalPlus += double.parse(res.value);
      }

      return totalPlus;
    } catch (e) {
      _message(
        MessageModel(
          title: 'ATENÇÃO!',
          message: 'Erro o valor toatl das receitas!',
          type: MessageType.error,
        ),
      );
      Get.toNamed(Routes.splash);
      rethrow;
    }
  }

  Future<double> getValuesMinus() async {
    try {
      var result = await repository.loadDataMinusRepository();

      double totalPlus = 0;
      for (var res in result) {
        totalPlus += double.parse(res.value);
      }

      return totalPlus;
    } catch (e) {
      _message(
        MessageModel(
          title: 'ATENÇÃO!',
          message: 'Erro o valor total das despesas!',
          type: MessageType.error,
        ),
      );
      Get.toNamed(Routes.splash);
      rethrow;
    }
  }

  Future<double> getValuesTotal() async {
    try {
      var receitaTotal = await getValuesPlus();
      var despesaTotal = await getValuesMinus();

      var total = receitaTotal - despesaTotal;

      return total;
    } catch (e) {
      _message(
        MessageModel(
          title: 'ATENÇÃO!',
          message: 'Erro o valor total das despesas!',
          type: MessageType.error,
        ),
      );
      Get.toNamed(Routes.splash);
      rethrow;
    }
  }

  void subscribe() {
    final realtime = Realtime(ApiClient.account.client);

    subscription = realtime.subscribe([
      'databases.${constants.DATABASE_ID}.collections.${constants.COLLETION_FINANCE}.documents'
    ]);

    subscription!.stream.listen((data) {
      for (var ev in data.events) {
        switch (ev) {
          case "databases.*.collections.*.documents.*.create":
            loadDataPlus();
            loadDataMinus();
            break;
          case "databases.*.collections.*.documents.*.update":
            loadDataPlus();
            loadDataMinus();
            break;
          case "databases.*.collections.*.documents.*.delete":
            loadDataPlus();
            loadDataMinus();
            break;
          default:
            break;
        }
      }
    });
  }
}
