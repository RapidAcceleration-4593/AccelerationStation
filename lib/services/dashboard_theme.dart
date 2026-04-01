import 'package:flutter/material.dart';

class DashboardTheme {
  static const font = "JetBrainsMono";

  static const outlineColor = Color.fromARGB(255, 65, 75, 87);
  static const highlightColor = Color.fromARGB(255, 166, 235, 252);
  static const underlineColor = Color.fromARGB(255, 228, 140, 8);
  static const backgroundColor = Color.fromARGB(255, 13, 17, 23);

  static const footerText = TextStyle(
    fontFamily: font,
    fontSize: 14,
    color: outlineColor
  );

  static TextStyle heading(Color color) => TextStyle(
    fontFamily: font,
    fontSize: 92,
    color: color
  );
}