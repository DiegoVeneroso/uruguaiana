import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import '../core/config/api_client.dart';
import '../core/config/constants.dart' as constants;
import '../models/about_model.dart';

class AboutRepository {
  RealtimeSubscription? subscription;
  RxList<AboutModel> aboutItem = <AboutModel>[].obs;
  RxString? search = ''.obs;
  GetStorage storage = GetStorage();

  Future<List<AboutModel>> loadDataRepository() async {
    try {
      DocumentList response;

      if (search?.value != '') {
        response = await ApiClient.databases.listDocuments(
          databaseId: constants.DATABASE_ID,
          collectionId: constants.COLLETION_ABOUT_ID,
          queries: [Query.search("title", search!.value.toString())],
        );

        var items = response.documents.reversed
            .map((docmodel) => AboutModel(
                  idAbout: docmodel.data['idAbout'],
                  title: docmodel.data['title'],
                  urlImage: docmodel.data['url_image'],
                  description: docmodel.data['description'],
                ))
            .toList();

        return items;
      } else {
        response = await ApiClient.databases.listDocuments(
          databaseId: constants.DATABASE_ID,
          collectionId: constants.COLLETION_ABOUT_ID,
        );

        var items = response.documents.reversed
            .map((docmodel) => AboutModel(
                  idAbout: docmodel.data['idAbout'],
                  title: docmodel.data['title'],
                  urlImage: docmodel.data['url_image'],
                  description: docmodel.data['description'],
                ))
            .toList();

        return items;
      }
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

  aboutAddRepository(Map map) async {
    try {
      if (map['url_image'] != "") {
        final idUnique = DateTime.now().millisecondsSinceEpoch.toString();

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
            collectionId: constants.COLLETION_ABOUT_ID,
            documentId: idUnique,
            data: {
              'idAbout': idUnique,
              'title': map["title"],
              'url_image': urlImage,
              'description': map["description"],
            });
      }
    } on AppwriteException catch (e) {
      log(e.response['type']);

      throw (e.response['type']);
    }
  }

  aboutDeleteRepository(String idAbout) async {
    try {
      await ApiClient.storage.deleteFile(
        bucketId: constants.STORAGE_BUCKETS,
        fileId: idAbout,
      );

      await ApiClient.databases.deleteDocument(
        databaseId: constants.DATABASE_ID,
        collectionId: constants.COLLETION_ABOUT_ID,
        documentId: idAbout,
      );
    } on AppwriteException catch (e) {
      log(e.response['type']);

      throw (e.response['type']);
    }
  }

  aboutUpdateRepository(Map map) async {
    try {
      if (map["url_image"] == '') {
        await ApiClient.databases.updateDocument(
            databaseId: constants.DATABASE_ID,
            collectionId: constants.COLLETION_ABOUT_ID,
            documentId: map["idAbout"],
            data: {
              'title': map["title"],
              'description': map["description"],
              'updated_by': storage.read('id_user').toString(),
              'date_time_updated': DateTime.now().toString(),
            });
      } else {
        await ApiClient.storage.deleteFile(
          bucketId: constants.STORAGE_BUCKETS,
          fileId: map["idAbout"],
        );

        final idUnique = map["idAbout"];

        String fileName = "$idUnique."
            "${map["url_image"].toString().split(".").last}";

        var urlImage =
            '${constants.API_END_POINT_STORAGE}${constants.STORAGE_BUCKETS}/files/$idUnique/view?project=${constants.PROJECT_ID}';

        await ApiClient.storage.createFile(
          bucketId: constants.STORAGE_BUCKETS,
          fileId: idUnique,
          file: InputFile.fromPath(
            path: map["url_image"],
            filename: fileName,
          ),
        );

        await ApiClient.databases.updateDocument(
            databaseId: constants.DATABASE_ID,
            collectionId: constants.COLLETION_ABOUT_ID,
            documentId: map["idAbout"],
            data: {
              'idAbout': map["idAbout"],
              'title': map["title"],
              'url_image': urlImage,
              'description': map["description"],
              // 'updated_by': storage.read('id_user').toString(),
              // 'date_time_updated': DateTime.now().toString(),
            });
      }
    } on AppwriteException catch (e) {
      log(e.response['type']);

      throw (e.response['type']);
    }
  }

  Future getDropdowValueRepository(String labelAndColecctionList) async {
    try {
      var result = await ApiClient.databases.listDocuments(
        databaseId: constants.DATABASE_ID,
        collectionId: constants.COLLETION_DROPDOWN_ID,
        queries: [Query.equal("name", labelAndColecctionList)],
      );
      return result.documents.first;
    } on AppwriteException catch (e) {
      log(e.response['type']);

      throw (e.response['type']);
    }
  }
}
