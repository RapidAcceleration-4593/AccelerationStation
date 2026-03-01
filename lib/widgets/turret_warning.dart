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
                padding: EdgeInsetsGeometry.only(left: 100),
                child: Container(
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: angle > -75.0 ? Colors.transparent : const Color.fromARGB(127, 244, 67, 54),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: angle > -75.0 ? Colors.transparent : Colors.red, width: 2.0),
                    boxShadow: [
                      BoxShadow(
                        color: angle > -75.0 ? Colors.transparent : const Color.fromARGB(179, 244, 67, 54),
                        blurRadius: 40
                      )
                    ]
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '!WARNING!',
                        style: TextStyle(
                          fontFamily: DashboardTheme.font,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: angle > -75.0 ? Colors.transparent : Colors.white
                        ),
                      ),
                      Text(
                        'Turret Angle\nMinimum Reached',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: DashboardTheme.font,
                          fontSize: 12,
                          color: angle > -75.0 ? Colors.transparent : Colors.white
                        ),
                      ),
                    ],
                  )
                ),
              ),
            ),
            Align(
              alignment: AlignmentGeometry.centerRight,
              child: Padding(
                padding: EdgeInsetsGeometry.only(right: 100),
                child: Container(
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: angle < 75.0 ? Colors.transparent : const Color.fromARGB(127, 244, 67, 54),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: angle < 75.0 ? Colors.transparent : Colors.red, width: 2.0),
                    boxShadow: [
                      BoxShadow(
                        color: angle < 75.0 ? Colors.transparent : const Color.fromARGB(179, 244, 67, 54),
                        blurRadius: 40
                      )
                    ]
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '!WARNING!',
                        style: TextStyle(
                          fontFamily: DashboardTheme.font,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: angle < 75.0 ? Colors.transparent : Colors.white
                        ),
                      ),
                      Text(
                        'Turret Angle\nMaximum Reached',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: DashboardTheme.font,
                          fontSize: 12,
                          color: angle < 75.0 ? Colors.transparent : Colors.white
                        ),
                      ),
                    ],
                  )
                ),
              ),
            )
          ],
        );
      },
    );
  }
}