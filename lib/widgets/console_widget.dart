import 'package:accelerationstation/services/dashboard_state.dart';
import 'package:accelerationstation/services/dashboard_theme.dart';
import 'package:flutter/material.dart';

class ConsoleWidget extends StatelessWidget {
  final DashboardState dashboardState;
  String console = '';

  ConsoleWidget({
    super.key,
    required this.dashboardState
  });

  @override
  Widget build(BuildContext context) {
    String prevConsole = '';
    return StreamBuilder(
      stream: dashboardState.consoleLog(),
      builder: (context, snapshot) {
        String current = '';
        if (snapshot.hasData) {
          current = snapshot.data!;
        }
        if (current != prevConsole) {
          prevConsole = current;
          console += '$current\n';
        }

        return Container(
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 15, 17, 20),
          ),
          margin: EdgeInsets.fromLTRB(0, 470, 0, 20),
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
                    color: const Color.fromARGB(120, 0, 255, 21),
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