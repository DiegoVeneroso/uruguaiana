import 'package:flutter/material.dart';

class Themes {
  static final light = ThemeData.light().copyWith(
    colorScheme: ColorScheme(
        brightness: Brightness.light,
        primary: Colors.green, //loader
        onPrimary: Colors.grey,
        secondary: Colors.green,
        onSecondary: Colors.black,
        error: Colors.redAccent,
        onError: Colors.redAccent, //messages_error
        // background: Color(0xFFF1F2F3),
        background: const Color.fromARGB(255, 230, 230, 231),
        onBackground: Colors.white,
        surface: Colors.green,
        onSurface: Colors.green, //messages_success
        primaryContainer: Colors.green,
        onPrimaryContainer: Colors.white,
        shadow: Colors.black.withOpacity(0.3)),
  );

  static final dark = ThemeData.dark().copyWith(
    colorScheme: ColorScheme(
      brightness: Brightness.dark,
      primary: Colors.green, //loader
      onPrimary: const Color(0xFFFFFFFF),
      secondary: Colors.green,
      onSecondary: const Color(0xFFEAEAEA),
      error: Colors.yellowAccent,
      onError: Colors.redAccent, //messages_error
      background: const Color(0xFF202020),
      onBackground: Colors.white,
      surface: Colors.white,
      onSurface: Colors.green, //messages_success
      primaryContainer: Colors.green,
      onPrimaryContainer: Colors.white,
      shadow: Colors.black.withOpacity(0.3),
    ),
  );
}
