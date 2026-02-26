import 'package:accelerationstation/services/dashboard_state.dart';
import 'package:accelerationstation/services/dashboard_theme.dart';
import 'package:flutter/material.dart';

class ConsoleWidget extends StatelessWidget {
  final DashboardState dashboardState;

  const ConsoleWidget({
    super.key,
    required this.dashboardState
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: dashboardState.consoleLog(),
      builder: (context, snapshot) {
        String console = '';
        if (snapshot.hasData) {
          console = snapshot.data!;
        }

        return Container(
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 29, 27, 36),
          ),
          margin: EdgeInsets.fromLTRB(10, 390, 10, 20),
          padding: EdgeInsets.all(5),
          height: double.infinity,
          width: double.infinity,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Text(
              console,
              style: TextStyle(
                color: const Color.fromARGB(255, 0, 255, 21),
                fontFamily: DashboardTheme.font,
                fontSize: 18,
                shadows: [
                  Shadow(
                    color: const Color.fromARGB(255, 0, 255, 21),
                    blurRadius: 5
                  )
                ]
              ),
            ),
          )
        );
      },
    );
  }
}