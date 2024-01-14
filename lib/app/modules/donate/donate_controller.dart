// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:appwrite/appwrite.dart' hide Permission;
import 'package:get/get.dart';
import '../../core/mixins/dialog_mixin.dart';
import '../../core/mixins/loader_mixin.dart';
import '../../core/mixins/messages_mixin.dart';

class DonateController extends GetxController
    with LoaderMixin, MessagesMixin, DialogMixin {
  RealtimeSubscription? subscription;
  final loading = false.obs;
  final message = Rxn<MessageModel>();

  var isDarkMode = false.obs;

  @override
  onInit() {
    loaderListener(loading);
    messageListener(message);

    super.onInit();
  }
}
