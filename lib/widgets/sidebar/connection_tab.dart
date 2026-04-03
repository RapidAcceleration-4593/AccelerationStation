import 'dart:async';

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

  int connectionModeIndex = 0;
  final TextEditingController addressController = TextEditingController(text: '10.45.93.2');
  String sentAddress = '10.45.93.2';
  String dotString = '';
  int dotCount = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      setState(() {
        dotString = '.' * dotCount;
        dotCount = (dotCount + 1) % 4;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ToggleButtons(
            borderColor: DashboardTheme.outlineColor,
            fillColor: DashboardTheme.backgroundColor,
            selectedBorderColor: DashboardTheme.outlineColor,
            constraints: BoxConstraints.tight(Size(100, 30)),
            selectedColor: DashboardTheme.highlightColor,
            disabledColor: DashboardTheme.outlineColor,
            color: DashboardTheme.outlineColor,
            splashColor: Colors.transparent,
            isSelected: List.generate(3, (index) => index == connectionModeIndex),
            onPressed: (index) {
              setState(() {
                connectionModeIndex = index;
                addressController.text = connectionModeIndex == 0 ? '10.45.93.2' : (connectionModeIndex == 1 ? '127.0.0.1' : '');
              });
            },
            children: [
              Text(
                'Real',
                style: TextStyle(
                  fontFamily: DashboardTheme.font
                ),
              ),
              Text(
                'Simulation',
                style: TextStyle(
                  fontFamily: DashboardTheme.font
                ),
              ),
              Text(
                'Manual',
                style: TextStyle(
                  fontFamily: DashboardTheme.font
                ),
              ),
            ],
          ),
          SizedBox(height: 5.0),
          Row(
            spacing: 5.0,
            children: [
              SizedBox(
                width: 220,
                child: TextField(
                  controller: addressController,
                  enabled: connectionModeIndex == 2,
                  style: TextStyle(
                    fontFamily: DashboardTheme.font,
                    fontSize: 14,
                    color: DashboardTheme.highlightColor
                  ),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(0.0), borderSide: BorderSide(color: DashboardTheme.outlineColor, width: 1.0)),
                    disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(0.0), borderSide: BorderSide(color: DashboardTheme.backgroundColor, width: 1.0)),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(0.0), borderSide: BorderSide(color: DashboardTheme.highlightColor, width: 1.0)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(0.0), borderSide: BorderSide(color: DashboardTheme.outlineColor, width: 1.0)),
                    prefixText: 'IP Address: ',
                    prefixStyle: TextStyle(
                      fontFamily: DashboardTheme.font,
                      fontSize: 14,
                      color: DashboardTheme.outlineColor
                    ),
                    isCollapsed: true,
                    contentPadding: EdgeInsets.all(8.0)
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    sentAddress = addressController.text;
                    widget.dashboardState.reconnect(sentAddress);
                  });
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(0.0, 37.0),
                  padding: EdgeInsets.fromLTRB(9.5, 0.0, 9.5, 0.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                    side: BorderSide(color: DashboardTheme.outlineColor)
                  ),
                  backgroundColor: Colors.black,
                ),
                child: Text(
                  'Connect',
                  style: TextStyle(
                    fontFamily: DashboardTheme.font,
                    fontSize: 14,
                    color: DashboardTheme.outlineColor
                  ),
                ),
              )
            ],
          ),
          StreamBuilder(
            stream: widget.dashboardState.connected(),
            builder: (context, snapshot) {
              final bool connected = snapshot.data ?? false;

              return Text(
                'Current IP: $sentAddress${connected ? '' : ' - connecting$dotString'}',
                style: TextStyle(
                  fontFamily: DashboardTheme.font,
                  fontSize: 14,
                  color: DashboardTheme.outlineColor
                ),
              );
            },
          ),
          SizedBox(height: 8.0),
          Divider(
            color: DashboardTheme.outlineColor,
            height: 0,
          ),
          SizedBox(height: 8.0),

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
      )
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