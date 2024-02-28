import 'dart:developer';

import 'package:get/get.dart';
import 'package:eu_faco_parte/app/routes/app_pages.dart';

import '../../../core/mixins/loader_mixin.dart';
import '../../../core/mixins/messages_mixin.dart';
import '../../../repository/auth_repository.dart';

class RecoveyPasswordController extends GetxController
    with LoaderMixin, MessagesMixin {
  AuthRepository authRepository;

  RecoveyPasswordController(this.authRepository);

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

  moveToHome() {
    Get.toNamed(Routes.home);
  }

  Future<void> recoveryPassword({
    required String email,
  }) async {
    try {
      _loading.toggle();

      await authRepository.recoveryPassword(email);

      _message(
        MessageModel(
          title: 'Parabéns!',
          message: 'Foi enviado para o e-mail o link de recuperação da senha!',
          type: MessageType.success,
        ),
      );
      Get.toNamed(Routes.login);
    } catch (e) {
      _loading.toggle();

      log(e.toString());
      late String text;
      switch (e) {
        case 'user_not_found':
          text = 'E-mail não cadastrado!\nCadastre-se no app!';
          break;
        case 'general_rate_limit_exceeded':
          text =
              'Muitas tentativas de recuperação da senha!\nTente novamente mais tarde!';
          break;
      }

      _message(
        MessageModel(
          title: 'ATENÇÃO!',
          message: text,
          type: MessageType.error,
        ),
      );
      Get.toNamed(Routes.login);
    }
  }
}
