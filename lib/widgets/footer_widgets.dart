import 'package:accelerationstation/services/dashboard_state.dart';
import 'package:accelerationstation/services/dashboard_theme.dart';
import 'package:flutter/material.dart';

class FooterLeft extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Positioned(
      left: 8,
      bottom: 8,
      child: Text(
        'Created by Lincoln Tupper, Tyler Mueller, and Matthew Flanegan',
        style: DashboardTheme.footerText,
      ),
    );
  }
}

class FooterRight extends StatelessWidget {
  final DashboardState dashboardState;

  const FooterRight(this.dashboardState);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 8,
      bottom: 8,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          _statusText(
            label: 'FMS',
            stream: dashboardState.fmsConnected(),
          ),
          const SizedBox(width: 16),
          _statusText(
            label: 'Driver Station',
            stream: dashboardState.driverStationConnected(),
          ),
          const SizedBox(width: 16),
          _statusText(
            label: 'NetworkTables',
            stream: dashboardState.connected(),
          ),
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
          style: DashboardTheme.footerText.copyWith(
            color: connected ? Colors.green : Colors.red,
          ),
        );
      },
    );
  }
}
