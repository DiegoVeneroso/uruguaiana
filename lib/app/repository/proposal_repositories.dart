import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../core/config/api_client.dart';
import '../core/config/constants.dart' as constants;
import '../models/proposal_model.dart';

class ProposalRepository {
  RealtimeSubscription? subscription;
  RxList<ProposalModel> listItem = <ProposalModel>[].obs;
  RxString? search = ''.obs;
  GetStorage storage = GetStorage();

  Future<List<ProposalModel>> loadDataRepository() async {
    try {
      DocumentList response;

      if (search?.value != '') {
        response = await ApiClient.databases.listDocuments(
          databaseId: constants.DATABASE_ID,
          collectionId: constants.COLLETION_PROPOSAL_BASE_ID,
          queries: [Query.search("title", search!.value.toString())],
        );

        var items = response.documents.reversed
            .map((docmodel) => ProposalModel(
                  idProposal: docmodel.data['idProposal'],
                  title: docmodel.data['title'],
                ))
            .toList();

        return items;
      } else {
        response = await ApiClient.databases.listDocuments(
          databaseId: constants.DATABASE_ID,
          collectionId: constants.COLLETION_PROPOSAL_BASE_ID,
        );

        var items = response.documents.reversed
            .map((docmodel) => ProposalModel(
                  idProposal: docmodel.data['idProposal'],
                  title: docmodel.data['title'],
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

  proposalAddRepository(Map map) async {
    try {
      final idUnique = DateTime.now().millisecondsSinceEpoch.toString();

      await ApiClient.databases.createDocument(
          databaseId: constants.DATABASE_ID,
          collectionId: constants.COLLETION_PROPOSAL_BASE_ID,
          documentId: idUnique,
          data: {
            'id_proposal_base': idUnique,
            'title': map["title"],
          });
    } on AppwriteException catch (e) {
      log(e.response['type']);

      throw (e.response['type']);
    }
  }

  proposalDeleteRepository(String idProposal) async {
    try {
      await ApiClient.storage.deleteFile(
        bucketId: constants.STORAGE_BUCKETS,
        fileId: idProposal,
      );

      await ApiClient.databases.deleteDocument(
        databaseId: constants.DATABASE_ID,
        collectionId: constants.COLLETION_PROPOSAL_BASE_ID,
        documentId: idProposal,
      );
    } on AppwriteException catch (e) {
      log(e.response['type']);

      throw (e.response['type']);
    }
  }

  proposalUpdateRepository(Map map) async {
    try {
      if (map["url_image"] == '') {
        await ApiClient.databases.updateDocument(
            databaseId: constants.DATABASE_ID,
            collectionId: constants.COLLETION_PROPOSAL_BASE_ID,
            documentId: map["idProposal"],
            data: {
              'title': map["title"],
              'description': map["description"],
              'updated_by': storage.read('id_user').toString(),
              'date_time_updated': DateTime.now().toString(),
            });
      } else {
        await ApiClient.storage.deleteFile(
          bucketId: constants.STORAGE_BUCKETS,
          fileId: map["idProposal"],
        );

        final idUnique = map["idProposal"];

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
            collectionId: constants.COLLETION_PROPOSAL_BASE_ID,
            documentId: map["idProposal"],
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
