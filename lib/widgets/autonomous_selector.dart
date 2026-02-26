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
  final List<String> startPositions = [
    'Left',
    'Center',
    'Right',
  ];
  final List<String> fuelPickup = [
    'Center',
    'Depot',
    'Outpost',
  ];
  final List<String> climbOptions = [
    'Left',
    'Center',
    'Right',
    'No Climb',
  ];

  String? selectedStartPosition;
  String? selectedFuelPickup;
  String? selectedClimbPosition;

  @override
  void initState() {
    super.initState();

    selectedStartPosition = startPositions.first;
    selectedFuelPickup = fuelPickup.first;
    selectedClimbPosition = climbOptions.first;

    // Optional: push defaults to dashboard state immediately
    widget.dashboardState.setAutoStartPos(selectedStartPosition!);
    widget.dashboardState.setAutoFuelPickup(selectedFuelPickup!);
    widget.dashboardState.setAutoClimbPos(selectedClimbPosition!);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 0.0),
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
                  blurRadius: 20.0,
                  color: Color.fromARGB(255, 0, 160, 200),
                  offset: Offset(0.0, 0.0)
                )
              ]
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: DropdownButton<String>(
              alignment: AlignmentGeometry.center,
              value: selectedStartPosition,
              isExpanded: true,
              underline: Container(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedStartPosition = newValue;
                  widget.dashboardState.setAutoStartPos(selectedStartPosition!);
                });
              },
              items: startPositions.map<DropdownMenuItem<String>>((String value) {
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
                return startPositions.map<Widget>((String value) {
                  return Text(
                    "Start Position: $value",
                    style: const TextStyle(
                      fontSize: 28,
                      fontFamily: DashboardTheme.font,
                      color: Colors.grey
                    ),
                  );
                }).toList();
              },
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: DropdownButton<String>(
              alignment: AlignmentGeometry.center,
              value: selectedFuelPickup,
              isExpanded: true,
              underline: Container(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedFuelPickup = newValue;
                  widget.dashboardState.setAutoFuelPickup(selectedFuelPickup!);
                });
              },
              items: fuelPickup.map<DropdownMenuItem<String>>((String value) {
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
                return fuelPickup.map<Widget>((String value) {
                  return Text(
                    "Fuel Pickup: $value",
                    style: const TextStyle(
                      fontSize: 28,
                      fontFamily: DashboardTheme.font,
                      color: Colors.grey
                    ),
                  );
                }).toList();
              },
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: DropdownButton<String>(
              alignment: AlignmentGeometry.center,
              value: selectedClimbPosition,
              isExpanded: true,
              underline: Container(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedClimbPosition = newValue;
                  widget.dashboardState.setAutoClimbPos(selectedClimbPosition!);
                });
              },
              items: climbOptions.map<DropdownMenuItem<String>>((String value) {
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
                return climbOptions.map<Widget>((String value) {
                  return Text(
                    "Climb Position: $value",
                    style: const TextStyle(
                      fontSize: 28,
                      fontFamily: DashboardTheme.font,
                      color: Colors.grey
                    ),
                  );
                }).toList();
              },
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 20, 20, 20),
              borderRadius: BorderRadius.circular(10)
            ),
            child: Text(
              'Selected Autonomous: ',
              style: TextStyle(
                fontFamily: DashboardTheme.font,
                fontSize: 20
              ),
            ),
          )
        ],
      ),
    );
  }
}

String getAutoRoutine(String startPos, String fuelPickup, String climb) {
  final String auto = startPos + fuelPickup + climb;
  return '';
}