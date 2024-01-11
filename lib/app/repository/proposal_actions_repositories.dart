import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:eu_faco_parte/app/models/proposal_action_model.dart';
import '../core/config/api_client.dart';
import '../core/config/constants.dart' as constants;

class ProposalActionsRepository {
  RealtimeSubscription? subscription;
  RxList<ProposalActionModel> listItem = <ProposalActionModel>[].obs;
  RxString? search = ''.obs;
  GetStorage storage = GetStorage();

  Future<List<ProposalActionModel>> loadDataRepository(
      String idProposalBase) async {
    try {
      DocumentList response;

      if (search?.value != '') {
        response = await ApiClient.databases.listDocuments(
          databaseId: constants.DATABASE_ID,
          collectionId: constants.COLLETION_PROPOSAL_ACTIONS_ID,
          queries: [
            Query.equal('clProposalBase', idProposalBase),
            Query.search("title", search!.value.toString()),
          ],
        );

        var items = response.documents.reversed
            .map((docmodel) => ProposalActionModel(
                  idProposalAction: docmodel.data['id_proposal_action'],
                  title: docmodel.data['title'],
                  description: docmodel.data['description'],
                  urlImage: docmodel.data['url_image'],
                ))
            .toList();

        return items;
      } else {
        response = await ApiClient.databases.listDocuments(
          databaseId: constants.DATABASE_ID,
          collectionId: constants.COLLETION_PROPOSAL_ACTIONS_ID,
          queries: [Query.equal('clProposalBase', idProposalBase)],
        );

        var items = response.documents.reversed
            .map((docmodel) => ProposalActionModel(
                  idProposalAction: docmodel.data['id_proposal_action'],
                  title: docmodel.data['title'],
                  description: docmodel.data['description'],
                  urlImage: docmodel.data['url_image'],
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

  proposalActionAddRepository(Map map) async {
    try {
      final idUnique = DateTime.now().millisecondsSinceEpoch.toString();

      if (map["url_image"] == '') {
        await ApiClient.databases.createDocument(
            databaseId: constants.DATABASE_ID,
            collectionId: constants.COLLETION_PROPOSAL_ACTIONS_ID,
            documentId: idUnique,
            data: {
              'id_proposal_action': idUnique,
              'title': map["title"],
              'description': map["description"],
              'clProposalBase': map["id_proposal_base"],
            });
      } else {
        String fileName = "$idUnique."
            "${map["url_image"].toString().split(".").last}";

        var urlImage =
            '${constants.API_END_POINT_STORAGE}${constants.STORAGE_BUCKETS}/files/$idUnique/view?project=${constants.PROJECT_ID}';

        print('fileName');
        print(fileName);

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
            collectionId: constants.COLLETION_PROPOSAL_ACTIONS_ID,
            documentId: idUnique,
            data: {
              'id_proposal_action': idUnique,
              'title': map["title"],
              'description': map["description"],
              'clProposalBase': map["id_proposal_base"],
              'url_image': urlImage,
            });
      }
    } on AppwriteException catch (e) {
      log(e.response['type']);

      throw (e.response['type']);
    }
  }

  proposalActionsDeleteRepository(String idProposal) async {
    try {
      await ApiClient.storage.deleteFile(
        bucketId: constants.STORAGE_BUCKETS,
        fileId: idProposal,
      );

      await ApiClient.databases.deleteDocument(
        databaseId: constants.DATABASE_ID,
        collectionId: constants.COLLETION_PROPOSAL_ACTIONS_ID,
        documentId: idProposal,
      );
    } on AppwriteException catch (e) {
      log(e.response['type']);

      throw (e.response['type']);
    }
  }

  proposalActionsUpdateRepository(Map map) async {
    try {
      await ApiClient.storage.deleteFile(
        bucketId: constants.STORAGE_BUCKETS,
        fileId: map["id_proposal_action"],
      );

      final idUnique = map["id_proposal_action"];

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
          collectionId: constants.COLLETION_PROPOSAL_ACTIONS_ID,
          documentId: map["id_proposal_action"],
          data: {
            "title": map['title'],
            "description": map['description'],
            "url_image": urlImage,
          });

      // await ApiClient.databases.updateDocument(
      //     databaseId: constants.DATABASE_ID,
      //     collectionId: constants.COLLETION_PROPOSAL_ACTIONS_ID,
      //     documentId: map["id_proposal_action"],
      //     data: {
      // "title": map['title'],
      // "description": map['description'],
      // "url_image": map['url_image'],
      //     });
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
