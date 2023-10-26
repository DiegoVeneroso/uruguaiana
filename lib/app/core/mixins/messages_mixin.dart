import 'package:flutter/material.dart';
import 'package:get/get.dart';

mixin MessagesMixin on GetxController {
  void messageListener(Rxn<MessageModel> message) {
    ever<MessageModel?>(message, (model) async {
      if (model != null) {
        Get.snackbar(
          model.title,
          model.message,
          backgroundColor: model.type.color(),
          colorText: model.type.textColor(),
          margin: const EdgeInsets.all(20),
          borderColor: Get.theme.colorScheme.onPrimaryContainer,
          borderWidth: 1,
          boxShadows: [
            BoxShadow(
                color: Get.theme.colorScheme.onPrimaryContainer, blurRadius: 3)
          ],
        );
      }
    });
  }
}

class MessageModel {
  final String title;
  final String message;
  final MessageType type;

  MessageModel({
    required this.title,
    required this.message,
    required this.type,
  });
}

enum MessageType { error, info, success }

extension MessageTypeColorExt on MessageType {
  Color color() {
    switch (this) {
      case MessageType.error:
        return Get.theme.colorScheme.onError;
      case MessageType.info:
        return Get.theme.colorScheme.onError;
      case MessageType.success:
        return Get.theme.colorScheme.onSurface;
    }
  }

  Color textColor() {
    switch (this) {
      case MessageType.error:
        return Get.theme.colorScheme.onPrimaryContainer;
      case MessageType.success:
        return Get.theme.colorScheme.onPrimaryContainer;
      case MessageType.info:
        return Get.theme.colorScheme.onPrimaryContainer;
    }
  }
}
