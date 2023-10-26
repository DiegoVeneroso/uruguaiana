import 'dart:developer';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../core/config/api_client.dart';
import '../core/config/constants.dart' as constants;
import '../models/notification_model.dart';

class NotificationRepository {
  RealtimeSubscription? subscription;
  RxList<NotificationModel> listItem = <NotificationModel>[].obs;
  RxString? search = ''.obs;
  GetStorage storage = GetStorage();

  Future<List<NotificationModel>> loadDataRepository() async {
    try {
      DocumentList response;

      if (search?.value != '') {
        response = await ApiClient.databases.listDocuments(
          databaseId: constants.DATABASE_ID,
          collectionId: constants.COLLETION_NOTIFICATION_ID,
          queries: [Query.search("title", search!.value.toString())],
        );

        var items = response.documents.reversed
            .map((docmodel) => NotificationModel(
                  idNotification: docmodel.data['id_notification'],
                  title: docmodel.data['title'],
                  message: docmodel.data['message'],
                  createdBy: docmodel.data['created_by'],
                  dateTimeCreated: docmodel.data['date_time_created'],
                ))
            .toList();

        return items;
      } else {
        response = await ApiClient.databases.listDocuments(
          databaseId: constants.DATABASE_ID,
          collectionId: constants.COLLETION_NOTIFICATION_ID,
        );

        var items = response.documents.reversed
            .map((docmodel) => NotificationModel(
                  idNotification: docmodel.data['id_notification'],
                  title: docmodel.data['title'],
                  message: docmodel.data['message'],
                  createdBy: docmodel.data['created_by'],
                  dateTimeCreated: docmodel.data['date_time_created'],
                ))
            .toList();

        return items;
      }
    } on AppwriteException catch (e) {
      log(e.response['type']);

      throw (e.response['type']);
    }
  }

  notificationsAddRepository(Map map) async {
    try {
      final idUnique = DateTime.now().millisecondsSinceEpoch.toString();
      final idUser = await storage.read('id_user');

      await ApiClient.databases.createDocument(
          databaseId: constants.DATABASE_ID,
          collectionId: constants.COLLETION_NOTIFICATION_ID,
          documentId: idUnique,
          data: {
            'id_notification': idUnique,
            'title': map["title"],
            'message': map["message"],
            'parameter': map["description"] ?? "",
            'created_by': idUser,
            'date_time_created': DateTime.now().toString(),
          });
    } on AppwriteException catch (e) {
      log(e.response['type']);

      throw (e.response['type']);
    }
  }
}
