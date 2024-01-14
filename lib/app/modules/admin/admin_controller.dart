// ignore_for_file: public_member_api_docs, sort_constructors_firstimport 'dart:io';
import 'package:appwrite/appwrite.dart' hide Permission;
import 'package:eu_faco_parte/app/repository/donate_repositories.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import 'package:eu_faco_parte/app/repository/auth_repository.dart';
import 'package:eu_faco_parte/app/routes/app_pages.dart';

import '../../core/config/constants.dart' as constants;
import '../../core/mixins/dialog_mixin.dart';
import '../../core/mixins/loader_mixin.dart';
import '../../core/mixins/messages_mixin.dart';
import '../../models/about_model.dart';

import 'package:http/http.dart' as http;

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
