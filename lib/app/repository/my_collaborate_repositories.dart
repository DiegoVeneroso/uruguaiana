import 'package:appwrite/appwrite.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../models/collaborate_model.dart';

class MyColaborateRepository {
  RealtimeSubscription? subscription;
  RxList<CollaborateModel> listMyCollaborate = <CollaborateModel>[].obs;

  RxString? search = ''.obs;
  GetStorage storage = GetStorage();

  void loadDataRepository() async {
    listMyCollaborate.add(
      CollaborateModel(
        idCollaborate: '12312',
        name: 'name',
        urlImage: 'url',
        phone: '2132',
        description: 'gfds',
        dateTimeCreated: 'fsadg',
      ),
    );
  }
}
