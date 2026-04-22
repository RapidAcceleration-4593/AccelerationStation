import 'package:accelerationstation/services/dashboard_state.dart';
import 'package:accelerationstation/services/dashboard_theme.dart';
import 'package:flutter/material.dart';

class VisionTab extends StatefulWidget {
  final DashboardState dashboardState;

  const VisionTab({super.key, required this.dashboardState});

  @override
  State<VisionTab> createState() => _VisionTabState();
}

class _VisionTabState extends State<VisionTab>
    with AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive => true;

  bool questEnabled = true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,

        children: [
          Text(
            'Quest Enabled?',
            style: TextStyle(
              color: DashboardTheme.outlineColor,
              fontFamily: DashboardTheme.font,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 4.0),
          SizedBox(
            width: double.infinity,
            child: SegmentedButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(DashboardTheme.middlegroundColor),
                foregroundColor: WidgetStateProperty.all(DashboardTheme.highlightColor),
                side: WidgetStatePropertyAll(BorderSide(color: DashboardTheme.outlineColor))
              ),
              segments: [
                ButtonSegment(
                  value: 0,
                  label: Padding(
                    padding: EdgeInsetsGeometry.all(10.0),
                    child: Text(
                      'Enabled',
                      style: TextStyle(
                        fontFamily: DashboardTheme.font,
                        fontSize: 24
                      ),
                    ),
                  )
                ),
                ButtonSegment(
                  value: 1,
                  label: Padding(
                    padding: EdgeInsetsGeometry.all(10.0),
                    child: Text(
                      'Disabled',
                      style: TextStyle(
                        fontFamily: DashboardTheme.font,
                        fontSize: 24
                      ),
                    ),
                  )
                )
              ],
              selected: {questEnabled ? 0 : 1},
              onSelectionChanged: (newSelection) {
                final index = newSelection.first;
                setState(() {
                  questEnabled = index == 0;
                  widget.dashboardState.setQuestEnabled(index == 0);
                });
              },
            ),
          ),
          SizedBox(height: 8.0),
          Divider(
            color: DashboardTheme.outlineColor,
            height: 0,
          ),
          SizedBox(height: 8.0),
          Text(
            'Quest Status',
            style: TextStyle(
              color: DashboardTheme.outlineColor,
              fontFamily: DashboardTheme.font,
              fontSize: 16,
            ),
          ),
          StreamBuilder(
            stream: widget.dashboardState.oculusBattery(),
            builder: (context, snapshot) {
              final double percentage = snapshot.data ?? 0.0;
              return Text(
                'Battery Percent: $percentage%',
                style: TextStyle(
                  color: percentage <= 10 ? Colors.red : (percentage <= 50 ? Colors.yellow : Colors.green),
                  fontFamily: DashboardTheme.font,
                  fontSize: 16,
                ),
              );
            },
          ),
          _statusText(
            label: 'Quest',
            stream: widget.dashboardState.oculusConnection()
          ),
          _statusText(
            label: 'Tracking',
            stream: widget.dashboardState.oculusTracking()
          )
        ],
      ),
    );
  }

  Widget _statusText({
    required String label,
    required Stream<bool> stream,
  }) {
    return StreamBuilder<bool>(
      stream: stream,
      initialData: false,
      builder: (context, snapshot) {
        final connected = snapshot.data ?? false;
        return Text(
          '$label: ${connected ? "Connected" : "Disconnected"}',
          style: TextStyle(
            color: connected ? Colors.green : Colors.red,
            fontFamily: DashboardTheme.font,
            fontSize: 16
          ),
        );
      },
    );
  }
}