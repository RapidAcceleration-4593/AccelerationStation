import 'package:accelerationstation/services/dashboard_state.dart';
import 'package:accelerationstation/widgets/autonomous_selector.dart';
import 'package:accelerationstation/widgets/console_widget.dart';
import 'package:accelerationstation/widgets/hub_widget.dart';
import 'package:accelerationstation/widgets/match_timer.dart';
import 'package:accelerationstation/widgets/footer_widgets.dart';
import 'package:accelerationstation/widgets/shift_timer.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatelessWidget {
  final DashboardState dashboardState;

  const Dashboard({
    super.key,
    required this.dashboardState
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<bool>(
        stream: dashboardState.isRedAlliance(),
        initialData: false,
        builder: (context, snapshot) {
          final isRed = snapshot.data ?? false;

          return Stack(
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: Container(
                      color: Colors.black,
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.topCenter,
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: FractionallySizedBox(
                                widthFactor: 1.0,
                                child: AutonomousSelector(
                                  dashboardState: dashboardState,
                                  redAlliance: isRed
                                )
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topCenter,
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: FractionallySizedBox(
                                widthFactor: 1.0,
                                child: ConsoleWidget(
                                  dashboardState: dashboardState,
                                )
                              ),
                            ),
                          ),
                        ]
                      )
                    )
                  ),
                  Expanded(
                    flex: 8,
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 38),
                            child: HubWidget(dashboardState: dashboardState)
                          )
                        ),
                        Align(
                          alignment: Alignment.topCenter,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: ShiftTimer(dashboardState: dashboardState),
                          )
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: MatchTimer(dashboardState: dashboardState),
                          ),
                        ),
                      ]
                    )
                  ),
                ],
              ),
              FooterLeft(),
              FooterRight(dashboardState),
            ],
          );
        },
      ),
    );
  }
}