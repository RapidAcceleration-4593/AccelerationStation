import 'package:accelerationstation/services/dashboard_state.dart';
import 'package:accelerationstation/services/dashboard_theme.dart';
import 'package:flutter/material.dart';

class ConsoleTab extends StatefulWidget {
  final DashboardState dashboardState;

  const ConsoleTab({super.key, required this.dashboardState});

  @override
  State<ConsoleTab> createState() => _ConsoleTabState();
}

class _ConsoleTabState extends State<ConsoleTab>
    with AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive => true;

  String console = '';
  String prevConsole = '';

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return StreamBuilder(
      stream: widget.dashboardState.consoleLog(),
      builder: (context, snapshot) {
        String current = '';
        if (snapshot.hasData) {
          current = snapshot.data!;
        }
        if (current != prevConsole) {
          prevConsole = current;
          console += '$current\n';

        } 
        return SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(4.0),
            decoration: BoxDecoration(
              color: DashboardTheme.middlegroundColor
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Text(
                console,
                style: TextStyle(
                  color: DashboardTheme.outlineColor,
                  fontFamily: DashboardTheme.font,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        );
      }
    );
  }
}