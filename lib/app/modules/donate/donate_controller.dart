// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';
import 'dart:io';
import 'package:appwrite/appwrite.dart' hide Permission;
import 'package:eu_faco_parte/app/models/token_donate_model.dart';
import 'package:eu_faco_parte/app/repository/donate_repositories.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:eu_faco_parte/app/repository/auth_repository.dart';
import 'package:eu_faco_parte/app/routes/app_pages.dart';
import '../../core/config/api_client.dart';
import '../../core/config/constants.dart' as constants;
import '../../core/mixins/dialog_mixin.dart';
import '../../core/mixins/loader_mixin.dart';
import '../../core/mixins/messages_mixin.dart';

class DonateController extends GetxController
    with LoaderMixin, MessagesMixin, DialogMixin {
  RealtimeSubscription? subscription;
  DonateRepository repository;
  AuthRepository authRepository;
  final _loading = false.obs;
  final _message = Rxn<MessageModel>();
  var donateList = <TokenDonateModel>[].obs;

  var isDarkMode = false.obs;

  GetStorage storage = GetStorage();
  RxBool isAdmin = false.obs;

  DonateController({
    required this.repository,
    required this.authRepository,
  });

  @override
  onInit() {
    getIsAdmin();
    loaderListener(_loading);
    messageListener(_message);

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

  Future<List<TokenDonateModel>> loadData() async {
    try {
      var result = await repository.loadDataRepository();

      if (result.documents.isEmpty) {
        return <TokenDonateModel>[];
      } else {
        var listToken = result.documents
            .map((docmodel) => TokenDonateModel(
                  value: docmodel.data['value'],
                ))
            .toList();

        return listToken;
      }
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

  Future<void> tokenAdd(Map map) async {
    try {
      _loading.toggle();

      await repository.adminTokenAddRepository(map);

      await Future.delayed(const Duration(seconds: 1));
      _loading.toggle();
      Get.toNamed(Routes.admin);
      _message(
        MessageModel(
          title: 'Parabéns!',
          message: 'Token adicionado com sucesso!',
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
      Get.offAndToNamed(Routes.admin);
    }
  }

  Future<void> donateAdd(Map map) async {
    try {
      _loading.toggle();

      await repository.adminTokenAddRepository(map);

      await Future.delayed(const Duration(seconds: 1));
      _loading.toggle();
      Get.toNamed(Routes.about);
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
          title: 'ATENÇÃO!',
          message: e.toString(),
          type: MessageType.error,
        ),
      );
      await Future.delayed(const Duration(seconds: 2));
      _loading.toggle();
      Get.offAndToNamed(Routes.about);
    }
  }

  Future donateDelete(String idabout) async {
    try {
      Get.back();
      _loading.toggle();

      // await repository.aboutDeleteRepository(idabout);

      _loading.toggle();
      await Future.delayed(const Duration(seconds: 1));

      //manter este snackbar para mostra a resposta, o _message() não funciona!
      Get.snackbar(
        'Parabéns!',
        '"Quem somos" excluído com sucesso!',
        backgroundColor: Get.theme.colorScheme.primary,
        colorText: Get.theme.colorScheme.onPrimaryContainer,
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
      Get.offAndToNamed(Routes.about);
    }
  }

  Future<void> aboutUpdate(Map map) async {
    try {
      _loading.toggle();

      // await repository.aboutUpdateRepository(map);

      await Future.delayed(const Duration(seconds: 1));
      _loading.toggle();
      Get.offAndToNamed(Routes.about);
      _message(
        MessageModel(
          title: 'Parabéns!',
          message: 'Quem somos atualizado com sucesso!',
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
      Get.offAndToNamed(Routes.about);
    }
  }
}
