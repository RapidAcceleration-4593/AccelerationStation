import 'package:accelerationstation/services/dashboard_state.dart';
import 'package:accelerationstation/services/dashboard_theme.dart';
import 'package:flutter/material.dart';

class TurretWarning extends StatelessWidget {
  final DashboardState dashboardState;

  const TurretWarning({
    super.key,
    required this.dashboardState,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: dashboardState.turretAngle(),
      builder: (context, snapshot) {
        final double angle = (snapshot.hasData ? snapshot.data as double : 0.0) * 180/3.1415;

        return Stack(
          children: [
            Align(
              alignment: AlignmentGeometry.centerLeft,
              child: Padding(
                padding: EdgeInsetsGeometry.only(left: 80),
                child: _buildWarning(warningText: 'Target Angle\nMinimum Reached', condition: angle < -75.0)
              ),
            ),
            Align(
              alignment: AlignmentGeometry.centerRight,
              child: Padding(
                padding: EdgeInsetsGeometry.only(right: 80),
                child: _buildWarning(warningText: 'Turret Angle\nMaximum Reached', condition: angle > 75.0)
              ),
            )
          ],
        );
      },
    );
  }

  Widget _buildWarning({
    required String warningText,
    required bool condition
  }) {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: !condition ? Colors.transparent : const Color.fromARGB(188, 233, 54, 41),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: !condition ? Colors.transparent : const Color.fromARGB(0, 255, 255, 255), width: 6.0),
        // boxShadow: [
        //   BoxShadow(
        //     color: !condition ? Colors.transparent : const Color.fromARGB(100, 244, 67, 54),
        //     blurRadius: 0
        //   )
        // ]
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '!WARNING!',
            style: TextStyle(
              fontFamily: DashboardTheme.font,
              fontSize: 26,
              color: !condition ? Colors.transparent : const Color.fromARGB(255, 255, 255, 255)
            ),
          ),
          Text(
            warningText,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: DashboardTheme.font,
              fontSize: 12,
              color: !condition ? Colors.transparent : const Color.fromARGB(255, 255, 255, 255)
            ),
          ),
        ],
      )
    );
  }
}