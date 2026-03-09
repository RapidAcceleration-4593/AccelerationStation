import 'package:accelerationstation/services/dashboard_state.dart';
import 'package:accelerationstation/services/dashboard_theme.dart';
import 'package:flutter/material.dart';

class AutonomousSelector extends StatefulWidget {
  final DashboardState dashboardState;

  const AutonomousSelector({
    super.key,
    required this.dashboardState,
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
    'Outpost',
    'NoPickup',
  ];
  final List<String> climbOptions = [
    'Left',
    'Right',
    'NoClimb',
  ];
  final List<String> otherAutos = [
    '',
    'RightCenterOutpost',
    'Left2xCenterNoClimb',
  ];
  final List<String> autoRoutines = [
    'LeftCenterLeft',
    'LeftCenterNoClimb',
    'LeftNoPickupLeft',
    'LeftNoPickupNoClimb',

    'CenterNoPickupCenter',
    'CenterNoPickupNoClimb',

    'RightOutpostRight',
    'RightOutpostNoClimb',
    'RightCenterRight',
    'RightCenterNoClimb',
    'RightNoPickupRight',
    'RightNoPickupNoClimb',

    'RightCenterOutpost',
    'Left2xCenterNoClimb',
  ];

  late String selectedStartPosition;
  late String selectedFuelPickup;
  late String selectedClimbOption;
  late String selectedOtherAuto;

  @override
  void initState() {
    super.initState();

    selectedStartPosition = startPositions.first;
    selectedFuelPickup = fuelPickupOptions.first;
    selectedClimbOption = climbOptions.first;
    selectedOtherAuto = otherAutos.first;

    String selectedAutoRoutine = getAutoRoutine();
    if (selectedAutoRoutine != 'Invalid') widget.dashboardState.setSelectedAuto(selectedAutoRoutine);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 0.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 20.0,
        children: [
          Text(
            "- Select Autonomous -",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 28,
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
          _buildDropdown(
            label: 'Start Position: ',
            options: startPositions,
            selectedValue: selectedStartPosition,
            onChanged: (value) {
              selectedStartPosition = value;
              final String auto = getAutoRoutine();
              if (auto != 'Invalid') widget.dashboardState.setSelectedAuto(auto);
            },
            enabled: selectedOtherAuto == ''
          ),
          _buildDropdown(
            label: 'Fuel Pickup: ',
            options: fuelPickupOptions,
            selectedValue: selectedFuelPickup,
            onChanged: (value) {
              selectedFuelPickup = value;
              final String auto = getAutoRoutine();
              if (auto != 'Invalid') widget.dashboardState.setSelectedAuto(auto);
            },
            enabled: selectedOtherAuto == ''
          ),
          _buildDropdown(
            label: 'Climb Position: ',
            options: climbOptions,
            selectedValue: selectedClimbOption,
            onChanged: (value) {
              selectedClimbOption = value;
              final String auto = getAutoRoutine();
              if (auto != 'Invalid') widget.dashboardState.setSelectedAuto(auto);
            },
            enabled: selectedOtherAuto == ''
          ),
          _buildDropdown(
            label: 'Other Autos: ',
            options: otherAutos,
            selectedValue: selectedOtherAuto,
            onChanged: (value) {
              selectedOtherAuto = value;
              final String auto = getAutoRoutine();
              if (auto != 'Invalid') widget.dashboardState.setSelectedAuto(auto);
            },
            enabled: true
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(8),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: getAutoRoutine() != 'Invalid' ? const Color.fromARGB(255, 20, 20, 20) : const Color.fromARGB(127, 244, 67, 54),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: getAutoRoutine() != 'Invalid' ? Colors.transparent : Colors.red, width: 2.0)
            ),
            child: Text(
              overflow: TextOverflow.clip,
              softWrap: false,
              getAutoRoutine() != 'Invalid' ? 'Selected Routine: ${getAutoRoutine()}' : '!Selected Autonomous: ${getAutoRoutine()}!',
              style: TextStyle(
                fontFamily: DashboardTheme.font,
                fontSize: 20
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required List<String> options,
    required String? selectedValue,
    required ValueChanged<String> onChanged,
    required bool enabled,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      decoration: BoxDecoration(
        border: enabled ? Border.all(color: Colors.white, width: 2) : Border.all(color: const Color.fromARGB(255, 77, 77, 77), width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButton<String>(
        alignment: AlignmentGeometry.center,
        value: selectedValue,
        isExpanded: true,
        underline: Container(),
        onChanged: enabled
          ? (value) {
              if (value != null) {
                setState(() => onChanged(value));
              }
            }
          : null,
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
              softWrap: false,
              "$label$value",
              style: TextStyle(
                fontSize: 28,
                fontFamily: DashboardTheme.font,
                color: enabled ? Colors.white : Colors.grey
              ),
            );
          }).toList();
        },
      ),
    );
  }

  String getAutoRoutine() {
    final String auto = selectedStartPosition + selectedFuelPickup + selectedClimbOption;
    if (autoRoutines.contains(selectedOtherAuto)) return selectedOtherAuto;
    if (autoRoutines.contains(auto)) return auto;
    return 'Invalid';
  }
}