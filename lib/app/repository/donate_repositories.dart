import 'dart:developer';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:eu_faco_parte/app/models/token_donate_model.dart';
import '../core/config/api_client.dart';
import '../core/config/constants.dart' as constants;

class DonateRepository {
  Future<DocumentList> loadDataRepository() async {
    try {
      var response = await ApiClient.databases.listDocuments(
        databaseId: constants.DATABASE_ID,
        collectionId: constants.COLLETION_CONFIG,
        queries: [Query.equal("parameter", 'access_token')],
      );
      return response;
    } on AppwriteException catch (e) {
      log(e.response['type']);

      throw (e.response['type']);
    }
  }

  adminTokenAddRepository(Map map) async {
    try {
      final idUnique = DateTime.now().millisecondsSinceEpoch.toString();

      await ApiClient.databases.createDocument(
          databaseId: constants.DATABASE_ID,
          collectionId: constants.COLLETION_CONFIG,
          documentId: idUnique,
          data: {
            'parameter': 'access_token',
            'value': map["value"],
          });
    } on AppwriteException catch (e) {
      log(e.response['type']);

      throw (e.response['type']);
    }
  }
}
