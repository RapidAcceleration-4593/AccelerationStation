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
    final combinedStream = Rx.combineLatest2<double, bool, Map<String, dynamic>>(
      dashboardState.matchTime(),
      dashboardState.isAutoEnabled(),
      (matchTime, autoEnabled) => {
        'time': matchTime,
        'autoEnabled': autoEnabled,
      },
    );

    return StreamBuilder<Map<String, dynamic>>(
      stream: combinedStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox();

        double time = snapshot.data!['time'] as double;
        final bool autoEnabled = snapshot.data!['autoEnabled'] as bool;

        String hintText = '- Shift Timer -';
        if (time > 0.0 && time <= 30.0) hintText = '- ENDGAME -';
        if (time > 30.0 && time <= 55.0) {
          hintText = '- Shift 4 -';
          time -= 30.0;
        }
        if (time > 55.0 && time <= 80.0) {
          hintText = '- Shift 3 -';
          time -= 55.0;
        }
        if (time > 80.0 && time <= 105.0) {
          hintText = '- Shift 2 -';
          time -= 80.0;
        }
        if (time > 105.0 && time <= 130.0) {
          hintText = '- Shift 1 -';
          time -= 105.0;
        }
        if (time > 130.0 && time <= 140.0) {
          hintText = '- Transition Shift -';
          time -= 130.0;
        }
        if (autoEnabled) hintText = '- Autonomous -';

        String timeString = '0:00';
        if (time != -1) {
          int mins = (time / 60).floor();
          int secs = (time % 60).floor();

          timeString = '$mins:${secs.toString().padLeft(2, '0')}';
        }

        return Container(
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
        );
      },
    );
  }
}