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
          toolbarHeight: 70,
          key: key,
          backgroundColor: Get.theme.colorScheme.secondary,
          elevation: elevation,
          iconTheme: IconThemeData(color: Get.theme.colorScheme.onBackground),
          actions: actionsList,
          title: Image.asset(
            'assets/images/header.png',
            fit: BoxFit.contain,
            height: 80,
          ),
        );
}
