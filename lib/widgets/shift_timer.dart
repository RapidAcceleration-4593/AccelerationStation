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
    final combinedStream = Rx.combineLatest3<bool, bool, double, Map<String, dynamic>>(
      dashboardState.isRedAlliance(),
      dashboardState.isHubEnabled(),
      dashboardState.matchTime(),
      (redAlliance, hubEnabled, matchTime) => {
        'redAlliance': redAlliance,
        'hubEnabled': hubEnabled,
        'matchTime': matchTime
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
          final double shiftTime = dashboardState.getShiftTime();
          final bool redAlliance = snapshot.data!['redAlliance'] as bool;
          final bool hubEnabled = snapshot.data!['hubEnabled'] as bool;
          final int shift = dashboardState.getCurrentShift();

          if (shift != -2) {
            switch (shift) {
              case 5:
                hintText = '- ENDGAME -';
                leftColor = Colors.blue;
                rightColor = Colors.red;
                break;
              case 4:
                hintText = '- Shift 4 -';
                break;
              case 3:
                hintText = '- Shift 3 -';
                break;
              case 2:
                hintText = '- Shift 2 -';
                break;
              case 1:
                hintText = '- Shift 1 -';
                break;
              case 0:
                hintText = '- Transition Shift -';
                leftColor = Colors.blue;
                rightColor = Colors.red;
                break;
              case -1:
                hintText = '- Autonomous -';
                leftColor = Colors.blue;
                rightColor = Colors.red;
                break;
            }

            int totalSeconds = shiftTime.ceil();
            int mins = totalSeconds ~/ 60;
            int secs = totalSeconds % 60;
            timeString = '$mins:${secs.toString().padLeft(2, '0')}';

            final bool same = redAlliance == hubEnabled;
            if (redAlliance && same) rightColor = Colors.red;
            if (redAlliance && !same) leftColor = Colors.blue;
            if (!redAlliance && same) rightColor = Colors.red;
            if (!redAlliance && !same) leftColor = Colors.blue;
          }
        }

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 110,
                    margin: const EdgeInsets.fromLTRB(30, 10, 30, 0),
                    decoration: BoxDecoration(
                      color: leftColor,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: leftColor.a < 0.5 ? Colors.transparent : leftColor.withAlpha(150),
                          blurRadius: 18,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  _buildWiimoteUI(redAlliance: false)
                ],
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
                            blurRadius: 15.0,
                            color: Color.fromARGB(100, 0, 140, 200),
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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 110,
                    margin: const EdgeInsets.fromLTRB(30, 10, 30, 0),
                    decoration: BoxDecoration(
                      color: rightColor,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: rightColor.a < 0.5 ? Colors.transparent : rightColor.withAlpha(150),
                          blurRadius: 18,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  _buildWiimoteUI(redAlliance: true)
                ],
              ),
            )
          ],
        );
      },
    );
  }

  Widget _buildWiimoteUI({
    required bool redAlliance
  }) {
    return Container(
      height: 30,
      width: 100,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 32, 34, 39),
        borderRadius: BorderRadius.circular(4)
        // border: Border.all(color: Colors.black, width: 6.0, strokeAlign: BorderSide.strokeAlignOutside)
      ),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Row(
          spacing: 9,
          children: [
            _buildWiimoteLight(enabled: dashboardState.getAllianceRemainingShifts(redAlliance: redAlliance) >= 1),
            _buildWiimoteLight(enabled: dashboardState.getAllianceRemainingShifts(redAlliance: redAlliance) >= 2),
            _buildWiimoteLight(enabled: dashboardState.getAllianceRemainingShifts(redAlliance: redAlliance) >= 3),
            _buildWiimoteLight(enabled: dashboardState.getAllianceRemainingShifts(redAlliance: redAlliance) >= 4)
          ],
        ),
      ),
    );
  }

  Widget _buildWiimoteLight({
    required bool enabled,
  }) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: enabled ? const Color.fromARGB(200, 220, 220, 255) : const Color.fromARGB(97, 0, 0, 0),
          boxShadow: [
            BoxShadow(
              color: enabled ? const Color.fromARGB(120, 3, 168, 244) : Colors.transparent,
              blurRadius: 3
            )
          ]
        ),
      ),
    );
  }
}