import 'package:accelerationstation/services/dashboard_theme.dart';
import 'package:flutter/material.dart';

class FooterLeft extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Positioned(
      left: 20,
      bottom: 8,
      child: Text(
        'Created by Rapid Acceleration Team 4593',
        style: DashboardTheme.footerText,
      ),
    );
  }
}