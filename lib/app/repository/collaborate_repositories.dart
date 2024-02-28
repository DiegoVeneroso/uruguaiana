// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'dart:developer';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../core/config/api_client.dart';
import '../core/config/constants.dart' as constants;
import '../models/collaborate_model.dart';

class ColaborateRepository {
  RealtimeSubscription? subscription;
  RxList<CollaborateModel> listItem = <CollaborateModel>[].obs;
  RxString? search = ''.obs;
  GetStorage storage = GetStorage();
  var mycollaborateList = <CollaborateModel>[].obs;

  Future<List<CollaborateModel>> loadDataRepository() async {
    try {
      DocumentList response;

      if (search?.value != '') {
        response = await ApiClient.databases.listDocuments(
          databaseId: constants.DATABASE_ID,
          collectionId: constants.COLLETION_COLLABORATE_ID,
          queries: [Query.search("name", search!.value.toString())],
        );

        var items = response.documents.reversed
            .map((docmodel) => CollaborateModel(
                  idCollaborate: docmodel.data['idCollaborate'],
                  name: docmodel.data['name'],
                  urlImage: docmodel.data['url_image'] ?? "",
                  phone: docmodel.data['phone'],
                  description: docmodel.data['description'],
                  dateTimeCreated: docmodel.data['date_time_created'],
                ))
            .toList();

        return items;
      } else {
        response = await ApiClient.databases.listDocuments(
          databaseId: constants.DATABASE_ID,
          collectionId: constants.COLLETION_COLLABORATE_ID,
        );

        var items = response.documents.reversed
            .map((docmodel) => CollaborateModel(
                  idCollaborate: docmodel.data['idCollaborate'],
                  name: docmodel.data['name'],
                  urlImage: docmodel.data['url_image'] ?? "",
                  phone: docmodel.data['phone'],
                  description: docmodel.data['description'],
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
          jsonDecode(storage.read('my_collaborates_list').toString()).forEach(
              (e) => mycollaborateList.add(CollaborateModel.fromJson(e)));

          for (var e in [map]) {
            mycollaborateList.add(
              CollaborateModel(
                idCollaborate: idUnique,
                name: e['name'],
                phone: e['phone'],
                description: e['description'],
                urlImage: '',
                dateTimeCreated: DateTime.now().toString(),
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
          jsonDecode(storage.read('my_collaborates_list').toString()).forEach(
              (e) => mycollaborateList.add(CollaborateModel.fromJson(e)));

          for (var e in [map]) {
            mycollaborateList.add(
              CollaborateModel(
                idCollaborate: idUnique,
                name: e['name'],
                phone: e['phone'],
                description: e['description'],
                urlImage: urlImage,
                dateTimeCreated: DateTime.now().toString(),
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

  collaboratesDeleteRepository(String idcollaborates) async {
    try {
      await ApiClient.storage.deleteFile(
        bucketId: constants.STORAGE_BUCKETS,
        fileId: idcollaborates,
      );

      await ApiClient.databases.deleteDocument(
        databaseId: constants.DATABASE_ID,
        collectionId: constants.COLLETION_COLLABORATE_ID,
        documentId: idcollaborates,
      );
    } on AppwriteException catch (e) {
      log(e.response['type']);

      throw (e.response['type']);
    }
  }
}
