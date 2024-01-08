import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:uruguaiana/app/models/term_model.dart';
import '../core/config/api_client.dart';
import '../core/config/constants.dart' as constants;
import '../models/about_model.dart';

class TermOfUseRepository {
  Future<List<TermModel>> loadDataRepository() async {
    try {
      DocumentList response;

      response = await ApiClient.databases.listDocuments(
        databaseId: constants.DATABASE_ID,
        collectionId: constants.COLLETION_TERM_OF_USE,
      );

      var items = response.documents.reversed
          .map((docmodel) => TermModel(
                idTerm: docmodel.data['idTerm'],
                descripton: docmodel.data['description'],
              ))
          .toList();

      return items;
    } on AppwriteException catch (e) {
      log(e.response['type']);

      throw (e.response['type']);
    }
  }

  termoOfUseAddRepository(Map map) async {
    try {
      final idUnique = DateTime.now().millisecondsSinceEpoch.toString();

      await ApiClient.databases.createDocument(
          databaseId: constants.DATABASE_ID,
          collectionId: constants.COLLETION_TERM_OF_USE,
          documentId: idUnique,
          data: {
            'idTerm': idUnique,
            'description': map["description"],
          });
    } on AppwriteException catch (e) {
      log(e.response['type']);

      throw (e.response['type']);
    }
  }

  termoOfUseDeleteRepository(String idTerm) async {
    try {
      await ApiClient.databases.deleteDocument(
        databaseId: constants.DATABASE_ID,
        collectionId: constants.COLLETION_TERM_OF_USE,
        documentId: idTerm,
      );
    } on AppwriteException catch (e) {
      log(e.response['type']);

      throw (e.response['type']);
    }
  }

  termOfUseUpdateRepository(Map map) async {
    try {
      await ApiClient.databases.updateDocument(
          databaseId: constants.DATABASE_ID,
          collectionId: constants.COLLETION_TERM_OF_USE,
          documentId: map["idTerm"],
          data: {
            'description': map["description"],
          });
    } on AppwriteException catch (e) {
      log(e.response['type']);

      throw (e.response['type']);
    }
  }
}
