import 'package:accelerationstation/services/dashboard_state.dart';
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

        final asset = enabled
            ? 'images/hub_enabled.png'
            : 'images/hub_disabled.png';

        return Image.asset(asset);
      },
    );
  }
}