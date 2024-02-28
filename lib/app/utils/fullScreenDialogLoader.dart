// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FullScreenDialogLoader {
  static void showDialog() {
    Get.dialog(
      WillPopScope(
        child: const Center(
          child: CircularProgressIndicator(),
        ),
        onWillPop: () => Future.value(false),
      ),
      barrierDismissible: false,
      barrierColor: Colors.pink.withOpacity(0.2),
      useSafeArea: true,
    );
  }

  static void cancelDialog() {
    if (Get.isDialogOpen!) {
      Get.back();
    }
  }
}
