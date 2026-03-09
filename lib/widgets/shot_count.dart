import 'package:accelerationstation/services/dashboard_theme.dart';
import 'package:accelerationstation/services/dashboard_state.dart';
import 'package:flutter/material.dart';

class ShotCount extends StatelessWidget {
  final DashboardState dashboardState;

  const ShotCount({
    super.key,
    required this.dashboardState,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: dashboardState.shotCount(),
      builder: (context, snapshot) {
        String countString = '00';

        if (snapshot.hasData && snapshot.data != -1) {
          countString = snapshot.data.toString().padLeft(2, '0');
        }

        return Container(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          decoration: BoxDecoration(
            color: const Color.fromARGB(132, 0, 0, 0),
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: FittedBox(
            fit: BoxFit.fitHeight,
            alignment: Alignment.centerRight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '- Shot Count -',
                  style: const TextStyle(
                    fontFamily: DashboardTheme.font,
                    fontSize: 12,
                    color: Colors.grey
                  ),
                ),
                Text(
                  countString,
                  style: const TextStyle(
                    fontFamily: DashboardTheme.font,
                    fontSize: 80,
                    height: 1.0,
                    shadows: [
                      Shadow(
                        blurRadius: 20.0,
                        color: Color.fromARGB(100, 0, 140, 200),
                      )
                    ]
                  ),
                )
              ]
            ),
          ),
        );
      },
    );
  }
}