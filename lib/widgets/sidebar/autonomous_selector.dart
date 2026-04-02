import 'package:accelerationstation/services/dashboard_state.dart';
import 'package:accelerationstation/services/dashboard_theme.dart';
import 'package:accelerationstation/widgets/animated_startup.dart';
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
    'NoPickup',
  ];
  final List<String> transversalOptions = [
    'NoTraversal',
    'Trench',
    'Bump',
  ];
  final List<String> otherAutos = [
    '',
    'DoNothing',
    'Left2xCenterTrench',
    'Right2xCenterTrench',
  ];
  final List<String> autoRoutines = [
    'LeftCenterTrench',
    'LeftCenterBump',
    'LeftNoPickupNoTraversal',

    'CenterNoPickupNoTraversal',

    'RightCenterTrench',
    'RightCenterBump',
    'RightNoPickupNoTraversal',

    'DoNothing',
    'Left2xCenterTrench',
    'Right2xCenterTrench',
  ];

  late String selectedStartPosition;
  late String selectedFuelPickup;
  late String selectedTraversalOption;
  late String selectedOtherAuto;

  @override
  void initState() {
    super.initState();

    selectedStartPosition = startPositions.first;
    selectedFuelPickup = fuelPickupOptions.first;
    selectedTraversalOption = transversalOptions.first;
    selectedOtherAuto = otherAutos.elementAt(1);

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
          Image.asset(
            'images/logo.png',
            height: 70,
          ),
          AnimatedStartupWidget(
            delay: Duration(milliseconds: 200),
            length: Duration(milliseconds: 100),
            child: _buildDropdown(
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
          ),
          AnimatedStartupWidget(
            delay: Duration(milliseconds: 400),
            length: Duration(milliseconds: 200),
            child: _buildDropdown(
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
          ),
          AnimatedStartupWidget(
            delay: Duration(milliseconds: 600),
            length: Duration(milliseconds: 400),
            child: _buildDropdown(
              label: 'Traversal: ',
              options: transversalOptions,
              selectedValue: selectedTraversalOption,
              onChanged: (value) {
                selectedTraversalOption = value;
                final String auto = getAutoRoutine();
                if (auto != 'Invalid') widget.dashboardState.setSelectedAuto(auto);
              },
              enabled: selectedOtherAuto == ''
            ),
          ),
          AnimatedStartupWidget(
            delay: Duration(milliseconds: 800),
            length: Duration(milliseconds: 700),
            child: _buildDropdown(
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
          ),
          AnimatedStartupWidget(
            delay: Duration(milliseconds: 1000),
            length: Duration(milliseconds: 1100),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(8),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: getAutoRoutine() != 'Invalid' ? DashboardTheme.backgroundColor : const Color.fromARGB(127, 244, 67, 54),
                borderRadius: BorderRadius.circular(0.0),
                border: Border.all(color: getAutoRoutine() != 'Invalid' ? DashboardTheme.outlineColor : Colors.red, width: 1.0)
              ),
              child: Text(
                overflow: TextOverflow.clip,
                softWrap: false,
                getAutoRoutine() != 'Invalid' ? 'Selected Routine: ${getAutoRoutine()}' : '!Selected Autonomous: ${getAutoRoutine()}!',
                style: TextStyle(
                  color: DashboardTheme.highlightColor,
                  fontFamily: DashboardTheme.font,
                  fontSize: 20
                ),
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
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8),
      decoration: BoxDecoration(
        // color: enabled ? DashboardTheme.backgroundColor : Colors.transparent,
        border: Border.all(color: enabled ? DashboardTheme.highlightColor : DashboardTheme.outlineColor, width: 1.0),
        borderRadius: BorderRadius.circular(0.0),
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
                color: enabled ? DashboardTheme.highlightColor : DashboardTheme.outlineColor
              ),
            );
          }).toList();
        },
      ),
    );
  }

  String getAutoRoutine() {
    final String auto = selectedStartPosition + selectedFuelPickup + selectedTraversalOption;
    if (autoRoutines.contains(selectedOtherAuto)) return selectedOtherAuto;
    if (autoRoutines.contains(auto)) return auto;
    return 'Invalid';
  }
}