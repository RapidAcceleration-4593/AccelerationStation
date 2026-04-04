import 'package:accelerationstation/services/dashboard_state.dart';
import 'package:accelerationstation/services/dashboard_theme.dart';
import 'package:accelerationstation/widgets/sidebar/autonomous_selector.dart';
import 'package:accelerationstation/widgets/sidebar/side_window.dart';
import 'package:accelerationstation/widgets/hub_widget.dart';
import 'package:accelerationstation/widgets/match_timer.dart';
import 'package:accelerationstation/widgets/footer_widgets.dart';
import 'package:accelerationstation/widgets/shift_timer.dart';
import 'package:accelerationstation/widgets/shot_count.dart';
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
      body: Stack(
        children: [
          Row(
            children: [
              Expanded(
                flex: 4,
                child: Container(
                  decoration: BoxDecoration(
                    border: BoxBorder.fromLTRB(right: BorderSide(color: DashboardTheme.outlineColor, width: 1.0)),
                    color: DashboardTheme.middlegroundColor,
                  ),
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
                            )
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topCenter,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 488, 20, 40),
                          child: FractionallySizedBox(
                            widthFactor: 1.0,
                            child: SideWindow(
                              dashboardState: dashboardState,
                            )
                          ),
                        ),
                      ),
                      FooterLeft(),
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
                      child: HubWidget(dashboardState: dashboardState)
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
                      )
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: ShotCount(dashboardState: dashboardState),
                      ),
                    )
                  ]
                )
              ),
            ],
          ),
        ],
      )
    );
  }
}