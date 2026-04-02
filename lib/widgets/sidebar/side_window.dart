import 'package:accelerationstation/services/dashboard_state.dart';
import 'package:accelerationstation/services/dashboard_theme.dart';
import 'package:accelerationstation/widgets/animated_startup.dart';
import 'package:accelerationstation/widgets/sidebar/connection_tab.dart';
import 'package:accelerationstation/widgets/sidebar/hover_tab.dart';
import 'package:flutter/material.dart';

class ConsoleWidget extends StatefulWidget {
  final DashboardState dashboardState;

  ConsoleWidget({
    super.key,
    required this.dashboardState
  });

  @override
  State<ConsoleWidget> createState() => _ConsoleState();
}

class _ConsoleState extends State<ConsoleWidget> with SingleTickerProviderStateMixin {
  String console = '';
  String prevConsole = '';

  late TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(
      length: 2,
      vsync: this,
      animationDuration: Duration.zero,
    );
    _controller.addListener(() {
      if (_controller.indexIsChanging == false) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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

        return AnimatedStartupWidget(
          delay: Duration(milliseconds: 1600),
          length: Duration(milliseconds: 500),
          curve: Curves.fastEaseInToSlowEaseOut,
          child: Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 0, 0, 0),
              border: Border.all(color: DashboardTheme.outlineColor)
            ),
            margin: EdgeInsets.fromLTRB(0, 468, 0, 20),
            padding: EdgeInsets.all(5),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TabBar(
                  controller: _controller,
                  overlayColor: WidgetStateProperty.resolveWith<Color?>((states) {
                    return Colors.transparent;
                  }),
                  indicatorAnimation: TabIndicatorAnimation.linear,
                  padding: EdgeInsets.only(bottom: 5),
                  tabAlignment: TabAlignment.start,
                  isScrollable: true,
                  labelStyle: TextStyle(
                    color: DashboardTheme.highlightColor,
                    fontFamily: DashboardTheme.font,
                    fontSize: 18,
                    fontWeight: FontWeight(300)
                  ),
                  unselectedLabelStyle: TextStyle(
                    color: DashboardTheme.outlineColor,
                    fontFamily: DashboardTheme.font,
                    fontSize: 18,
                    fontWeight: FontWeight(300)
                  ),
                  indicator: UnderlineTabIndicator(
                    borderSide: BorderSide(color: DashboardTheme.underlineColor)
                  ),
                  dividerColor: Colors.transparent,
                  tabs: [
                    Tab(
                      height: 26,
                      child: HoverTab(text: 'CONNECTION', selected: _controller.index == 0),
                    ),
                    Tab(
                      height: 26,
                      child: HoverTab(text: 'OUTPUT', selected: _controller.index == 1),
                    )
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    controller: _controller,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      ConnectionTab(dashboardState: widget.dashboardState),
                      SingleChildScrollView(
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
                    ],
                  )
                ),
              ],
            )
          )
        );
      },
    );
  }
}