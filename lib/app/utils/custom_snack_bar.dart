import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:auto_size_text/auto_size_text.dart';

class CustomSnackBar {
  static void showErrorSnackBar({
    required BuildContext? context,
    required String title,
    required String message,
  }) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.red,
      titleText: AutoSizeText(
        minFontSize: 10,
        title,
        style: Theme.of(context!).textTheme.titleLarge!.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
      ),
      messageText: AutoSizeText(
        minFontSize: 10,
        message,
        style: Theme.of(context).textTheme.titleLarge!.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.normal,
              color: Colors.white,
            ),
      ),
      colorText: Colors.white,
      borderRadius: 8,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(8),
      icon: const Icon(
        Icons.error_outline,
        size: 40,
        color: Colors.white,
      ),
      shouldIconPulse: true,
      duration: const Duration(seconds: 4),
    );
  }

  static void showInfoSnackBar({
    required BuildContext? context,
    required String title,
    required String message,
  }) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.blue,
      titleText: AutoSizeText(
        minFontSize: 10,
        title,
        style: Theme.of(context!).textTheme.titleLarge!.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
      ),
      messageText: AutoSizeText(
        minFontSize: 10,
        message,
        style: Theme.of(context).textTheme.titleLarge!.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.normal,
              color: Colors.white,
            ),
      ),
      colorText: Colors.white,
      borderRadius: 8,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(8),
      icon: const Icon(
        Icons.error_outline,
        size: 40,
        color: Colors.white,
      ),
      shouldIconPulse: true,
      duration: const Duration(seconds: 4),
    );
  }

  static void showSuccessSnackBar({
    required BuildContext? context,
    required String title,
    required String message,
  }) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.green,
      titleText: AutoSizeText(
        minFontSize: 10,
        title,
        style: Theme.of(context!).textTheme.titleLarge!.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
      ),
      messageText: AutoSizeText(
        minFontSize: 10,
        message,
        style: Theme.of(context).textTheme.titleLarge!.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.normal,
              color: Colors.white,
            ),
      ),
      colorText: Colors.white,
      borderRadius: 8,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(8),
      icon: const Icon(
        Icons.error_outline,
        size: 40,
        color: Colors.white,
      ),
      shouldIconPulse: true,
      duration: const Duration(seconds: 4),
    );
  }
}
