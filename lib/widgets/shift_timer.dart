import 'package:accelerationstation/services/dashboard_theme.dart';
import 'package:accelerationstation/services/dashboard_state.dart';
import 'package:flutter/material.dart';

class ShiftTimer extends StatelessWidget {
  final DashboardState dashboardState;

  const ShiftTimer({
    super.key,
    required this.dashboardState,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: dashboardState.matchTime(),
      builder: (context, snapshot) {
        String timeString = '0:00';

        if (snapshot.hasData && snapshot.data != -1) {
          int mins = (snapshot.data! / 60).floor();
          int secs = (snapshot.data! % 60).floor();

          timeString = '$mins:${secs.toString().padLeft(2, '0')}';
        }

        return Container(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: FittedBox(
            fit: BoxFit.fitHeight,
            child: Column(
              children: [
                Text(
                  timeString,
                  style: const TextStyle(
                    fontFamily: DashboardTheme.font,
                    letterSpacing: -8,
                    fontSize: 130,
                    height: 1.0,
                    shadows: [
                      Shadow(
                        blurRadius: 20.0,
                        color: Color.fromARGB(150, 0, 140, 200),
                        offset: Offset(0.0, 0.0)
                      )
                    ]
                  ),
                ),
                Text(
                  '- Shift Timer -',
                  style: const TextStyle(
                    fontFamily: DashboardTheme.font,
                    fontSize: 15,
                    color: Colors.grey
                  ),
                ),
              ]
            ),
          ),
        );
      },
    );
  }
}