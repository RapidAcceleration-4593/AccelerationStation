import 'package:accelerationstation/services/dashboard_state.dart';
import 'package:accelerationstation/services/dashboard_theme.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class HubWidget extends StatelessWidget {
  final DashboardState dashboardState;

  const HubWidget({
    super.key,
    required this.dashboardState
  });

  @override
  Widget build(BuildContext context) {
    final combinedStream = Rx.combineLatest2<bool, double, Map<String, dynamic>>(
      dashboardState.isHubEnabled(),
      dashboardState.matchTime(),
      (hubEnabled, matchTime) => {
        'hubEnabled' : hubEnabled,
        'matchTime' : matchTime
      }
    );

    return StreamBuilder<Map<String, dynamic>>(
      stream: combinedStream,
      builder: (context, snapshot) {
        final bool enabled = snapshot.hasData ? snapshot.data!['hubEnabled'] as bool : false;
        final double shiftTime = dashboardState.getShiftTime();
        final double matchTime = dashboardState.getMatchTime();


        final asset = shiftTime < 5.0 && shiftTime > 0.0 && ((shiftTime * 2).floor() % 2 == 0) && enabled ? 'images/hub_warning.png' : (enabled && matchTime >= 0.0 ? 'images/hub_enabled.png' : 'images/hub_disabled.png');
        final text = enabled && matchTime >= 0.0 ? '- ENABLED -' : '- DISABLED -';

        return Stack(
          alignment: Alignment.center,
          children: [
            Image.asset(
              asset,
            ),
            Container(
              padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
              decoration: BoxDecoration(
                color: const Color.fromARGB(0, 0, 0, 0),
                borderRadius: BorderRadius.circular(10)
              ),
              child: FittedBox(
                fit: BoxFit.fitHeight,
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: DashboardTheme.font,
                    fontSize: 30,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
            )
          ]
        );
      },
    );
  }
}