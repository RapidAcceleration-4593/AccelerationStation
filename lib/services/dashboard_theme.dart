import 'package:flutter/material.dart';

class DashboardTheme {
  static const font = "JetBrainsMono";

  static const footerText = TextStyle(
    fontFamily: font,
    fontSize: 14,
    color: Colors.grey
  );

  static TextStyle heading(Color color) => TextStyle(
    fontFamily: font,
    fontSize: 92,
    color: color
  );
}