import 'package:accelerationstation/services/dashboard_theme.dart';
import 'package:flutter/material.dart';

class HoverTab extends StatefulWidget {
  final String text;
  final bool selected;

  const HoverTab({
    super.key,
    required this.text,
    required this.selected,
  });

  @override
  State<HoverTab> createState() => _HoverTabState();
}

class _HoverTabState extends State<HoverTab> {
  bool hovering = false;

  @override
  Widget build(BuildContext context) {
    Color color;

    if (widget.selected) {
      color = DashboardTheme.highlightColor;
    } else if (hovering) {
      color = DashboardTheme.highlightColor;
    } else {
      color = DashboardTheme.outlineColor;
    }

    return MouseRegion(
      onEnter: (_) => setState(() => hovering = true),
      onExit: (_) => setState(() => hovering = false),
      child: Text(
        widget.text,
        style: TextStyle(
          color: color,
          fontSize: 22,
        ),
      ),
    );
  }
}