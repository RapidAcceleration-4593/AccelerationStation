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

  int selectedIndex = 0;

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
              title: Text(
                DashboardTheme.themes[index].name,
                style: TextStyle(
                  fontFamily: DashboardTheme.font,
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