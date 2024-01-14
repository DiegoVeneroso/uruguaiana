import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:get/get.dart';
import '../core/config/api_client.dart';
import '../core/config/constants.dart' as constants;
import '../models/item_model.dart';

class HomeRepository {
  RealtimeSubscription? subscription;
  RxList<ItemModel> listItem = <ItemModel>[].obs;
  RxString? search = ''.obs;

  Future<List<ItemModel>> loadDataRepository() async {
    try {
      DocumentList response;
      if (search?.value != '') {
        response = await ApiClient.databases.listDocuments(
          databaseId: constants.DATABASE_ID,
          collectionId: constants.COLLETION_ITEM_ID,
          queries: [Query.search("name", search!.value.toString())],
        );
        var items = response.documents.reversed
            .map((docmodel) => ItemModel(
                  id: docmodel.data['id'],
                  name: docmodel.data['name'],
                  image: docmodel.data['image'],
                  cidade: docmodel.data['cidade'],
                ))
            .toList();

        return items;
      } else {
        response = await ApiClient.databases.listDocuments(
          databaseId: constants.DATABASE_ID,
          collectionId: constants.COLLETION_ITEM_ID,
        );

        var items = response.documents.reversed
            .map((docmodel) => ItemModel(
                  id: docmodel.data['id'],
                  name: docmodel.data['name'],
                  image: docmodel.data['image'],
                  cidade: docmodel.data['cidade'],
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

  itemAddRepository(Map map) async {
    try {
      final idUnique = DateTime.now().millisecondsSinceEpoch.toString();

      String fileName = "$idUnique."
          "${map["imagePath"].toString().split(".").last}";

      var urlImage =
          '${constants.API_END_POINT_STORAGE}${constants.STORAGE_BUCKETS}/files/$idUnique/view?project=${constants.PROJECT_ID}';

      await ApiClient.storage.createFile(
        bucketId: constants.STORAGE_BUCKETS,
        fileId: idUnique,
        file: InputFile(
          path: map["imagePath"],
          filename: fileName,
        ),
      );

      await ApiClient.databases.createDocument(
          databaseId: constants.DATABASE_ID,
          collectionId: constants.COLLETION_ITEM_ID,
          documentId: idUnique,
          data: {
            'id': idUnique,
            'name': map["name"],
            'image': urlImage,
            'cidade': map["cidade"],
          });
    } on AppwriteException catch (e) {
      log(e.response['type']);

      throw (e.response['type']);
    }
  }

  itemDeleteRepository(String idItem) async {
    try {
      await ApiClient.storage.deleteFile(
        bucketId: constants.STORAGE_BUCKETS,
        fileId: idItem,
      );

      await ApiClient.databases.deleteDocument(
        databaseId: constants.DATABASE_ID,
        collectionId: constants.COLLETION_ITEM_ID,
        documentId: idItem,
      );
    } on AppwriteException catch (e) {
      log(e.response['type']);

      throw (e.response['type']);
    }
  }

  itemUpdateRepository(Map map) async {
    try {
      if (map["imagePath"] == '') {
        await ApiClient.databases.updateDocument(
            databaseId: constants.DATABASE_ID,
            collectionId: constants.COLLETION_ITEM_ID,
            documentId: map["id"],
            data: {
              'name': map["name"],
              'cidade': map["cidade"],
            });
      } else {
        await ApiClient.storage.deleteFile(
          bucketId: constants.STORAGE_BUCKETS,
          fileId: map["id"],
        );

        final idUnique = map["id"];

        String fileName = "$idUnique."
            "${map["imagePath"].toString().split(".").last}";

        var urlImage =
            '${constants.API_END_POINT_STORAGE}${constants.STORAGE_BUCKETS}/files/$idUnique/view?project=${constants.PROJECT_ID}';

        await ApiClient.storage.createFile(
          bucketId: constants.STORAGE_BUCKETS,
          fileId: idUnique,
          file: InputFile.fromPath(
            path: map["imagePath"],
            filename: fileName,
          ),
        );

        await ApiClient.databases.updateDocument(
            databaseId: constants.DATABASE_ID,
            collectionId: constants.COLLETION_ITEM_ID,
            documentId: map["id"],
            data: {
              'name': map["name"],
              'image': urlImage,
              'cidade': map["cidade"],
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
