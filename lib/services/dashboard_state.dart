import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:nt4/nt4.dart';

class DashboardState {
  static const String robotAddress = kDebugMode ? '127.0.0.1' : '10.45.93.2';

  late final NT4Client client;

  bool _isRedAlliance = false;
  bool _isAutoEnabled = false;
  double _matchTime = 0.0;
  String _gsm = '';

  String selectedAuto = 'LeftCenterLeft';

  // Publishers
  late NT4Topic _selectedAutoPub;

  // Subscibers
  late final NT4Subscription _redAllianceSub;
  late final NT4Subscription _autoEnabledSub;
  late final NT4Subscription _matchTimeSub;
  late final NT4Subscription _dsSub;
  late final NT4Subscription _fmsSub;
  late final NT4Subscription _gsmSub;
  late final NT4Subscription _consoleSub;
  late final NT4Subscription _turretAngleSub;

  DashboardState(): client = NT4Client(serverBaseAddress: robotAddress) {
    _selectedAutoPub = client.publishNewTopic('/AccelerationStation/SelectedAuto', NT4TypeStr.typeStr);
  
    _redAllianceSub = client.subscribePeriodic('/FMSInfo/IsRedAlliance', 1.0);
    _autoEnabledSub = client.subscribePeriodic('/AdvantageKit/DriverStation/Autonomous', 0.1);
    _matchTimeSub = client.subscribePeriodic('/AdvantageKit/DriverStation/MatchTime', 0.1);
    _dsSub = client.subscribePeriodic('/AdvantageKit/DriverStation/DSAttached', 1.0);
    _fmsSub = client.subscribePeriodic('/AdvantageKit/DriverStation/FMSAttached', 1.0);
    _gsmSub = client.subscribePeriodic('/FMSInfo/GameSpecificMessage', 1.0);
    _consoleSub = client.subscribePeriodic('/AdvantageKit/RealOutputs/Console', 1.0);
    _turretAngleSub = client.subscribePeriodic('/AdvantageKit/Turret/Angle', 0.1);

    client.setProperties(_selectedAutoPub, false, true);

    _redAllianceSub.stream().listen((value) {
      if (value is bool) _isRedAlliance = value;
    });
    _autoEnabledSub.stream().listen((value) {
      if (value is bool) _isAutoEnabled = value;
    });
    _matchTimeSub.stream().listen((value) {
      if (value is double) _matchTime = value;
    });
    _gsmSub.stream().listen((value) {
      if (value is String) _gsm = value;
    });
    client.connectionStatusStream().listen((connected) {
      if (connected) {
        setSelectedAuto(selectedAuto);
      }
    });
  }

  Stream<bool> connected() =>
      client.connectionStatusStream().asBroadcastStream();

  Stream<double> matchTime() async* {
    await for (final value in _matchTimeSub.stream()) {
      if (value is double) yield value;
    }
  }

  // Takes the GameSpecificMessage and compares it to the current shift to determine if the hub is enabled or not.
  Stream<bool> isHubEnabled() async* {
    await for (final _ in _matchTimeSub.stream()) {

      final gsm = _gsm;
      final int shift = getCurrentShift();
      if (gsm.isEmpty) continue;

      // Endgame, autonomous and transition check.
      if (shift == -1 || shift == 0 || shift == 5) {
        yield true;
        continue;
      }
      
      if (shift == 2 || shift == 4) {
        yield (gsm == 'R') == _isRedAlliance;
      } else {
        yield (gsm == 'B') == _isRedAlliance;
      }
    }
  }

  Stream<bool> isAutoEnabled() async* {
    await for (final value in _autoEnabledSub.stream()) {
      if (value is bool) yield value;
    }
  }

  Stream<bool> isRedAlliance() async* {
    await for (final value in _redAllianceSub.stream()) {
      if (value is bool) yield value;
    }
  }

  Stream<bool> driverStationConnected() async* {
    await for (final value in _dsSub.stream()) {
      if (value is bool) yield value;
    }
  }

  Stream<bool> fmsConnected() async* {
    await for (final value in _fmsSub.stream()) {
      if (value is bool) yield value;
    }
  }

  Stream<String> consoleLog() async* {
    await for (final value in _consoleSub.stream()) {
      if (value is String) yield value;
    }
  }

  Stream<double> turretAngle() async* {
    await for (final value in _turretAngleSub.stream()) {
      if (value is double) yield value;
    }
  }

  void setSelectedAuto(String auto) {
    selectedAuto = auto;
    client.addSample(_selectedAutoPub, auto);
  }

  // Null = -2, auto = -1, transition = 0, shift 1-4 = 1-4, endgame = 5.
  int getCurrentShift() {
    if (_isAutoEnabled && _matchTime > 0.0) return -1;
    if (_matchTime > 130.0 && _matchTime <= 140.0) return 0;
    if (_matchTime > 105.0 && _matchTime <= 130.0) return 1;
    if (_matchTime > 80.0 && _matchTime <= 105.0) return 2;
    if (_matchTime > 55.0 && _matchTime <= 80.0) return 3;
    if (_matchTime > 30.0 && _matchTime <= 55.0) return 4;
    if (_matchTime > 0.0 && _matchTime <= 30.0) return 5;
    return -2;
  }

  double getMatchTime() {
    return _matchTime;
  }

  double getShiftTime() {
    double time = _matchTime;
    switch (getCurrentShift()) {
      case 4: time -= 30.0;
      case 3: time -= 55.0;
      case 2: time -= 80.0;
      case 1: time -= 105.0;
      case 0: time -= 130.0;
    }
    return time;
  }

  int getAllianceRemainingShifts({required bool redAlliance}) {
    final int shift = getCurrentShift();
    final bool gsmRed = _gsm == 'R';
    switch (shift) {
      case 0: return 3;
      case 1: return redAlliance == !gsmRed ? 2 : 3;
      case 2: return redAlliance == !gsmRed ? 2 : 2;
      case 3: return redAlliance == !gsmRed ? 1 : 2;
      case 4: return redAlliance == !gsmRed ? 1 : 1;
      case 5: return 0;
    }
    return 4;
  }
}