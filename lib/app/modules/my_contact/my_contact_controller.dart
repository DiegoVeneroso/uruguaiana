// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:appwrite/appwrite.dart' hide Permission;
import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:eu_faco_parte/app/repository/auth_repository.dart';
import 'package:eu_faco_parte/app/repository/my_contact_repositories.dart';
import 'package:eu_faco_parte/app/routes/app_pages.dart';
import '../../core/mixins/dialog_mixin.dart';
import '../../core/mixins/loader_mixin.dart';
import '../../core/mixins/messages_mixin.dart';
import '../../models/notification_model.dart';

class MyContactController extends GetxController
    with LoaderMixin, MessagesMixin, DialogMixin {
  RealtimeSubscription? subscription;
  MyContactRepository repository;
  AuthRepository authRepository;
  final _loading = false.obs;
  final _message = Rxn<MessageModel>();
  var notificationList = <NotificationModel>[].obs;
  Rx<List<NotificationModel>> foundNotification =
      Rx<List<NotificationModel>>([]);
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

  MyContactController({
    required this.repository,
    required this.authRepository,
  });

  @override
  onInit() {
    getIsAdmin();
    loaderListener(_loading);
    messageListener(_message);
    foundNotification.value = notificationList;

    super.onInit();
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

  Future<void> myContactAdd(Map map) async {
    try {
      _loading.toggle();

      await repository.myContactAddRepository(map);

      await Future.delayed(const Duration(seconds: 1));
      _loading.toggle();
      Get.offAndToNamed(Routes.my_contact);
      _message(
        MessageModel(
          title: 'Parabéns!',
          message: 'Contatos cadastrados com sucesso!',
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
      Get.offAndToNamed(Routes.my_contact);
    }
  }

  Future<DocumentList> getContactFacebook() async {
    try {
      var res = await authRepository.getContactFacebookRepository();

      return res;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<DocumentList> getContactInstagram() async {
    try {
      var res = await authRepository.getContactInstagramRepository();

      return res;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<DocumentList> getContactWhatsapp() async {
    try {
      var res = await authRepository.getContactWhatsappRepository();

      return res;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}
