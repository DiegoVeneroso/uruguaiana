// ignore_for_file: deprecated_member_use

import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import '../core/config/api_client.dart';
import '../core/config/constants.dart' as constants;
import '../models/view_model.dart';

class ViewPeapleRepository {
  RealtimeSubscription? subscription;
  RxList<ViewModel> listItem = <ViewModel>[].obs;
  RxString? search = ''.obs;
  GetStorage storage = GetStorage();

  Future<List<ViewModel>> loadDataRepository() async {
    try {
      DocumentList response;

      if (search?.value != '') {
        response = await ApiClient.databases.listDocuments(
          databaseId: constants.DATABASE_ID,
          collectionId: constants.COLLETION_VIEW,
          queries: [
            Query.search("title", search!.value.toString()),
            Query.equal("status", "true"),
          ],
        );

        var items = response.documents.reversed
            .map((docmodel) => ViewModel(
                  idView: docmodel.data['idView'],
                  title: docmodel.data['title'],
                  urlImage: docmodel.data['url_image'],
                  description: docmodel.data['description'],
                  date: docmodel.data['date'],
                  nameUser: docmodel.data['name'],
                  phone: docmodel.data['phone'],
                  bairro: docmodel.data['bairro'],
                ))
            .toList();

        return items;
      } else {
        response = await ApiClient.databases.listDocuments(
          databaseId: constants.DATABASE_ID,
          collectionId: constants.COLLETION_VIEW,
          queries: [Query.equal("status", "true")],
        );

        var items = response.documents.reversed
            .map((docmodel) => ViewModel(
                  idView: docmodel.data['idView'],
                  title: docmodel.data['title'],
                  urlImage: docmodel.data['url_image'],
                  description: docmodel.data['description'],
                  date: docmodel.data['date'],
                  nameUser: docmodel.data['name'],
                  phone: docmodel.data['phone'],
                  bairro: docmodel.data['bairro'],
                ))
            .toList();

        return items;
      }
    } on AppwriteException catch (e) {
      log(e.response['type']);

      throw (e.response['type']);
    }
  }

  Future<List<ViewModel>> adminLoadDataRepository() async {
    try {
      DocumentList response;

      if (search?.value != '') {
        response = await ApiClient.databases.listDocuments(
          databaseId: constants.DATABASE_ID,
          collectionId: constants.COLLETION_VIEW,
          queries: [
            Query.search("title", search!.value.toString()),
            Query.equal("status", "false"),
          ],
        );

        var items = response.documents.reversed
            .map((docmodel) => ViewModel(
                  idView: docmodel.data['idView'],
                  title: docmodel.data['title'],
                  urlImage: docmodel.data['url_image'],
                  description: docmodel.data['description'],
                  date: docmodel.data['date'],
                  nameUser: docmodel.data['name'],
                  phone: docmodel.data['phone'],
                  bairro: docmodel.data['bairro'],
                ))
            .toList();

        return items;
      } else {
        response = await ApiClient.databases.listDocuments(
          databaseId: constants.DATABASE_ID,
          collectionId: constants.COLLETION_VIEW,
          queries: [Query.equal("status", "false")],
        );

        var items = response.documents.reversed
            .map((docmodel) => ViewModel(
                  idView: docmodel.data['idView'],
                  title: docmodel.data['title'],
                  urlImage: docmodel.data['url_image'],
                  description: docmodel.data['description'],
                  date: docmodel.data['date'],
                  nameUser: docmodel.data['name'],
                  phone: docmodel.data['phone'],
                  bairro: docmodel.data['bairro'],
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

  viewAddRepository(Map map) async {
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
          collectionId: constants.COLLETION_VIEW,
          documentId: idUnique,
          data: {
            'idView': idUnique,
            'title': map["title"],
            'description': map["description"],
            'date': DateFormat(DateFormat.YEAR_MONTH_DAY, 'pt_Br')
                .format(DateTime.now())
                .toString(),
            'name': map["name"],
            'phone': map["phone"],
            'bairro': map["bairro"],
            'status': "false",
            'url_image': urlImage,
          });
    } on AppwriteException catch (e) {
      log(e.response['type']);

      throw (e.response['type']);
    }
  }

  viewPeapleDeleteRepository(Map map) async {
    try {
      await ApiClient.databases.deleteDocument(
        databaseId: constants.DATABASE_ID,
        collectionId: constants.COLLETION_VIEW,
        documentId: map['idView'],
      );
    } on AppwriteException catch (e) {
      log(e.response['type']);

      throw (e.response['type']);
    }
  }

  setAprovedViewPeapleRepository(Map map) async {
    try {
      await ApiClient.databases.updateDocument(
          databaseId: constants.DATABASE_ID,
          collectionId: constants.COLLETION_VIEW,
          documentId: map["idView"],
          data: {
            'status': 'true',
          });
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



// // ignore_for_file: deprecated_member_use

// import 'dart:developer';
// import 'package:appwrite/appwrite.dart';
// import 'package:appwrite/models.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:intl/intl.dart';
// import '../core/config/api_client.dart';
// import '../core/config/constants.dart' as constants;
// import '../models/view_model.dart';

// class ViewPeapleRepository {
//   RealtimeSubscription? subscription;
//   GetStorage storage = GetStorage();

//   Future<List<ViewModel>> loadDataRepository(String? search) async {
//     try {
//       DocumentList response;
//       if (search != '') {
//         response = await ApiClient.databases.listDocuments(
//           databaseId: constants.DATABASE_ID,
//           collectionId: constants.COLLETION_VIEW,
//           queries: [Query.search("title", search.toString())],
//         );

//         var items = response.documents.reversed
//             .map((docmodel) => ViewModel(
//                   idView: docmodel.data['idView'],
//                   title: docmodel.data['title'],
//                   description: docmodel.data['description'],
//                   date: docmodel.data['date'],
//                   nameUser: docmodel.data['name'],
//                   phone: docmodel.data['phone'],
//                   bairro: docmodel.data['bairro'],
//                   urlImage: docmodel.data['url_image'],
//                   status: docmodel.data['status'],
//                 ))
//             .toList();

//         return items;
//       } else {
//         response = await ApiClient.databases.listDocuments(
//           databaseId: constants.DATABASE_ID,
//           collectionId: constants.COLLETION_VIEW,
//           queries: [Query.equal("status", "true")],
//         );

//         var items = response.documents.reversed
//             .map((docmodel) => ViewModel(
//                   idView: docmodel.data['idView'],
//                   title: docmodel.data['title'],
//                   description: docmodel.data['description'],
//                   date: docmodel.data['date'],
//                   nameUser: docmodel.data['name'],
//                   phone: docmodel.data['phone'],
//                   bairro: docmodel.data['bairro'],
//                   urlImage: docmodel.data['url_image'],
//                   status: docmodel.data['status'],
//                 ))
//             .toList();

//         return items;
//       }
//     } on AppwriteException catch (e) {
//       log(e.response['type']);

//       throw (e.response['type']);
//     }
//   }

//   Future<DocumentList> getTermOfUseRepository() async {
//     try {
//       var response = await ApiClient.databases.listDocuments(
//         databaseId: constants.DATABASE_ID,
//         collectionId: constants.COLLETION_TERM_OF_USE,
//       );

//       return response;
//     } on AppwriteException catch (e) {
//       log(e.response['type']);

//       throw (e.response['type']);
//     }
//   }

//   Future deleteImage(String fileId) {
//     final response = ApiClient.storage.deleteFile(
//       bucketId: constants.STORAGE_BUCKETS,
//       fileId: fileId,
//     );
//     return response;
//   }

//   viewsAddRepository(Map map) async {
//     try {
//       final idUnique = DateTime.now().millisecondsSinceEpoch.toString();

//       String fileName = "$idUnique."
//           "${map["url_image"].toString().split(".").last}";

//       var urlImage =
//           '${constants.API_END_POINT_STORAGE}${constants.STORAGE_BUCKETS}/files/$idUnique/view?project=${constants.PROJECT_ID}';

//       await ApiClient.storage.createFile(
//         bucketId: constants.STORAGE_BUCKETS,
//         fileId: idUnique,
//         file: InputFile(
//           path: map["url_image"],
//           filename: fileName,
//         ),
//       );

//       await ApiClient.databases.createDocument(
//           databaseId: constants.DATABASE_ID,
//           collectionId: constants.COLLETION_VIEW,
//           documentId: idUnique,
//           data: {
//             'idView': idUnique,
//             'title': map["title"],
//             'description': map["description"],
//             'date': DateFormat(DateFormat.YEAR_MONTH_DAY, 'pt_Br')
//                 .format(DateTime.now())
//                 .toString(),
//             'name': map["name"],
//             'phone': map["phone"],
//             'bairro': map["bairro"],
//             'url_image': urlImage,
//             'status': 'false',
//           });
//     } on AppwriteException catch (e) {
//       log(e.response['type']);

//       throw (e.response['type']);
//     }
//   }

//   newsDeleteRepository(String idNews) async {
//     try {
//       await ApiClient.storage.deleteFile(
//         bucketId: constants.STORAGE_BUCKETS,
//         fileId: idNews,
//       );

//       await ApiClient.databases.deleteDocument(
//         databaseId: constants.DATABASE_ID,
//         collectionId: constants.COLLETION_NEWS_ID,
//         documentId: idNews,
//       );
//     } on AppwriteException catch (e) {
//       log(e.response['type']);

//       throw (e.response['type']);
//     }
//   }

//   newsUpdateRepository(Map map) async {
//     try {
//       if (map["url_image"] == '') {
//         await ApiClient.databases.updateDocument(
//             databaseId: constants.DATABASE_ID,
//             collectionId: constants.COLLETION_NEWS_ID,
//             documentId: map["idNews"],
//             data: {
//               'title': map["title"],
//               'description': map["description"],
//               'updated_by': storage.read('id_user').toString(),
//               'date_time_updated': DateTime.now().toString(),
//             });
//       } else {
//         await ApiClient.storage.deleteFile(
//           bucketId: constants.STORAGE_BUCKETS,
//           fileId: map["idNews"],
//         );

//         final idUnique = map["idNews"];

//         String fileName = "$idUnique."
//             "${map["url_image"].toString().split(".").last}";

//         var urlImage =
//             '${constants.API_END_POINT_STORAGE}${constants.STORAGE_BUCKETS}/files/$idUnique/view?project=${constants.PROJECT_ID}';

//         await ApiClient.storage.createFile(
//           bucketId: constants.STORAGE_BUCKETS,
//           fileId: idUnique,
//           file: InputFile.fromPath(
//             path: map["url_image"],
//             filename: fileName,
//           ),
//         );

//         await ApiClient.databases.updateDocument(
//             databaseId: constants.DATABASE_ID,
//             collectionId: constants.COLLETION_NEWS_ID,
//             documentId: map["idNews"],
//             data: {
//               'title': map["title"],
//               'url_image': urlImage,
//               'description': map["description"],
//               'updated_by': storage.read('id_user').toString(),
//               'date_time_updated': DateTime.now().toString(),
//             });
//       }
//     } on AppwriteException catch (e) {
//       log(e.response['type']);

//       throw (e.response['type']);
//     }
//   }

//   Future getDropdowValueRepository(String labelAndColecctionList) async {
//     try {
//       var result = await ApiClient.databases.listDocuments(
//         databaseId: constants.DATABASE_ID,
//         collectionId: constants.COLLETION_DROPDOWN_ID,
//         queries: [Query.equal("name", labelAndColecctionList)],
//       );
//       return result.documents.first;
//     } on AppwriteException catch (e) {
//       log(e.response['type']);

//       throw (e.response['type']);
//     }
//   }
// }
