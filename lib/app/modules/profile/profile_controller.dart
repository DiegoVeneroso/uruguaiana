// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';
import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/config/api_client.dart';
import '../../core/config/constants.dart' as constants;
import '../../core/mixins/dialog_mixin.dart';
import '../../core/mixins/loader_mixin.dart';
import '../../core/mixins/messages_mixin.dart';
import '../../models/item_model.dart';
import '../../repository/profile_repositories.dart';

class ProfileController extends GetxController
    with LoaderMixin, MessagesMixin, DialogMixin {
  RealtimeSubscription? subscription;
  ProfileRepository repository;
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

  ProfileController({
    required this.repository,
  });

  @override
  onInit() {
    loaderListener(_loading);
    messageListener(_message);
    dialogListener(_dialog);
    foundItem.value = itemList;

    super.onInit();
  }

  @override
  onReady() {
    // login();

    subscribe();
    loadData();
    super.onReady();
  }

  pickImageFileFromGalery() async {
    imageFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (imageFile != null) {
      Get.snackbar(
          'Imagem de Perfil', 'Sucesso em selecionar imagem da galeria!');
    }
  }

  captureImageFileFromCamera() async {
    imageFile = await ImagePicker().pickImage(source: ImageSource.camera);
    if (imageFile != null) {
      print(imageFile!.path);
      Get.snackbar(
          'Imagem de Perfil', 'Sucesso em selecionar imagem da camera!');
    }
    pickedFile = Rx<File?>(File(imageFile!.path));
  }

  getDialog({
    required String idItem,
    required String item,
  }) {
    _dialog(DialogModel(
      id: idItem,
      title: 'ATENÇÃO',
      message: 'Deseja realmente excluir o item?\n$item',
    ));
  }

  void filterItem(String itemName) {
    List<ItemModel> results = [];
    if (itemName.isEmpty) {
      results = itemList;
    } else {
      results = itemList
          .where((element) => element.name
              .toString()
              .toLowerCase()
              .contains(itemName.toLowerCase()))
          .toList();
    }
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
      // _loading.toggle();
      var result = await repository.loadDataRepository();

      itemList.assignAll(result);
      // _loading.toggle();
    } catch (e) {
      // _loading.toggle();
      _message(
        MessageModel(
          title: 'Parabéns!',
          message: 'Item adicionado com sucesso!',
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
          title: 'ATENÇÃO!',
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
        'ATENÇÃO!',
        'Item excluído com sucesso!',
        backgroundColor: Colors.red[800]!,
        colorText: Colors.white,
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
          title: 'ATENÇÃO!',
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
          child: AutoSizeText(
            minFontSize: 10,
            res,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
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
