import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';

class CustomAppbar extends AppBar {
  bool? IconBackNavigator;
  Callback? iconBackAction;
  String? titulo;
  List<IconButton>? actionsList;
  CustomAppbar({Key? key, double elevation = 2, this.titulo, this.actionsList})
      : super(
          toolbarHeight: Get.height * .12,
          key: key,
          backgroundColor: Get.theme.colorScheme.secondary,
          elevation: 2,
          iconTheme: IconThemeData(color: Get.theme.colorScheme.onBackground),
          actions: actionsList,
          title: Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: Image.asset(
              'assets/images/logo_header.png',
              fit: BoxFit.contain,
              height: Get.height * .2,
              width: Get.width * .6,
            ),
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
          ),
        );
}
