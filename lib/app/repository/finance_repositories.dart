// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'dart:developer';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:eu_faco_parte/app/models/Finance_model.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../core/config/api_client.dart';
import '../core/config/constants.dart' as constants;

class FinanceRepository {
  RealtimeSubscription? subscription;
  RxList<FinanceModel> listItem = <FinanceModel>[].obs;
  RxString? search = ''.obs;
  GetStorage storage = GetStorage();
  var mycollaborateList = <FinanceModel>[].obs;

  Future<List<FinanceModel>> loadDataPlusRepository() async {
    try {
      DocumentList response;

      response = await ApiClient.databases.listDocuments(
        databaseId: constants.DATABASE_ID,
        collectionId: constants.COLLETION_FINANCE,
        queries: [Query.equal("type", "plus")],
      );

      var items = response.documents.reversed
          .map((docmodel) => FinanceModel(
                idFinance: docmodel.data['idFinance'],
                value: docmodel.data['value'],
                description: docmodel.data['description'],
                date: docmodel.data['date'],
                type: docmodel.data['type'],
                urlImage: docmodel.data['url_image'] ?? "",
              ))
          .toList();

      return items;
    } on AppwriteException catch (e) {
      log(e.response['type']);

      throw (e.response['type']);
    }
  }

  Future<List<FinanceModel>> loadDataMinusRepository() async {
    try {
      DocumentList response;

      response = await ApiClient.databases.listDocuments(
        databaseId: constants.DATABASE_ID,
        collectionId: constants.COLLETION_FINANCE,
        queries: [Query.equal("type", "minus")],
      );

      var items = response.documents.reversed
          .map((docmodel) => FinanceModel(
                idFinance: docmodel.data['idFinance'],
                value: docmodel.data['value'],
                description: docmodel.data['description'],
                date: docmodel.data['date'],
                type: docmodel.data['type'],
                urlImage: docmodel.data['url_image'] ?? "",
              ))
          .toList();

      return items;
    } on AppwriteException catch (e) {
      log(e.response['type']);

      throw (e.response['type']);
    }
  }

  Future<DocumentList> getTermOfUseRepository() async {
    try {
      var response = await ApiClient.databases.listDocuments(
        databaseId: constants.DATABASE_ID,
        collectionId: constants.COLLETION_TERM_OF_USE,
      );

      return response;
    } on AppwriteException catch (e) {
      log(e.response['type']);

      throw (e.response['type']);
    }
  }

  Future deleteImage(String fileId) {
    final response = ApiClient.storage.deleteFile(
      bucketId: constants.STORAGE_BUCKETS,
      fileId: fileId,
    );
    return response;
  }

  collaboratesAddRepository(Map map) async {
    try {
      final idUnique = DateTime.now().millisecondsSinceEpoch.toString();

      if (map["url_image"] == '' || map["url_image"] == null) {
        await ApiClient.databases.createDocument(
            databaseId: constants.DATABASE_ID,
            collectionId: constants.COLLETION_COLLABORATE_ID,
            documentId: idUnique,
            data: {
              'id_collaborate': idUnique,
              'name': map["name"],
              'phone': map["phone"],
              'description': map["description"],
              'date_time_created': DateTime.now().toString(),
            });

        //adicionar no storage

        String myCollaboratesString =
            await storage.read('my_collaborates_list');

        if (myCollaboratesString.isEmpty) {
          await storage.write('my_collaborates_list', myCollaboratesString);
        } else {
          jsonDecode(storage.read('my_collaborates_list').toString())
              .forEach((e) => mycollaborateList.add(FinanceModel.fromJson(e)));

          for (var e in [map]) {
            mycollaborateList.add(
              FinanceModel(
                idFinance: idUnique,
                value: e['name'],
                description: e['description'],
                urlImage: '',
              ),
            );
          }

          await storage.write(
              'my_collaborates_list', jsonEncode(mycollaborateList));
        }
      } else {
        String fileName = "$idUnique."
            "${map["url_image"].toString().split(".").last}";

        var urlImage =
            '${constants.API_END_POINT_STORAGE}${constants.STORAGE_BUCKETS}/files/$idUnique/view?project=${constants.PROJECT_ID}';

        await ApiClient.storage.createFile(
          bucketId: constants.STORAGE_BUCKETS,
          fileId: idUnique,
          file: InputFile(
            path: map["url_image"],
            filename: fileName,
          ),
        );

        await ApiClient.databases.createDocument(
            databaseId: constants.DATABASE_ID,
            collectionId: constants.COLLETION_COLLABORATE_ID,
            documentId: idUnique,
            data: {
              'id_collaborate': idUnique,
              'name': map["name"],
              'url_image': urlImage,
              'phone': map["phone"],
              'description': map["description"],
              'date_time_created': DateTime.now().toString(),
            });

        //adicionar no storage

        String myCollaboratesString =
            await storage.read('my_collaborates_list');

        if (myCollaboratesString.isEmpty) {
          await storage.write('my_collaborates_list', myCollaboratesString);
        } else {
          jsonDecode(storage.read('my_collaborates_list').toString())
              .forEach((e) => mycollaborateList.add(FinanceModel.fromJson(e)));

          for (var e in [map]) {
            mycollaborateList.add(
              FinanceModel(
                idFinance: idUnique,
                value: e['name'],
                description: e['description'],
                urlImage: urlImage,
              ),
            );
          }

          await storage.write(
              'my_collaborates_list', jsonEncode(mycollaborateList));
        }
      }
    } on AppwriteException catch (e) {
      log(e.response['type']);

      throw (e.response['type']);
    }
  }

  collaboratesDeleteRepository(String idFinances) async {
    try {
      await ApiClient.storage.deleteFile(
        bucketId: constants.STORAGE_BUCKETS,
        fileId: idFinances,
      );

      await ApiClient.databases.deleteDocument(
        databaseId: constants.DATABASE_ID,
        collectionId: constants.COLLETION_COLLABORATE_ID,
        documentId: idFinances,
      );
    } on AppwriteException catch (e) {
      log(e.response['type']);

      throw (e.response['type']);
    }
  }
}
