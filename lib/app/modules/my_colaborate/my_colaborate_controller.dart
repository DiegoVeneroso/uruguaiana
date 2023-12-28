// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:appwrite/appwrite.dart' hide Permission;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uruguaiana/app/repository/auth_repository.dart';
import 'package:uruguaiana/app/repository/my_collaborate_repositories.dart';
import 'package:uruguaiana/app/routes/app_pages.dart';
import '../../core/config/api_client.dart';
import '../../core/config/constants.dart' as constants;
import '../../core/mixins/dialog_mixin.dart';
import '../../core/mixins/loader_mixin.dart';
import '../../core/mixins/messages_mixin.dart';
import '../../models/collaborate_model.dart';

class MyCollaborateController extends GetxController
    with LoaderMixin, MessagesMixin, DialogMixin {
  RealtimeSubscription? subscription;
  MyColaborateRepository repository;
  AuthRepository authRepository;
  final _loading = false.obs;
  final _message = Rxn<MessageModel>();
  final _dialog = Rxn<DialogModel>();
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

  MyCollaborateController({
    required this.repository,
    required this.authRepository,
  });

  @override
  onInit() {
    loaderListener(_loading);
    messageListener(_message);
    dialogListener(_dialog);
    foundCollaborate.value = mycollaborateList;
    showNotificationPush();

    super.onInit();
  }

  @override
  onReady() {
    subscribe();
    loadData();

    super.onReady();
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
      results = mycollaborateList;
    } else {
      results = mycollaborateList
          .where((element) => element.name
              .toString()
              .toLowerCase()
              .contains(collaboratesName.toLowerCase()))
          .toList();
    }
    foundCollaborate.value = results;
  }

  Future<void> collaboratesAdd(Map map) async {
    try {
      _loading.toggle();

      // await repository.collaboratesAddRepository(map);

      await Future.delayed(const Duration(seconds: 1));
      _loading.toggle();
      Get.offAndToNamed(Routes.news);
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

  void loadData() async {
    try {
      mycollaborateList.add(
        CollaborateModel(
          idCollaborate: '12312',
          name: 'name',
          urlImage:
              'https://frontapp.com.br/v1/storage/buckets/65243a86eacfdb9c9487/files/1703427144198/view?project=65243945bba372ff009e',
          phone: '2132',
          description: 'gfds',
          dateTimeCreated: '2023-12-24 11:12:24.623149',
        ),
      );
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
