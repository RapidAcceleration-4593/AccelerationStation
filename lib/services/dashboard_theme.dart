import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardTheme {
  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final savedTheme = prefs.getInt('theme') ?? 0;
    themeNotifier.value = savedTheme;
  }

  static Future<void> _saveTheme(int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('theme', value);
  }

  static const font = "JetBrainsMono";

  static final ValueNotifier<int> themeNotifier = ValueNotifier(0);

  static int get selectedTheme => themeNotifier.value;
  static set selectedTheme(int value) {
    themeNotifier.value = value;
    _saveTheme(value);
  }

  static String get logoImage => themes[selectedTheme].logoImage;
  static Color get outlineColor => themes[selectedTheme].outlineColor;
  static Color get highlightColor => themes[selectedTheme].highlightColor;
  static Color get underlineColor => themes[selectedTheme].underlineColor;
  static Color get backgroundColor => themes[selectedTheme].backgroundColor;
  static Color get middlegroundColor => themes[selectedTheme].middlegroundColor;
  static bool get outlineAlliances => themes[selectedTheme].outlineAlliances;

  static const List<Theme> themes = [
    Theme(
      name: 'Void (default)',
      logoImage: 'images/logo.png',
      outlineColor: Color.fromARGB(255, 81, 93, 110),
      highlightColor: Color.fromARGB(255, 166, 235, 252),
      underlineColor: Color.fromARGB(255, 228, 140, 8),
      backgroundColor: Color.fromARGB(255, 13, 17, 23),
      middlegroundColor: Color.fromARGB(255, 0, 0, 0),
    ),
    Theme(
      name: 'Acceleration',
      logoImage: 'images/logo.png',
      outlineColor: Color.fromARGB(255, 124, 97, 65),
      highlightColor: Color.fromARGB(255, 255, 224, 123),
      underlineColor: Color.fromARGB(255, 228, 103, 19),
      backgroundColor: Color.fromARGB(255, 27, 11, 18),
      middlegroundColor: Color.fromARGB(255, 8, 3, 5),
    ),
    Theme(
      name: 'Azalea',
      logoImage: 'images/logo.png',
      outlineColor: Color.fromARGB(255, 136, 71, 114),
      highlightColor: Color.fromARGB(255, 255, 168, 219),
      underlineColor: Color.fromARGB(255, 228, 8, 118),
      backgroundColor: Color.fromARGB(255, 20, 11, 27),
      middlegroundColor: Color.fromARGB(255, 12, 4, 8),
    ),
    Theme(
      name: 'Emerald',
      logoImage: 'images/logo.png',
      outlineColor: Color.fromARGB(255, 73, 128, 68),
      highlightColor: Color.fromARGB(255, 150, 255, 181),
      underlineColor: Color.fromARGB(255, 8, 228, 144),
      backgroundColor: Color.fromARGB(255, 7, 25, 29),
      middlegroundColor: Color.fromARGB(255, 4, 12, 9),
    ),
    Theme(
      name: 'Light',
      logoImage: 'images/logo_dark.png',
      outlineColor: Color.fromARGB(255, 73, 73, 73),
      highlightColor: Color.fromARGB(255, 0, 0, 0),
      underlineColor: Color.fromARGB(255, 228, 140, 8),
      backgroundColor: Color.fromARGB(255, 136, 150, 146),
      middlegroundColor: Color.fromARGB(255, 195, 206, 202),
      outlineAlliances: true,
    ),
    Theme(
      name: 'Eye Bleach',
      logoImage: 'images/logo.png',
      outlineColor: Color.fromARGB(255, 255, 0, 0),
      highlightColor: Color.fromARGB(255, 0, 255, 0),
      underlineColor: Color.fromARGB(255, 0, 0, 255),
      backgroundColor: Color.fromARGB(255, 255, 255, 0),
      middlegroundColor: Color.fromARGB(255, 255, 0, 255),
    ),
  ];
}

class Theme{
  final String name;
  final String logoImage;
  final Color outlineColor;
  final Color highlightColor;
  final Color underlineColor;
  final Color backgroundColor;
  final Color middlegroundColor;
  final bool outlineAlliances;
  
  const Theme({
    required this.name,
    required this.logoImage,
    required this.outlineColor,
    required this.highlightColor,
    required this.underlineColor,
    required this.backgroundColor,
    required this.middlegroundColor,
    this.outlineAlliances = false
  });
}