// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:ffi';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uruguaiana/app/modules/home/home_controller.dart';

class CustomDropdownButton extends GetView<HomeController> {
  final String label;
  Future<List<DropdownMenuItem<String>>> futureListDropdown;
  final FormFieldValidator<String>? validator;

  CustomDropdownButton({
    Key? key,
    required this.label,
    required this.futureListDropdown,
    required this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        // future: controller.getDropdowValue(labelAndColecctionList: 'Cidade'),
        future: futureListDropdown,
        builder: (context, snapshot) {
          return Padding(
            padding: const EdgeInsets.only(
                top: 8.0, left: 0.0, right: 0.0, bottom: 8.0),
            child: DropdownButtonFormField2(
              style: const TextStyle(
                  color: Colors.blue, fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                isDense: true,
                labelStyle: const TextStyle(
                    color: Colors.blue, fontWeight: FontWeight.bold),
                errorStyle: const TextStyle(
                    color: Colors.redAccent, fontWeight: FontWeight.bold),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(23),
                  borderSide: const BorderSide(color: Colors.blue),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(color: Colors.blue),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(color: Colors.blue),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              isExpanded: true,
              hint: Text(
                label,
                style: const TextStyle(
                    fontSize: 16,
                    // fontWeight: FontWeight.bold,
                    color: Colors.blue),
              ),
              icon: const Icon(
                Icons.arrow_drop_down,
                color: Colors.blue,
              ),
              iconSize: 25,
              buttonHeight: 20,
              buttonPadding: const EdgeInsets.only(left: 0, right: 10),
              dropdownDecoration: BoxDecoration(
                borderRadius: BorderRadius.circular(23),
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
