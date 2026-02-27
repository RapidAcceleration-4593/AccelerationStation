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
  final List<String> fuelPickupOptions = [
    'Center',
    'Depot',
    'Outpost',
    'NoPickup',
  ];
  final List<String> climbOptions = [
    'Left',
    'Center',
    'Right',
    'NoClimb',
  ];
  final List<String> autoRoutines = [
    'LeftDepotLeft',
    'leftDepotCenter',
    'LeftDepotNoClimb',
    'LeftCenterLeft',
    'LeftCenterCenter',
    'LeftCenterNoClimb',
    'LeftNoPickupLeft',
    'LeftNoPickupCenter',
    'LeftNoPickupNoClimb',

    'CenterDepotCenter',
    'CenterDepotNoClimb',
    'CenterNoPickupCenter',
    'CenterNoPickupNoClimb',

    'RightOutpostRight',
    'RightOutpostCenter',
    'RightOutpostNoClimb',
    'RightCenterRight',
    'RightCenterCenter',
    'RightCenterNoClimb',
    'RightNoPickupRight',
    'RightNoPickupCenter',
    'RightNoPickupNoClimb',
  ];

  late String selectedStartPosition;
  late String selectedFuelPickup;
  late String selectedClimbOption;
  late String selectedAutoRoutine;

  @override
  void initState() {
    super.initState();

    selectedStartPosition = startPositions.first;
    selectedFuelPickup = fuelPickupOptions.first;
    selectedClimbOption = climbOptions.first;
    selectedAutoRoutine = getAutoRoutine();

    // Push defaults to dashboard state.
    widget.dashboardState.setAutoStartPos(selectedStartPosition);
    widget.dashboardState.setAutoFuelPickup(selectedFuelPickup);
    widget.dashboardState.setAutoClimbPos(selectedClimbOption);
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
          _buildDropdown(
            label: 'Start Position: ',
            options: startPositions,
            selectedValue: selectedStartPosition,
            onChanged: (value) {
              selectedStartPosition = value;
              if (getAutoRoutine() != 'Invalid') widget.dashboardState.setAutoStartPos(selectedStartPosition);
            },
          ),
          const SizedBox(height: 24),
          _buildDropdown(
            label: 'Fuel Pickup: ',
            options: fuelPickupOptions,
            selectedValue: selectedFuelPickup,
            onChanged: (value) {
              selectedFuelPickup = value;
              if (getAutoRoutine() != 'Invalid') widget.dashboardState.setAutoFuelPickup(selectedFuelPickup);
            },
          ),
          const SizedBox(height: 24),
          _buildDropdown(
            label: 'Climb Position: ',
            options: climbOptions,
            selectedValue: selectedClimbOption,
            onChanged: (value) {
              selectedClimbOption = value;
              if (getAutoRoutine() != 'Invalid') widget.dashboardState.setAutoClimbPos(selectedClimbOption);
            },
          ),
          const SizedBox(height: 24),
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 20, 20, 20),
              borderRadius: BorderRadius.circular(10)
            ),
            child: Text(
              'Selected Autonomous: ' + getAutoRoutine(),
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

  Widget _buildDropdown({
    required String label,
    required List<String> options,
    required String? selectedValue,
    required ValueChanged<String> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButton<String>(
        alignment: AlignmentGeometry.center,
        value: selectedValue,
        isExpanded: true,
        underline: Container(),
        onChanged: (value) {
          if (value != null) {
            setState(() => onChanged(value));

          }
        },
        items: options.map<DropdownMenuItem<String>>((String value) {
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
          return options.map<Widget>((String value) {
            return Text(
              "$label$value",
              style: const TextStyle(
                fontSize: 28,
                fontFamily: DashboardTheme.font,
                color: Colors.grey
              ),
            );
          }).toList();
        },
      ),
    );
  }

  String getAutoRoutine() {
    final String auto = selectedStartPosition + selectedFuelPickup + selectedClimbOption;
    if (autoRoutines.contains(auto)) return auto;
    return 'Invalid';
  }
}