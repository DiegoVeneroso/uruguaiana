import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:get/get.dart';
import '../core/config/api_client.dart';
import '../core/config/constants.dart' as constants;
import '../models/about_model.dart';

class CalendarRepository {
  RealtimeSubscription? subscription;
  RxList<AboutModel> aboutItem = <AboutModel>[].obs;

  loadDataRepository() async {
    try {
      var response = await ApiClient.databases.listDocuments(
        databaseId: constants.DATABASE_ID,
        collectionId: constants.COLLETION_CALENDAR,
      );
      return response;
    } on AppwriteException catch (e) {
      log(e.response['type']);

      throw (e.response['type']);
    }
  }

  eventAddRepository(Map map) async {
    try {
      DocumentList result = await ApiClient.databases.listDocuments(
        databaseId: constants.DATABASE_ID,
        collectionId: constants.COLLETION_CALENDAR,
        queries: [Query.equal("datetime", map['datetime'].toString())],
      );

      if (result.documents.isEmpty) {
        final idUnique = DateTime.now().millisecondsSinceEpoch.toString();

        await ApiClient.databases.createDocument(
            databaseId: constants.DATABASE_ID,
            collectionId: constants.COLLETION_CALENDAR,
            documentId: idUnique,
            data: {
              'idCalendar': idUnique,
              'event': [map['event']],
              'datetime': map['datetime'],
            });
      } else {
        String listApiString = result.documents.first.data['event'].toString();

        List<String> arrayList = listApiString
            .replaceAll('[', '')
            .replaceAll(']', '')
            // .replaceAll(',', '')
            .split(',');

        arrayList.add(map['event']);

        await ApiClient.databases.updateDocument(
            databaseId: constants.DATABASE_ID,
            collectionId: constants.COLLETION_CALENDAR,
            documentId: result.documents.first.$id,
            data: {'event': arrayList});
      }
    } on AppwriteException catch (e) {
      log(e.response['type']);

      throw (e.response['type']);
    }
  }
}
