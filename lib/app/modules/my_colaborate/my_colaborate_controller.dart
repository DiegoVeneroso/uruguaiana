// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:appwrite/appwrite.dart' hide Permission;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:eu_faco_parte/app/repository/auth_repository.dart';
import 'package:eu_faco_parte/app/repository/my_collaborate_repositories.dart';
import 'package:eu_faco_parte/app/routes/app_pages.dart';
import '../../core/config/api_client.dart';
import '../../core/config/constants.dart' as constants;
import '../../core/mixins/dialog_mixin.dart';
import '../../core/mixins/loader_mixin.dart';
import '../../core/mixins/messages_mixin.dart';
import '../../models/collaborate_model.dart';
import 'package:http/http.dart' as http;

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
    //showNotificationPush();
    getIsAdmin();
    super.onInit();
  }

  @override
  onReady() {
    loadData();

    super.onReady();
  }

  Future<void> getIsAdmin() async {
    try {
      var idUser = await storage.read('id_user');

      print('iduser');
      print(idUser);

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

  void loadData() async {
    try {
      jsonDecode(storage.read('my_collaborates_list').toString())
          .forEach((e) => mycollaborateList.add(CollaborateModel.fromJson(e)));
    } catch (e, s) {
      log(e.toString());
      log(s.toString());
      _loading.toggle();
      _message(
        MessageModel(
          title: 'ATENÇÃO!',
          // message: e.toString(),
          message: 'Erro carregar dados!',
          type: MessageType.error,
        ),
      );
    }
  }
}
