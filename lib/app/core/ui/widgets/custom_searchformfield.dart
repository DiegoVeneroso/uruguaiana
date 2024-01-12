// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:eu_faco_parte/app/modules/home/home_controller.dart';

class CustomSearchformfield extends GetView<HomeController> {
  final Function() onPressed;
  final Function(String) onChanged;

  const CustomSearchformfield({
    super.key,
    required this.onPressed,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: TextStyle(color: Get.theme.colorScheme.primary),
      onChanged: onChanged,
      decoration: InputDecoration(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
        isDense: true,
        labelText: 'Pesquisar',
        labelStyle: TextStyle(color: Get.theme.colorScheme.primary),
        errorStyle: TextStyle(color: Get.theme.colorScheme.error),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(23),
          borderSide: BorderSide(color: Get.theme.colorScheme.primary),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(23),
          borderSide: BorderSide(color: Get.theme.colorScheme.primary),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(23),
          borderSide: BorderSide(color: Get.theme.colorScheme.primary),
        ),
        filled: true,
        fillColor: context.theme.colorScheme.onPrimaryContainer,
        suffixIcon: IconButton(
          onPressed: onPressed,
          icon: const Icon(Icons.close),
          color: Get.theme.colorScheme.secondary,
        ),
      ),
    );
  }
}
