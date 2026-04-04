import 'package:accelerationstation/services/dashboard_theme.dart';
import 'package:flutter/material.dart';

class FooterLeft extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 20,
      bottom: 8,
      child: Text(
        'Created by Lincoln Tupper and Team 4593',
        style: TextStyle(
          fontFamily: DashboardTheme.font,
          fontSize: 14,
          color: DashboardTheme.outlineColor
        )
      )
    );
  }
}