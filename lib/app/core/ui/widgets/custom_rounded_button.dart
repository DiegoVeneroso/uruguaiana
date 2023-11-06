import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

class CustomRoundedButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;
  final double fontSize;

  const CustomRoundedButton({
    Key? key,
    required this.onPressed,
    required this.label,
    this.fontSize = 25,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
          shape: const CircleBorder(), backgroundColor: Colors.white),
      child: AutoSizeText(
        minFontSize: 10,
        label,
        style: TextStyle(
          color: Colors.grey,
          fontSize: fontSize,
        ),
      ),
    );
  }
}
