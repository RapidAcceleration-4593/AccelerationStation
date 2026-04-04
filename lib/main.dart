import 'package:accelerationstation/services/dashboard_theme.dart';

import 'pages/dashboard.dart';
import 'services/dashboard_state.dart';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _initWindow();
  await DashboardTheme.init();

  runApp(const DashboardApp());
}

Future<void> _initWindow() async {
  await windowManager.ensureInitialized();

  const options = WindowOptions(
    size: Size(1600, 900),
    minimumSize: Size(1280, 720),
    center: true,
    title: 'Acceleration Station 2026',
  );

  windowManager.waitUntilReadyToShow(options, () async {
    await windowManager.show();
    await windowManager.focus();
  });
}

class DashboardApp extends StatelessWidget {
  const DashboardApp({super.key});

  static final DashboardState _dashboardState = DashboardState();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: DashboardTheme.themeNotifier,
      builder: (context, value, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.dark,
            colorSchemeSeed: Colors.indigo,
            scaffoldBackgroundColor: DashboardTheme.backgroundColor,
          ),
          home: Dashboard(dashboardState: _dashboardState)
        );
      },
    );
  }
}