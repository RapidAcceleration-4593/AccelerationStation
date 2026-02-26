import 'package:accelerationstation/services/dashboard_theme.dart';
import 'package:accelerationstation/services/dashboard_state.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class ShiftTimer extends StatelessWidget {
  final DashboardState dashboardState;

  const ShiftTimer({
    super.key,
    required this.dashboardState,
  });

  @override
  Widget build(BuildContext context) {
    final combinedStream = Rx.combineLatest3<double, bool, bool, Map<String, dynamic>>(
      dashboardState.matchTime(),
      dashboardState.isRedAlliance(),
      dashboardState.isHubEnabled(),
      (matchTime, redAlliance, hubEnabled) => {
        'time': matchTime,
        'redAlliance': redAlliance,
        'hubEnabled': hubEnabled
      },
    );

    return StreamBuilder<Map<String, dynamic>>(
      stream: combinedStream,
      builder: (context, snapshot) {
        String hintText = '- Shift Timer -';

        String timeString = '0:00';

        Color leftColor = const Color.fromARGB(50, 33, 149, 243);
        Color rightColor = const Color.fromARGB(50, 244, 67, 54);

        if (snapshot.hasData) {
          final double matchTime = snapshot.data!['time'] as double;
          final bool redAlliance = snapshot.data!['redAlliance'] as bool;
          final bool hubEnabled = snapshot.data!['hubEnabled'] as bool;

          if (matchTime != -1.0) {
            double time = matchTime;
            final int shift = dashboardState.getCurrentShift();

            switch (shift) {
              case 5:
                hintText = '- ENDGAME -';
                leftColor = Colors.blue;
                rightColor = Colors.red;
              case 4:
                hintText = '- Shift 4 -';
                time -= 30.0;
              case 3:
                hintText = '- Shift 3 -';
                time -= 55.0;
              case 2:
                hintText = '- Shift 2 -';
                time -= 80.0;
              case 1:
                hintText = '- Shift 1 -';
                time -= 105.0;
              case 0:
                hintText = '- Transition Shift -';
                time -= 130.0;
                leftColor = Colors.blue;
                rightColor = Colors.red;
              case -1:
                hintText = '- Autonomous -';
                leftColor = Colors.blue;
                rightColor = Colors.red;
            }

            int mins = (time / 60).floor();
            int secs = (time % 60).floor();
            timeString = '$mins:${secs.toString().padLeft(2, '0')}';

            final bool same = redAlliance == hubEnabled;
            if (redAlliance && same) rightColor = Colors.red;
            if (redAlliance && !same) leftColor = Colors.blue;
            if (!redAlliance && same) leftColor = Colors.blue;
            if (!redAlliance && !same) rightColor = Colors.red;
          }
        }

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                margin: EdgeInsets.fromLTRB(40, 0, 40, 0),
                padding: EdgeInsets.only(bottom: 110),
                decoration: BoxDecoration(
                  color: leftColor,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: leftColor,
                      blurRadius: 20
                    )
                  ]
                ),
                child: FittedBox(
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              decoration: BoxDecoration(
                color: const Color.fromARGB(132, 0, 0, 0),
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
                      hintText,
                      style: const TextStyle(
                        fontFamily: DashboardTheme.font,
                        fontSize: 15,
                        color: Colors.grey
                      ),
                    ),
                  ]
                ),
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.fromLTRB(40, 0, 40, 0),
                padding: EdgeInsets.only(bottom: 110),
                decoration: BoxDecoration(
                  color: rightColor,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: rightColor,
                      blurRadius: 20
                    )
                  ]
                ),
                child: FittedBox(
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}