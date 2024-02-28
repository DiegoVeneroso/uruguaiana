// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:eu_faco_parte/app/modules/home/home_controller.dart';

// ignore: must_be_immutable
class CustomDropdownButton extends GetView<HomeController> {
  final String? label;
  final String? value;
  Future<List<DropdownMenuItem<String>>> futureListDropdown;
  final FormFieldValidator<String>? validator;

  CustomDropdownButton({
    Key? key,
    this.label,
    this.value,
    required this.futureListDropdown,
    required this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: futureListDropdown,
        builder: (context, snapshot) {
          return Padding(
            padding: const EdgeInsets.only(
                top: 8.0, left: 0.0, right: 0.0, bottom: 8.0),
            child: DropdownButtonFormField2(
              // itemPadding: const EdgeInsets.all(0),
              // dropdownPadding: const EdgeInsets.all(20),
              // dropdownScrollPadding: const EdgeInsets.all(20),
              // dropdownWidth: 100,
              // style: const TextStyle(
              //   color: Colors.black,
              // ),
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
                isDense: true,
                labelStyle: TextStyle(color: Get.theme.colorScheme.secondary),
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
                fillColor: Colors.white,
              ),
              isExpanded: true,
              hint: AutoSizeText(
                minFontSize: 10,
                label ?? value.toString(),
                style: TextStyle(
                    fontSize: 16, color: Get.theme.colorScheme.primary),
              ),
              icon: Icon(
                Icons.arrow_drop_down,
                color: Get.theme.colorScheme.primary,
              ),
              iconSize: 25,
              buttonHeight: 20,
              buttonPadding: const EdgeInsets.only(left: 0, right: 10),
              dropdownDecoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
              ),
              items: snapshot.data,
              validator: validator,
              onChanged: (value) {
                controller.valorSelecionadoDropDown?.value = value.toString();
              },
            ),
          );
        });
  }
}
