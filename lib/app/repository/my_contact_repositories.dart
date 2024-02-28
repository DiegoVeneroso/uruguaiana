import 'dart:developer';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:get_storage/get_storage.dart';
import 'package:eu_faco_parte/app/models/my_contact_model.dart';
import '../core/config/api_client.dart';
import '../core/config/constants.dart' as constants;

class MyContactRepository {
  RealtimeSubscription? subscription;
  // List<Map<String, dynamic>> listContact = <Map<String, dynamic>>[].obs;
  GetStorage storage = GetStorage();

  Future<List<MyContactModel>> loadDataRepository() async {
    try {
      DocumentList response;

      response = await ApiClient.databases.listDocuments(
        databaseId: constants.DATABASE_ID,
        collectionId: constants.COLLETION_CONTACT,
      );

      var items = response.documents
          .map((docmodel) => MyContactModel(
                name: docmodel.data['name'],
                url: docmodel.data['url'],
              ))
          .toList();

      return items;
    } on AppwriteException catch (e) {
      log(e.response['type']);

      throw (e.response['type']);
    }
  }

  myContactAddRepository(Map map) async {
    try {
      final docs = await ApiClient.databases.listDocuments(
        databaseId: constants.DATABASE_ID,
        collectionId: constants.COLLETION_CONTACT,
      );

      if (docs.documents.isEmpty) {
        await ApiClient.databases.createDocument(
            databaseId: constants.DATABASE_ID,
            collectionId: constants.COLLETION_CONTACT,
            documentId: "facebook",
            data: {
              'name': "facebook",
              'url':
                  "https://www.facebook.com/profile.php?id=${map["facebook"]}",
            });

        await ApiClient.databases.createDocument(
            databaseId: constants.DATABASE_ID,
            collectionId: constants.COLLETION_CONTACT,
            documentId: "instagram",
            data: {
              'name': "instagram",
              'url': "https://www.instagram.com/${map["instagram"]}",
            });

        String phone = map["whatsapp"].replaceAll(RegExp('[^0-9]'), '');

        await ApiClient.databases.createDocument(
            databaseId: constants.DATABASE_ID,
            collectionId: constants.COLLETION_CONTACT,
            documentId: "whatsapp",
            data: {
              'name': "whatsapp",
              'url': "https://wa.me/55$phone",
            });
      } else {
        for (var doc in docs.documents) {
          final id = doc.data['\$id'];
          await await ApiClient.databases.deleteDocument(
            databaseId: constants.DATABASE_ID,
            collectionId: constants.COLLETION_CONTACT,
            documentId: id,
          );
        }

        await ApiClient.databases.createDocument(
            databaseId: constants.DATABASE_ID,
            collectionId: constants.COLLETION_CONTACT,
            documentId: "facebook",
            data: {
              'name': "facebook",
              'url':
                  "https://www.facebook.com/profile.php?id=${map["facebook"]}",
            });

        await ApiClient.databases.createDocument(
            databaseId: constants.DATABASE_ID,
            collectionId: constants.COLLETION_CONTACT,
            documentId: "instagram",
            data: {
              'name': "instagram",
              'url': "https://www.instagram.com/${map["instagram"]}",
            });

        String phone = map["whatsapp"].replaceAll(RegExp('[^0-9]'), '');

        await ApiClient.databases.createDocument(
            databaseId: constants.DATABASE_ID,
            collectionId: constants.COLLETION_CONTACT,
            documentId: "whatsapp",
            data: {
              'name': "whatsapp",
              'url': "https://wa.me/55$phone",
            });
      }
    } on AppwriteException catch (e) {
      log(e.response['type']);

      throw (e.response['type']);
    }
  }

  Future<DocumentList> getContactFacebookRepository() async {
    try {
      var result = await ApiClient.databases.listDocuments(
        databaseId: constants.DATABASE_ID,
        collectionId: constants.COLLETION_CONTACT,
        queries: [Query.equal("name", 'facebook')],
      );

      return result;
    } on AppwriteException catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<DocumentList> getContactInstagramRepository() async {
    try {
      var result = await ApiClient.databases.listDocuments(
        databaseId: constants.DATABASE_ID,
        collectionId: constants.COLLETION_CONTACT,
        queries: [Query.equal("name", 'instagram')],
      );

      return result;
    } on AppwriteException catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<DocumentList> getContactWhatsappRepository() async {
    try {
      var result = await ApiClient.databases.listDocuments(
        databaseId: constants.DATABASE_ID,
        collectionId: constants.COLLETION_CONTACT,
        queries: [Query.equal("name", 'whatsapp')],
      );

      return result;
    } on AppwriteException catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}
