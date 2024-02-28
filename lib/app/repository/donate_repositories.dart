import 'dart:developer';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
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

  adminTokenEditRepository(Map map) async {
    try {
      var response = await ApiClient.databases.listDocuments(
          databaseId: constants.DATABASE_ID,
          collectionId: constants.COLLETION_CONFIG,
          queries: [Query.equal("parameter", 'access_token')]);

      String idToken = response.documents.first.$id;

      await ApiClient.databases.updateDocument(
          databaseId: constants.DATABASE_ID,
          collectionId: constants.COLLETION_CONFIG,
          documentId: idToken,
          data: {
            'value': map["value"],
          });
    } on AppwriteException catch (e) {
      log(e.response['type']);

      throw (e.response['type']);
    }
  }

  Future<DocumentList> getTokenPaymentRepository() async {
    try {
      var response = await ApiClient.databases.listDocuments(
          databaseId: constants.DATABASE_ID,
          collectionId: constants.COLLETION_CONFIG,
          queries: [Query.equal("parameter", 'access_token')]);

      return response;
    } on AppwriteException catch (e) {
      log(e.response['type']);

      throw (e.response['type']);
    }
  }

  Future<DocumentList> getAdminUserRepository() async {
    try {
      var response = await ApiClient.databases.listDocuments(
          databaseId: constants.DATABASE_ID,
          collectionId: constants.COLLETION_CONFIG,
          queries: [Query.equal("parameter", 'menu_admin')]);

      return response;
    } on AppwriteException catch (e) {
      log(e.response['type']);

      throw (e.response['type']);
    }
  }
}
