import 'package:accelerationstation/services/dashboard_state.dart';
import 'package:accelerationstation/services/dashboard_theme.dart';
import 'package:flutter/material.dart';

class HubWidget extends StatelessWidget {
  final DashboardState dashboardState;

  const HubWidget({
    super.key,
    required this.dashboardState
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: dashboardState.hubEnabled(),
      builder: (context, snapshot) {
        final enabled = snapshot.data ?? false;

        final asset = enabled ? 'images/hub_enabled.png' : 'images/hub_disabled.png';
        final text = enabled ? '- ENABLED -' : '- DISABLED -';

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