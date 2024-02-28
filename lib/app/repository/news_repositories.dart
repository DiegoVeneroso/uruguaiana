// ignore_for_file: deprecated_member_use

import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import '../core/config/api_client.dart';
import '../core/config/constants.dart' as constants;
import '../models/news_model.dart';

class NewsRepository {
  RealtimeSubscription? subscription;
  RxList<NewsModel> listItem = <NewsModel>[].obs;
  RxString? search = ''.obs;
  GetStorage storage = GetStorage();

  Future<List<NewsModel>> loadDataRepository() async {
    try {
      DocumentList response;

      if (search?.value != '') {
        response = await ApiClient.databases.listDocuments(
          databaseId: constants.DATABASE_ID,
          collectionId: constants.COLLETION_NEWS_ID,
          queries: [Query.search("title", search!.value.toString())],
        );

        var items = response.documents.reversed
            .map((docmodel) => NewsModel(
                  idNews: docmodel.data['idNews'],
                  title: docmodel.data['title'],
                  urlImage: docmodel.data['url_image'],
                  description: docmodel.data['description'],
                  date: docmodel.data['date'],
                ))
            .toList();

        return items;
      } else {
        response = await ApiClient.databases.listDocuments(
          databaseId: constants.DATABASE_ID,
          collectionId: constants.COLLETION_NEWS_ID,
        );

        var items = response.documents.reversed
            .map((docmodel) => NewsModel(
                  idNews: docmodel.data['idNews'],
                  title: docmodel.data['title'],
                  urlImage: docmodel.data['url_image'],
                  description: docmodel.data['description'],
                  date: docmodel.data['date'],
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

  newsAddRepository(Map map) async {
    try {
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
          collectionId: constants.COLLETION_NEWS_ID,
          documentId: idUnique,
          data: {
            'idNews': idUnique,
            'title': map["title"],
            'url_image': urlImage,
            'description': map["description"],
            'date': DateFormat(DateFormat.YEAR_MONTH_DAY, 'pt_Br')
                .format(DateTime.now())
                .toString(),
            'created_by': storage.read('id_user').toString(),
            'date_time_created': DateTime.now().toString(),
          });
    } on AppwriteException catch (e) {
      log(e.response['type']);

      throw (e.response['type']);
    }
  }

  newsDeleteRepository(String idNews) async {
    try {
      await ApiClient.storage.deleteFile(
        bucketId: constants.STORAGE_BUCKETS,
        fileId: idNews,
      );

      await ApiClient.databases.deleteDocument(
        databaseId: constants.DATABASE_ID,
        collectionId: constants.COLLETION_NEWS_ID,
        documentId: idNews,
      );
    } on AppwriteException catch (e) {
      log(e.response['type']);

      throw (e.response['type']);
    }
  }

  newsUpdateRepository(Map map) async {
    try {
      if (map["url_image"] == '') {
        await ApiClient.databases.updateDocument(
            databaseId: constants.DATABASE_ID,
            collectionId: constants.COLLETION_NEWS_ID,
            documentId: map["idNews"],
            data: {
              'title': map["title"],
              'description': map["description"],
              'updated_by': storage.read('id_user').toString(),
              'date_time_updated': DateTime.now().toString(),
            });
      } else {
        await ApiClient.storage.deleteFile(
          bucketId: constants.STORAGE_BUCKETS,
          fileId: map["idNews"],
        );

        final idUnique = map["idNews"];

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
            collectionId: constants.COLLETION_NEWS_ID,
            documentId: map["idNews"],
            data: {
              'title': map["title"],
              'url_image': urlImage,
              'description': map["description"],
              'updated_by': storage.read('id_user').toString(),
              'date_time_updated': DateTime.now().toString(),
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
