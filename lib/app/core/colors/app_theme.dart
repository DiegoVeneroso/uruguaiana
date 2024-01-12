import 'package:flutter/material.dart';

class Themes {
  static final light = ThemeData.light().copyWith(
    colorScheme: ColorScheme(
        brightness: Brightness.light,
        primary: const Color.fromARGB(255, 255, 167, 34), //loader
        onPrimary: const Color.fromARGB(225, 247, 244, 244),
        secondary: const Color.fromARGB(255, 255, 224, 183),
        onSecondary: Colors.black,
        error: Colors.redAccent,
        onError: Colors.redAccent, //messages_error
        // background: const Color.fromARGB(255, 230, 230, 231),
        background: const Color.fromARGB(255, 252, 252, 252),
        onBackground: Colors.white,
        surface: const Color.fromARGB(255, 255, 167, 34),
        onSurface: const Color.fromARGB(255, 255, 167, 34), //messages_success
        primaryContainer: const Color.fromARGB(255, 255, 167, 34),
        onPrimaryContainer: Colors.white,
        shadow: Colors.black.withOpacity(0.3)),
  );

  static final dark = ThemeData.dark().copyWith(
    colorScheme: ColorScheme(
      brightness: Brightness.dark,
      primary: Colors.green, //loader
      onPrimary: const Color(0xFFFFFFFF),
      secondary: const Color(0xFFFFFFFF),
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
