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

  Future<List<QuestionModel>> loadDataQuestionRepository() async {
    try {
      DocumentList response;

      response = await ApiClient.databases.listDocuments(
        databaseId: constants.DATABASE_ID,
        collectionId: constants.COLLETION_QUESTION,
      );

      var items = response.documents.reversed
          .map(
            (docmodel) => QuestionModel(
              idQuestion: docmodel.data['id_question'],
              question: docmodel.data['question'],
              listOptions: docmodel.data['list_options'],
            ),
          )
          .toList();

      return items;
    } on AppwriteException catch (e) {
      log(e.response['type']);

      throw (e.response['type']);
    }
  }

  Future<Document> getQuestionRepository(String? idQuestion) async {
    try {
      var response = await ApiClient.databases.getDocument(
        databaseId: constants.DATABASE_ID,
        collectionId: constants.COLLETION_QUESTION,
        documentId: idQuestion.toString(),
      );

      return response;
    } on AppwriteException catch (e) {
      log(e.response['type']);

      throw (e.response['type']);
    }
  }

  Future<Document> questionAddRepository(Map map) async {
    try {
      final idUnique = DateTime.now().millisecondsSinceEpoch.toString();

      Document result;

      bool opt3 = map["option_3"] == '' ? false : true;
      bool opt4 = map["option_4"] == '' ? false : true;
      bool opt5 = map["option_5"] == '' ? false : true;

      if (opt3 && !opt4 && !opt5) {
        result = await ApiClient.databases.createDocument(
          databaseId: constants.DATABASE_ID,
          collectionId: constants.COLLETION_QUESTION,
          documentId: idUnique,
          data: {
            'id_question': idUnique,
            'question': map["question"],
            'list_options':
                [map["option_1"], map["option_2"], map["option_3"]].toString(),
          },
        );
      } else if (opt3 && opt4 && !opt5) {
        result = await ApiClient.databases.createDocument(
          databaseId: constants.DATABASE_ID,
          collectionId: constants.COLLETION_QUESTION,
          documentId: idUnique,
          data: {
            'id_question': idUnique,
            'question': map["question"],
            'list_options': [
              map["option_1"],
              map["option_2"],
              map["option_3"],
              map["option_4"]
            ].toString(),
          },
        );
      } else if (opt3 && opt4 && opt5) {
        result = await ApiClient.databases.createDocument(
          databaseId: constants.DATABASE_ID,
          collectionId: constants.COLLETION_QUESTION,
          documentId: idUnique,
          data: {
            'id_question': idUnique,
            'question': map["question"],
            'list_options': [
              map["option_1"],
              map["option_2"],
              map["option_3"],
              map["option_4"],
              map["option_5"]
            ].toString(),
          },
        );
      } else {
        result = await ApiClient.databases.createDocument(
          databaseId: constants.DATABASE_ID,
          collectionId: constants.COLLETION_QUESTION,
          documentId: idUnique,
          data: {
            'id_question': idUnique,
            'question': map["question"],
            'list_options': [map["option_1"], map["option_2"]].toString(),
          },
        );
      }

      return result;
    } on AppwriteException catch (e) {
      log(e.response['type']);

      throw (e.response['type']);
    }
  }

  questionResponseAddRepository(Map map) async {
    try {
      final idUnique = DateTime.now().millisecondsSinceEpoch.toString();

      await ApiClient.databases.createDocument(
          databaseId: constants.DATABASE_ID,
          collectionId: constants.COLLETION_QUESTION_RESPONSE,
          documentId: idUnique,
          data: {
            'id_question_response': idUnique,
            'id_question': map["id_question"],
            'response': map["response"],
          });
    } on AppwriteException catch (e) {
      log(e.response['type']);

      throw (e.response['type']);
    }
  }
}
