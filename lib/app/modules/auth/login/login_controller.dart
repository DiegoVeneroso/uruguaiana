// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:uruguaiana/app/models/user_model.dart';

import 'package:uruguaiana/app/routes/app_pages.dart';

import '../../../core/mixins/loader_mixin.dart';
import '../../../core/mixins/messages_mixin.dart';
import '../../../repository/auth_repository.dart';

class LoginController extends GetxController with LoaderMixin, MessagesMixin {
  AuthRepository authRepository;
  GetStorage storage = GetStorage();

  LoginController(
    this.authRepository,
  );

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String msgErrorAppwriteException = '';

  final _loading = false.obs;
  final _message = Rxn<MessageModel>();

  @override
  void onInit() {
    loaderListener(_loading);
    messageListener(_message);
    super.onInit();
  }

  moveToRegister() {
    Get.toNamed(Routes.register);
  }

  moveToRecoveryPassword() {
    Get.toNamed(Routes.recovery_password);
  }

  moveToHome() {
    Get.toNamed(Routes.home);
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    try {
      _loading.toggle();

      var session =
          await authRepository.login({"email": email, "password": password});

      var idUser = session.userId;

      var result = await authRepository.getUserById(idUser.toString());

      await storage.write('id_user', result.id ?? '');
      await storage.write('name', result.name);
      await storage.write('email', result.email);
      await storage.write('url_avatar', result.urlAvatar ?? '');
      await storage.write('toke_push', result.tokenPush ?? '');
      await storage.write('phone', result.phone ?? '');
      await storage.write('profile', result.profile ?? '');

      _message(
        MessageModel(
          title: 'Parabéns!',
          message: 'Conectado com sucesso!',
          type: MessageType.success,
        ),
      );
      Get.toNamed(Routes.splash);
    } catch (e) {
      _loading.toggle();

      log(e.toString());
      switch (e) {
        case 'general_rate_limit_exceeded':
          msgErrorAppwriteException =
              'Muitas tentativas de acesso! \nTente mais tarde.';
          break;
        case 'user_email_already_exists':
          msgErrorAppwriteException =
              'E-mail já cadastrado! \nRecupere a senha de acesso.';
          break;
        case 'user_already_exists':
          msgErrorAppwriteException =
              'Usuário já cadastrado! \nRecupere a senha de acesso.';
          break;
        case 'user_invalid_credentials':
          msgErrorAppwriteException =
              'Usuario ou senha não conferem! \nVerifique seu usuario e senha.';
          break;
      }
      _message(
        MessageModel(
          title: 'Atenção!',
          message: msgErrorAppwriteException,
          type: MessageType.error,
        ),
      );
    }
  }

  Future<UserModel> getProfile() async {
    try {
      var idUser = await storage.read('id_user');
      var user = await authRepository.getUserById(idUser);

      return user;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      _loading.toggle();
      await authRepository.logout();

      await storage.write('id_user', '');
      await storage.write('name', '');
      await storage.write('email', '');
      await storage.write('url_avatar', '');
      await storage.write('toke_push', '');
      await storage.write('phone', '');

      Get.toNamed(Routes.splash);
    } catch (e) {
      _loading.toggle();
      log(e.toString());
    }
  }
}
