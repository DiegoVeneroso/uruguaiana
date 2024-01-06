import 'dart:developer';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:uruguaiana/app/models/my_contact_model.dart';
import '../core/config/api_client.dart';
import '../core/config/constants.dart' as constants;
import '../models/notification_model.dart';

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
      await ApiClient.databases.createDocument(
          databaseId: constants.DATABASE_ID,
          collectionId: constants.COLLETION_CONTACT,
          documentId: "facebook",
          data: {
            'name': "facebook",
            'url': map["facebook"],
          });

      await ApiClient.databases.createDocument(
          databaseId: constants.DATABASE_ID,
          collectionId: constants.COLLETION_CONTACT,
          documentId: "instagram",
          data: {
            'name': "instagram",
            'url': map["instagram"],
          });

      await ApiClient.databases.createDocument(
          databaseId: constants.DATABASE_ID,
          collectionId: constants.COLLETION_CONTACT,
          documentId: "whatsapp",
          data: {
            'name': "whatsapp",
            'url': map["whatsapp"],
          });
    } on AppwriteException catch (e) {
      log(e.response['type']);

      throw (e.response['type']);
    }
  }
}
