import 'package:accelerationstation/services/dashboard_theme.dart';
import 'package:accelerationstation/services/dashboard_state.dart';
import 'package:accelerationstation/widgets/animated_startup.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class ShotCount extends StatelessWidget {
  final DashboardState dashboardState;

  const ShotCount({
    super.key,
    required this.dashboardState,
  });


  @override
  Widget build(BuildContext context) {
    final combinedStream = Rx.combineLatest2<int, int, Map<String, dynamic>>(
      dashboardState.fuelShotHub(),
      dashboardState.fuelShotFeeding(),
      (fuelShotHub, fuelShotFeeding) => {
        'fuelShotHub' : fuelShotHub,
        'fuelShotFeeding' : fuelShotFeeding
      }
    );

    return StreamBuilder(
      stream: combinedStream,
      builder: (context, snapshot) {
        String hubCountString = '00';
        String feedingCountString = '00';

        final int fuelShotHub = snapshot.hasData ? snapshot.data!['fuelShotHub'] as int : 0;
        final int fuelShotFeeding = snapshot.hasData ? snapshot.data!['fuelShotFeeding'] as int : 0;
        hubCountString = fuelShotHub.toString().padLeft(2, '0');
        feedingCountString = fuelShotFeeding.toString().padLeft(2, '0');

        return Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.bottomCenter,
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: Transform.translate(
                offset: Offset(
                  300, 
                  0,
                ),
                child: AnimatedStartupWidget(
                  delay: Duration(milliseconds: 2900),
                  length: Duration(milliseconds: 200),
                  curve: Curves.easeOutBack,
                  child: Container(
                    height: 115,
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(color: DashboardTheme.outlineColor)
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '- Hub Shots -',
                          style: const TextStyle(
                            fontFamily: DashboardTheme.font,
                            fontSize: 12,
                            color: Colors.grey
                          ),
                        ),
                        Text(
                          hubCountString,
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
                )
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Transform.translate(
                offset: Offset(
                  -300, 
                  0,
                ),
                child: AnimatedStartupWidget(
                  delay: Duration(milliseconds: 2700),
                  length: Duration(milliseconds: 200),
                  curve: Curves.easeOutBack,
                  child: Container(
                    height: 115,
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(color: DashboardTheme.outlineColor)
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '- Feed Shots -',
                          style: const TextStyle(
                            fontFamily: DashboardTheme.font,
                            fontSize: 12,
                            color: Colors.grey
                          ),
                        ),
                        Text(
                          feedingCountString,
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
                )
              ),
            ),
          ],
        );
      },
    );
  }
}