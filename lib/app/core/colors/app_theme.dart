import 'package:flutter/material.dart';

class Themes {
  static final light = ThemeData.light().copyWith(
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: Colors.green,
      onPrimary: Colors.grey,
      secondary: Colors.green,
      onSecondary: Colors.black,
      error: Colors.redAccent,
      onError: Colors.redAccent, //messages_error
      background: Color(0xFFF1F2F3),
      onBackground: Colors.white,
      surface: Colors.green,
      onSurface: Colors.green, //messages_success
      primaryContainer: Colors.green,
      onPrimaryContainer: Colors.white,
    ),
  );

  static final dark = ThemeData.dark().copyWith(
    colorScheme: const ColorScheme(
      brightness: Brightness.dark,
      primary: Colors.green,
      onPrimary: Color(0xFFFFFFFF),
      secondary: Colors.green,
      onSecondary: Color(0xFFEAEAEA),
      error: Colors.yellowAccent,
      onError: Colors.redAccent, //messages_error
      background: Color(0xFF202020),
      onBackground: Colors.white,
      surface: Colors.white,
      onSurface: Colors.green, //messages_success
      primaryContainer: Colors.green,
      onPrimaryContainer: Colors.white,
    ),
  );
}
