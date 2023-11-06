import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

mixin LoaderMessageMixin on GetxController {
  void loaderMessageListener(RxBool loading) {
    ever(loading, (_) async {
      if (loading.isTrue) {
        await Get.dialog(
          WillPopScope(
            onWillPop: () async => false,
            child: Center(
              child: FractionallySizedBox(
                widthFactor: 0.5,
                heightFactor: 0.2,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Get.theme.colorScheme.onPrimaryContainer,
                    boxShadow: [
                      BoxShadow(
                          color: Get.theme.colorScheme.primary, blurRadius: 5)
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        color: Get.theme.colorScheme.primary,
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Material(
                        child: AutoSizeText(
                          "Carregando mídia!",
                          style: TextStyle(
                            color: Get.theme.colorScheme.primary,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          minFontSize: 10,
                        ),
                      ),
                      Material(
                        child: AutoSizeText(
                          "Aguarde...",
                          style: TextStyle(
                            color: Get.theme.colorScheme.primary,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          minFontSize: 10,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          barrierDismissible: false,
        );
      } else {
        Get.back();
      }
    });
  }
}
