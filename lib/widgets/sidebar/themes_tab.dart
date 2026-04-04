import 'package:accelerationstation/services/dashboard_state.dart';
import 'package:accelerationstation/services/dashboard_theme.dart';
import 'package:flutter/material.dart';

class ThemesTab extends StatefulWidget {
  final DashboardState dashboardState;

  const ThemesTab({super.key, required this.dashboardState});

  @override
  State<ThemesTab> createState() => _ThemesTabState();
}

class _ThemesTabState extends State<ThemesTab>
    with AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive => true;

  int selectedIndex = DashboardTheme.selectedTheme;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return SingleChildScrollView(
      child: RadioGroup(
        groupValue: selectedIndex,
        onChanged: (value) {
          setState(() {
            selectedIndex = value!;
            DashboardTheme.selectedTheme = value;
          });
        },
        child: Column(
          children: List.generate(DashboardTheme.themes.length, (index) {
            return RadioListTile(
              fillColor: WidgetStateColor.resolveWith((states) {
                return DashboardTheme.highlightColor;
              }),
              activeColor: DashboardTheme.highlightColor,
              dense: true,
              title: Text(
                DashboardTheme.themes[index].name,
                style: TextStyle(
                  fontFamily: DashboardTheme.font,
                  color: selectedIndex == index ? DashboardTheme.highlightColor : DashboardTheme.outlineColor,
                  fontSize: 16
                ),
              ),
              value: index,
            );
          }),
        ),
      )
    );
  }
}