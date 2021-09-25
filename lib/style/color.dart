import 'package:flutter/material.dart';

ColorScheme get lightColorScheme => ColorScheme.light(
      primary: const Color(0xFF5C8BBA),
      primaryVariant: const Color(0xFF486996),
      secondary: const Color(0xFFF9C1B4),
      secondaryVariant: const Color(0xffc59084),
      surface: const Color(0xe6ffffff),
      background: Colors.white,
      error: const Color(0xffb00020),
      onPrimary: Colors.black,
      onSecondary: Colors.black,
      onSurface: Colors.black,
      onBackground: Colors.black,
      onError: Colors.white,
      brightness: Brightness.light,
    );

ColorScheme get darkColorScheme => ColorScheme.dark(
      primary: const Color(0xFF5C8BBA),
      primaryVariant: const Color(0xFF486996),
      secondary: const Color(0xFFF9C1B4),
      secondaryVariant: const Color(0xffc59084),
      surface: const Color(0xe6121212),
      background: const Color(0xff121212),
      error: const Color(0xffcf6679),
      onPrimary: Colors.black,
      onSecondary: Colors.black,
      onSurface: Colors.white,
      onBackground: Colors.white,
      onError: Colors.black,
      brightness: Brightness.dark,
    );
