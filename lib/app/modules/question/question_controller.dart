import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:appwrite/appwrite.dart' hide Permission;
import 'package:appwrite/models.dart';
import 'package:eu_faco_parte/app/models/question_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:eu_faco_parte/app/repository/auth_repository.dart';
import 'package:eu_faco_parte/app/routes/app_pages.dart';
import '../../core/config/api_client.dart';
import '../../core/config/constants.dart' as constants;
import '../../core/mixins/dialog_mixin.dart';
import '../../core/mixins/loader_mixin.dart';
import '../../core/mixins/messages_mixin.dart';
import 'package:http/http.dart' as http;
import '../../repository/question_repositories.dart';

class QuestionController extends GetxController
    with LoaderMixin, MessagesMixin, DialogMixin {
  RealtimeSubscription? subscription;
  QuestionRepository repository;
  AuthRepository authRepository;
  final _loading = false.obs;
  final _message = Rxn<MessageModel>();
  var questionList = <QuestionModel>[].obs;
  Rx<List<QuestionModel>> foundQuestion = Rx<List<QuestionModel>>([]);
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

  QuestionController({
    required this.repository,
    required this.authRepository,
  });

  @override
  onInit() {
    getIsAdmin();
    loaderListener(_loading);
    messageListener(_message);
    foundQuestion.value = questionList;

    super.onInit();
  }

  @override
  onReady() {
    subscribe();
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

  Future<bool> sendPushQuestion(
      {required String title,
      required String body,
      required String idQuestion}) async {
    const postUrl = 'https://fcm.googleapis.com/fcm/send';
    final data = {
      // "to":
      //     "cEKJD0-2QQ-DM-Dg2ejnZN:APA91bH_EmiRGaJyP_dWvnJ3EZvjovmaoRg7aUl3mD5IIK3XnlkzoG3ThJ6cc6I9HxcPuEG_QbyhZNo0X7THFh0v7oJWlo7M8wujhSPHBmfXdEqzAJ-8SvUO_qI2PBIywsV4niEGr70g",
      "to": "/topics/br.com.frontapp.uruguaiana",
      "notification": {
        "title": title,
        "body": body,
        "screen": "/question_response",
      },
      "data": {
        "title": title,
        "body": body,
        "screen": "/question_response",
        "id_question": idQuestion
        // "click_action": 'FLUTTER_NOTIFICATION_CLICK'
      }
    };

    final headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization':
          'key=AAAANQf4ge4:APA91bE-LywHQosV6dq1l8cbYjthVP85bTXo5kAokzK8jXOqchENT9VUIoFqFssRpgX5IIDpxiVbPaQLhBltG5EWs3mgbbemOAYpvx4Sk06lidPskgj20-K-B0PlWEnnoBtBnUqSrBCj',
    };

    final response = await http.post(
      Uri.parse(postUrl),
      body: json.encode(data),
      encoding: Encoding.getByName('utf-8'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      print('notificação enviada!');

      return true;
    } else {
      print(response.statusCode);
      print(response);
      print(' erro ao enviar notificação!');
      return false;
    }
  }

  Future<void> filternotifications(String notificationsName) async {
    List<QuestionModel> results = [];
    if (notificationsName.isEmpty) {
      results = questionList;
    } else {
      results = questionList
          .where((element) => element.question
              .toString()
              .toLowerCase()
              .contains(notificationsName.toLowerCase()))
          .toList();
    }
    foundQuestion.value = results;
  }

  Future<void> questionAdd(Map map) async {
    try {
      _loading.toggle();

      Document result = await repository.questionAddRepository(map);
      await sendPushQuestion(
        title: 'Uruguaiana que queremos!',
        body: 'Participe da nossa enquete!',
        idQuestion: result.$id.toString(),
      );

      await Future.delayed(const Duration(seconds: 1));
      _loading.toggle();
      Get.offAndToNamed(Routes.question);
      _message(
        MessageModel(
          title: 'Parabéns!',
          message:
              'Enquete criado com sucesso!\nTodos os usuários do app receberão uma notificação para responder',
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
      Get.offAndToNamed(Routes.question);
    }
  }

  Future<void> questionResponseAdd(Map map) async {
    try {
      _loading.toggle();

      await repository.questionResponseAddRepository(map);

      await Future.delayed(const Duration(seconds: 1));
      _loading.toggle();
      Get.offAndToNamed(Routes.news);
      _message(
        MessageModel(
          title: 'Parabéns!',
          message:
              'Enquete respondida com sucesso!\nAgradecemos pela participação!',
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
      Get.offAndToNamed(Routes.news);
    }
  }

  Future<int> countResultQuestion(
      {required String idQuestion, required String response}) async {
    try {
      var result = await repository.countResultQuestionRepository(
          idQuestion: idQuestion, response: response);
      return result;
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  Future<int> totalResultQuestion({required String idQuestion}) async {
    try {
      var result = await repository.totalResultQuestionRepository(
          idQuestion: idQuestion);
      return result;
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  void loadData() async {
    try {
      var result = await repository.loadDataQuestionRepository();

      questionList.assignAll(result);
    } catch (e, s) {
      _loading.toggle();
      log(e.toString());
      log(s.toString());
      _message(
        MessageModel(
          title: 'ATENÇÃO!',
          message: 'Erro carregar dados fsadfas!',
          type: MessageType.error,
        ),
      );
    }
  }

  Future<Document> getQuestions(String? idQuestion) async {
    try {
      var result = await repository.getQuestionRepository(idQuestion);
      return result;
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

  void subscribe() {
    final realtime = Realtime(ApiClient.account.client);

    subscription = realtime.subscribe([
      'databases.${constants.DATABASE_ID}.collections.${constants.COLLETION_QUESTION}.documents'
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
