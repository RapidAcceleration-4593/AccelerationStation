import 'package:accelerationstation/services/dashboard_state.dart';
import 'package:accelerationstation/services/dashboard_theme.dart';
import 'package:flutter/material.dart';

class AutonomousSelector extends StatefulWidget {
  final DashboardState dashboardState;
  final bool redAlliance;

  const AutonomousSelector({
    super.key,
    required this.dashboardState,
    required this.redAlliance,
  });

  @override
  State<AutonomousSelector> createState() => _AutonomousSelectorState();
}

class _AutonomousSelectorState extends State<AutonomousSelector> {
  final List<String> autonomousPositions = [
    'Left',
    'Center',
    'Right',
  ];

  String? selectedPos = 'Left';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "- Select Autonomous -",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.normal,
              fontFamily: DashboardTheme.font,
              shadows: [
                Shadow(
                  blurRadius: 10.0,
                  color: Color.fromARGB(150, 0, 200, 200),
                  offset: Offset(0.0, 0.0)
                )
              ]
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(10),
            ),
            child: DropdownButton<String>(
              alignment: AlignmentGeometry.center,
              value: selectedPos,
              isExpanded: true,
              underline: Container(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedPos = newValue;
                  widget.dashboardState.setAutoPos(selectedPos!);
                });
              },
              items: autonomousPositions.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  alignment: AlignmentGeometry.center,
                  value: value,
                  child: Text(
                    value,
                    style: const TextStyle(
                      fontSize: 28,
                      fontFamily: DashboardTheme.font,
                    ),
                  ),
                );
              }).toList(),
              selectedItemBuilder: (BuildContext context) {
                return autonomousPositions.map<Widget>((String value) {
                  return Text(
                    "Auto Position: $value",
                    style: const TextStyle(
                      fontSize: 28,
                      fontFamily: DashboardTheme.font,
                    ),
                  );
                }).toList();
              },
            ),
          ),
        ],
      ),
    );
  }
}
