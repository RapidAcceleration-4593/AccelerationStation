import 'package:accelerationstation/services/dashboard_theme.dart';
import 'package:accelerationstation/services/dashboard_state.dart';
import 'package:accelerationstation/widgets/animated_startup.dart';
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

        Color leftColor = const Color.fromARGB(100, 33, 149, 243);
        Color rightColor = const Color.fromARGB(100, 244, 67, 54);

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
              case 4:
                hintText = '- Shift 4 -';
              case 3:
                hintText = '- Shift 3 -';
              case 2:
                hintText = '- Shift 2 -';
              case 1:
                hintText = '- Shift 1 -';
              case 0:
                hintText = '- Transition Shift -';
                leftColor = Colors.blue;
                rightColor = Colors.red;
              case -1:
                hintText = '- Autonomous -';
                leftColor = Colors.blue;
                rightColor = Colors.red;
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
              child: AnimatedStartupWidget(
                delay: Duration(milliseconds: 1800),
                length: Duration(milliseconds: 300),
                curve: Curves.easeOutBack,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: 110,
                      margin: const EdgeInsets.fromLTRB(30, 10, 30, 0),
                      decoration: BoxDecoration(
                        color: leftColor,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: DashboardTheme.outlineAlliances ? DashboardTheme.outlineColor : Colors.transparent, width: 2.0),
                        boxShadow: [
                          BoxShadow(
                            color: leftColor.a < 0.5 ? Colors.transparent : leftColor.withAlpha(150),
                            blurRadius: 18,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    AnimatedStartupWidget(
                      delay: Duration(milliseconds: 2200),
                      length: Duration(milliseconds: 300),
                      curve: Curves.easeOutBack,
                      child: _buildWiimoteUI(redAlliance: false)
                    ),
                  ],
                ),
              ),
            ),
            AnimatedStartupWidget(
              delay: Duration(milliseconds: 1600),
              length: Duration(milliseconds: 300),
              curve: Curves.easeOutBack,
              child: Container(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                decoration: BoxDecoration(
                  color: DashboardTheme.middlegroundColor,
                  borderRadius: BorderRadius.circular(20.0),
                  border: Border.all(color: DashboardTheme.outlineColor)
                ),
                child: FittedBox(
                  fit: BoxFit.fitHeight,
                  child: Column(
                    children: [
                      Text(
                        timeString,
                        style: TextStyle(
                          fontFamily: DashboardTheme.font,
                          color: DashboardTheme.highlightColor,
                          letterSpacing: -8,
                          fontSize: 130,
                          height: 1.0,
                          shadows: [
                            Shadow(
                              blurRadius: 15.0,
                              color: DashboardTheme.highlightColor.withAlpha(100),
                              offset: Offset(0.0, 0.0)
                            )
                          ]
                        ),
                      ),
                      Text(
                        hintText,
                        style: TextStyle(
                          fontFamily: DashboardTheme.font,
                          fontSize: 15,
                          color: DashboardTheme.highlightColor.withAlpha(150)
                        ),
                      ),
                    ]
                  ),
                ),
              ),
            ),
            Expanded(
              child: AnimatedStartupWidget(
                delay: Duration(milliseconds: 2000),
                length: Duration(milliseconds: 300),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: 110,
                      margin: const EdgeInsets.fromLTRB(30, 10, 30, 0),
                      decoration: BoxDecoration(
                        color: rightColor,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: DashboardTheme.outlineAlliances ? DashboardTheme.outlineColor : Colors.transparent, width: 2.0),
                        boxShadow: [
                          BoxShadow(
                            color: rightColor.a < 0.5 ? Colors.transparent : rightColor.withAlpha(150),
                            blurRadius: 18,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),
                    
                    AnimatedStartupWidget(
                      delay: Duration(milliseconds: 2300),
                      length: Duration(milliseconds: 300),
                      curve: Curves.easeOutBack,
                      child: _buildWiimoteUI(redAlliance: true)
                    ),
                  ],
                ),
              )
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
        color: DashboardTheme.middlegroundColor,
        borderRadius: BorderRadius.circular(3),
        border: Border.all(color: DashboardTheme.outlineColor, strokeAlign: BorderSide.strokeAlignOutside)
      ),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Row(
          spacing: 9,
          children: [
            Expanded(
              child: AnimatedStartupWidget(
                delay: Duration(milliseconds: !redAlliance ? 3000 : 3200),
                length: Duration(milliseconds: 100),
                curve: Curves.easeOutBack,
                child: _buildWiimoteLight(enabled: dashboardState.getAllianceRemainingShifts(redAlliance: redAlliance) >= 1),
              ),
            ),
            Expanded(
              child: AnimatedStartupWidget(
                delay: Duration(milliseconds: !redAlliance ? 3050 : 3250),
                length: Duration(milliseconds: 100),
                curve: Curves.easeOutBack,
                child: _buildWiimoteLight(enabled: dashboardState.getAllianceRemainingShifts(redAlliance: redAlliance) >= 2),
              ),
            ),
            Expanded(
              child: AnimatedStartupWidget(
                delay: Duration(milliseconds: !redAlliance ? 3100 : 3300),
                length: Duration(milliseconds: 100),
                curve: Curves.easeOutBack,
                child: _buildWiimoteLight(enabled: dashboardState.getAllianceRemainingShifts(redAlliance: redAlliance) >= 3),
              ),
            ),
            Expanded(
              child: AnimatedStartupWidget(
                delay: Duration(milliseconds: !redAlliance ? 3150 : 3350),
                length: Duration(milliseconds: 100),
                curve: Curves.easeOutBack,
                child: _buildWiimoteLight(enabled: dashboardState.getAllianceRemainingShifts(redAlliance: redAlliance) >= 4),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildWiimoteLight({
    required bool enabled,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: enabled ? DashboardTheme.highlightColor : DashboardTheme.backgroundColor,
        boxShadow: [
          BoxShadow(
            color: enabled ? DashboardTheme.highlightColor.withAlpha(100) : Colors.transparent,
            blurRadius: 3
          )
        ]
      ),
    );
  }
}