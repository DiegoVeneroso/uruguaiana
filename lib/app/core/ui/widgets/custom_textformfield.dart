// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class CustomTextformfield extends StatelessWidget {
  final String label;
  final TextEditingController? controller;
  final bool obscureText;
  bool visibility;
  final bool cellMask;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChange;
  final RxBool isVisible = false.obs;
  final int? maxlines;
  final int? minlines;
  final TextInputType? keyboardType;

  CustomTextformfield({
    Key? key,
    required this.label,
    this.controller,
    this.obscureText = false,
    this.visibility = false,
    this.cellMask = false,
    this.validator,
    this.onChange,
    this.maxlines = 1,
    this.minlines,
    this.keyboardType,
  }) : super(key: key);

  var maskFormatter = MaskTextInputFormatter(
      mask: '(##) #####-####',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);

  void updateVisibility() {
    isVisible.value = !isVisible.value;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => TextFormField(
        style: TextStyle(color: Get.theme.colorScheme.primary),
        inputFormatters: cellMask ? [maskFormatter] : [],
        controller: controller,
        obscureText: !isVisible.value ? obscureText : false,
        validator: validator,
        onChanged: onChange,
        cursorColor: Get.theme.colorScheme.primary,
        decoration: InputDecoration(
          suffixIcon: visibility
              ? IconButton(
                  onPressed: () => updateVisibility(),
                  icon: Icon(
                    isVisible.value ? Icons.visibility_off : Icons.visibility,
                    color: Get.theme.colorScheme.primary,
                    size: 22,
                  ),
                )
              : null,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
          isDense: true,
          labelText: label,
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
          fillColor: Get.theme.colorScheme.onBackground,
        ),
        maxLines: maxlines,
        minLines: minlines,
        keyboardType: keyboardType,
      ),
    );
  }
}
