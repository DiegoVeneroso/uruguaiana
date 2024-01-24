import 'dart:developer';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:get/get.dart';
import '../core/config/api_client.dart';
import '../core/config/constants.dart' as constants;
import '../models/question_model.dart';

class QuestionRepository {
  RealtimeSubscription? subscription;
  RxList<QuestionModel> listItem = <QuestionModel>[].obs;

  Future<List<QuestionModel>> loadDataRepository() async {
    try {
      DocumentList response;

      response = await ApiClient.databases.listDocuments(
        databaseId: constants.DATABASE_ID,
        collectionId: constants.COLLETION_NOTIFICATION_ID,
      );

      var items = response.documents.reversed
          .map(
            (docmodel) => QuestionModel(
              idQuestion: docmodel.data['id_notification'],
              question: docmodel.data['title'],
              option1: docmodel.data['message'],
              option2: docmodel.data['message'],
              option3: docmodel.data['message'],
              option4: docmodel.data['message'],
              option5: docmodel.data['message'],
            ),
          )
          .toList();

      return items;
    } on AppwriteException catch (e) {
      log(e.response['type']);

      throw (e.response['type']);
    }
  }

  questionAddRepository(Map map) async {
    try {
      final idUnique = DateTime.now().millisecondsSinceEpoch.toString();

      await ApiClient.databases.createDocument(
          databaseId: constants.DATABASE_ID,
          collectionId: constants.COLLETION_QUESTION,
          documentId: idUnique,
          data: {
            'id_question': idUnique,
            'question': map["question"],
            'option_1': map["option_1"],
            'option_2': map["option_2"],
            'option_3': map["option_3"],
            'option_4': map["option_4"],
            'option_5': map["option_5"],
          });
    } on AppwriteException catch (e) {
      log(e.response['type']);

      throw (e.response['type']);
    }
  }
}
