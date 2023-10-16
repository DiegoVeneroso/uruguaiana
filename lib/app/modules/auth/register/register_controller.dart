import 'package:appwrite/appwrite.dart';
import 'package:get_storage/get_storage.dart';
import 'package:uruguaiana/app/modules/auth/login/login_controller.dart';

import 'package:get/get.dart';
import 'package:uruguaiana/app/repository/auth_repository.dart';
import 'package:uruguaiana/app/routes/app_pages.dart';

import '../../../core/mixins/loader_mixin.dart';
import '../../../core/mixins/messages_mixin.dart';

class RegisterController extends GetxController
    with LoaderMixin, MessagesMixin {
  final AuthRepository authRepository;
  final GetStorage storage;

  RegisterController(
    this.authRepository,
    this.storage,
  );

  LoginController loginController = LoginController(
    AuthRepository(),
  );

  bool isFormValid = false;

  String msgErrorAppwriteException = '';

  Client client = Client();
  Databases? databases;

  Account? account;

  final _loading = false.obs;
  final _message = Rxn<MessageModel>();

  @override
  void onInit() {
    loaderListener(_loading);
    messageListener(_message);
    super.onInit();
  }

  Future<void> register({
    required String email,
    required String password,
    required String name,
    String? phone,
    String? url_avatar,
  }) async {
    try {
      _loading.toggle();

      await authRepository.register({
        "name": name,
        "email": email,
        "password": password,
        "profile": '',
        "phone": phone ?? '',
        "url_avatar": url_avatar ?? '',
      });
      _loading.toggle();
      _message(
        MessageModel(
          title: 'Parabéns!',
          message: 'Cadastrado com sucesso!',
          type: MessageType.success,
        ),
      );
      await loginController.login(email: email, password: password);
    } catch (e) {
      print(e.toString());
      _loading.toggle();

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
      Get.toNamed(Routes.login);
    }
  }
}
