import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uruguaiana/app/core/ui/widgets/custom_button.dart';
import 'package:uruguaiana/app/repository/auth_repository.dart';

import '../../modules/home/home_controller.dart';
import '../../repository/home_repositories.dart';

mixin DialogMixin on GetxController {
  void dialogListener(Rxn<DialogModel> dialog) {
    ever<DialogModel?>(dialog, (model) async {
      HomeController controller = HomeController(
        repository: HomeRepository(),
        authRepository: AuthRepository(),
      );
      if (model != null) {
        Get.defaultDialog(
          titlePadding: const EdgeInsets.only(top: 10),
          contentPadding: const EdgeInsets.only(top: 30, bottom: 20),
          title: model.title,
          middleText: model.message,
          backgroundColor: Get.theme.colorScheme.onPrimaryContainer,
          titleStyle: TextStyle(color: Get.theme.colorScheme.onSurface),
          middleTextStyle: TextStyle(color: Get.theme.colorScheme.onSurface),
          radius: 30,
          confirm: CustomButton(
            color: Get.theme.colorScheme.onError,
            height: 40,
            width: 100,
            label: 'Excluir',
            onPressed: () async {
              await controller.itemDelete(model.id.toString());
            },
          ),
        );
      }
    });
  }
}

class DialogModel {
  final String id;
  final String title;
  final String message;

  DialogModel({
    required this.id,
    required this.title,
    required this.message,
  });
}
