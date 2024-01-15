// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';
import 'package:appwrite/appwrite.dart' hide Permission;
import 'package:appwrite/models.dart';
import 'package:eu_faco_parte/app/models/token_donate_model.dart';
import 'package:eu_faco_parte/app/repository/donate_repositories.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:eu_faco_parte/app/repository/auth_repository.dart';
import 'package:eu_faco_parte/app/routes/app_pages.dart';
import '../../core/config/api_client.dart';
import '../../core/mixins/dialog_mixin.dart';
import '../../core/mixins/loader_mixin.dart';
import '../../core/mixins/messages_mixin.dart';
import '../../core/config/constants.dart' as constants;

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
        return [
          TokenDonateModel(
            value: 'vazio',
          ),
        ];
      } else {
        var listToken = result.documents
            .map(
              (docmodel) => TokenDonateModel(
                value: docmodel.data['value'],
              ),
            )
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

  Future<void> donateTokenUpdate(Map map) async {
    try {
      _loading.toggle();

      await repository.adminTokenEditRepository(map);

      await Future.delayed(const Duration(seconds: 1));
      _loading.toggle();
      Get.offAndToNamed(Routes.donate_admin_page);
      _message(
        MessageModel(
          title: 'Parabéns!',
          message: 'Token atualizado com sucesso!',
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

  Future<DocumentList> tokenPaymentIsEmpty() async {
    try {
      var res = await authRepository.getTokenAdminUserRepository();

      return res;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<DocumentList> getTokenPayment() async {
    try {
      var result = await repository.getTokenPaymentRepository();

      return result;
    } catch (e) {
      print(e.toString());

      _message(
        MessageModel(
          title: 'ATENÇÃO!',
          message: e.toString(),
          type: MessageType.error,
        ),
      );
      rethrow;
    }
  }
}
