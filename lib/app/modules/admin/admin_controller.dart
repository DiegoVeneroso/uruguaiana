// ignore_for_file: public_member_api_docs, sort_constructors_firstimport 'dart:io';
import 'package:appwrite/appwrite.dart' hide Permission;
import 'package:get/get.dart';
import 'package:eu_faco_parte/app/repository/auth_repository.dart';
import '../../core/mixins/dialog_mixin.dart';
import '../../core/mixins/loader_mixin.dart';
import '../../core/mixins/messages_mixin.dart';

class AdminController extends GetxController
    with LoaderMixin, MessagesMixin, DialogMixin {
  RealtimeSubscription? subscription;

  AuthRepository authRepository;
  final _loading = false.obs;
  final _message = Rxn<MessageModel>();

  var isDarkMode = false.obs;

  RxBool isAdmin = false.obs;

  AdminController({
    required this.authRepository,
  });

  @override
  onInit() {
    loaderListener(_loading);
    messageListener(_message);

    super.onInit();
  }
}
