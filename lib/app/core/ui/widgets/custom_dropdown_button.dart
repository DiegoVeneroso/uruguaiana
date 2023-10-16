// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:uruguaiana/app/modules/home/home_controller.dart';

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
                isDense: true,
                // labelStyle: const TextStyle(
                //   color: Colors.red,
                // ),
                // floatingLabelStyle: const TextStyle(color: Colors.red),

                errorStyle: const TextStyle(
                    color: Colors.redAccent, fontWeight: FontWeight.bold),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              isExpanded: true,
              hint: Text(
                label ?? value.toString(),
                style: const TextStyle(fontSize: 16, color: Colors.black),
              ),
              icon: const Icon(
                Icons.arrow_drop_down,
                color: Colors.black54,
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
