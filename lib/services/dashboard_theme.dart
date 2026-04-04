import 'package:flutter/material.dart';

class DashboardTheme {
  static const font = "JetBrainsMono";

  static Color get outlineColor => themes[selectedTheme].outlineColor;
  static Color get highlightColor => themes[selectedTheme].highlightColor;
  static Color get underlineColor => themes[selectedTheme].underlineColor;
  static Color get backgroundColor => themes[selectedTheme].backgroundColor;
  static Color get middlegroundColor => themes[selectedTheme].middlegroundColor;

  static int selectedTheme = 0;
  static const List<Theme> themes = [
    Theme(
      name: 'Default Dark',
      outlineColor: Color.fromARGB(255, 65, 75, 87),
      highlightColor: Color.fromARGB(255, 166, 235, 252),
      underlineColor: Color.fromARGB(255, 228, 140, 8),
      backgroundColor: Color.fromARGB(255, 13, 17, 23),
      middlegroundColor: Color.fromARGB(255, 0, 0, 0),
    ),
    Theme(
      name: 'Acceleration',
      outlineColor: Color.fromARGB(255, 87, 80, 65),
      highlightColor: Color.fromARGB(255, 255, 224, 123),
      underlineColor: Color.fromARGB(255, 228, 140, 8),
      backgroundColor: Color.fromARGB(255, 27, 11, 18),
      middlegroundColor: Color.fromARGB(255, 8, 3, 5),
    ),
  ];
}

class Theme{
  final String name;
  final Color outlineColor;
  final Color highlightColor;
  final Color underlineColor;
  final Color backgroundColor;
  final Color middlegroundColor;
  
  const Theme({
    required this.name,
    required this.outlineColor,
    required this.highlightColor,
    required this.underlineColor,
    required this.backgroundColor,
    required this.middlegroundColor
  });
}