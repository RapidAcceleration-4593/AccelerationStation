import 'package:accelerationstation/services/dashboard_state.dart';
import 'package:accelerationstation/services/dashboard_theme.dart';
import 'package:flutter/material.dart';

class ConnectionTab extends StatefulWidget {
  final DashboardState dashboardState;

  const ConnectionTab({super.key, required this.dashboardState});

  @override
  State<ConnectionTab> createState() => _ConnectionTabState();
}

class _ConnectionTabState extends State<ConnectionTab>
    with AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _statusText(
          label: 'FMS',
          stream: widget.dashboardState.fmsConnected(),
        ),
        _statusText(
          label: 'Driver Station',
          stream: widget.dashboardState.driverStationConnected(),
        ),
        _statusText(
          label: 'NetworkTables',
          stream: widget.dashboardState.connected(),
        ),
      ],
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