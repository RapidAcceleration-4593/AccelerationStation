import 'package:accelerationstation/services/dashboard_state.dart';
import 'package:accelerationstation/services/dashboard_theme.dart';
import 'package:flutter/material.dart';

class VisionTab extends StatefulWidget {
  final DashboardState dashboardState;

  const VisionTab({super.key, required this.dashboardState});

  @override
  State<VisionTab> createState() => _VisionTabState();
}

class _VisionTabState extends State<VisionTab>
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
            widget.dashboardState.setSelectedVisionSystem(value == 0 ? 'Oculus' : 'OrangePi');
          });
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsetsGeometry.only(left: 22.0, bottom: 10.0, top: 10.0),
              child: Text(
                'Selected Camera System',
                style: TextStyle(
                  color: DashboardTheme.outlineColor,
                  fontFamily: DashboardTheme.font,
                  fontSize: 16,
                ),
              ),
            ),
            RadioListTile(
              value: 0,
              fillColor: WidgetStateColor.resolveWith((states) {
                return DashboardTheme.highlightColor;
              }),
              activeColor: DashboardTheme.highlightColor,
              dense: true,
              title: Text(
                'Oculus',
                style: TextStyle(
                  fontFamily: DashboardTheme.font,
                  color: selectedIndex == 0 ? DashboardTheme.highlightColor : DashboardTheme.outlineColor,
                  fontSize: 16
                ),
              ),
            ),
            RadioListTile(
              value: 1,
              fillColor: WidgetStateColor.resolveWith((states) {
                return DashboardTheme.highlightColor;
              }),
              activeColor: DashboardTheme.highlightColor,
              dense: true,
              title: Text(
                'OrangePi',
                style: TextStyle(
                  fontFamily: DashboardTheme.font,
                  color: selectedIndex == 1 ? DashboardTheme.highlightColor : DashboardTheme.outlineColor,
                  fontSize: 16
                ),
              ),
            )
          ],
        ),
      )
    );
  }
}