import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nt4/nt4.dart';

class DashboardState {
  static const String robotAddress = kDebugMode ? '127.0.0.1' : '10.45.93.2';

  final NT4Client client;

  bool _isRedAlliance = false;
  double _gameTime = 0.0;
  String _gsm = '';

  // Subscibers
  late final NT4Subscription _redAllianceSub;
  late final NT4Subscription _autoEnabledSub;
  late final NT4Subscription _matchTimeSub;
  late final NT4Subscription _dsSub;
  late final NT4Subscription _fmsSub;
  late final NT4Subscription _gsmSub;
  late final NT4Subscription _consoleSub;

  // Publishers
  late final NT4Topic _autonStartPub;
  late final NT4Topic _autonScorePub;
  late final NT4Topic _autonFuelPub;
  late final NT4Topic _autonClimbPub;

  DashboardState(): client = NT4Client(serverBaseAddress: robotAddress) {
    _redAllianceSub = client.subscribePeriodic('/FMSInfo/IsRedAlliance', 1.0);
    _autoEnabledSub = client.subscribePeriodic('/AdvantageKit/DriverStation/Autonomous', 1.0);
    _matchTimeSub = client.subscribePeriodic('/AdvantageKit/DriverStation/MatchTime', 1.0);
    _dsSub = client.subscribePeriodic('/AdvantageKit/DriverStation/DSAttached', 1.0);
    _fmsSub = client.subscribePeriodic('/AdvantageKit/DriverStation/FMSAttached', 1.0);
    _gsmSub = client.subscribePeriodic('/FMSInfo/GameSpecificMessage', 1.0);
    _consoleSub = client.subscribePeriodic('/AdvantageKit/RealOutputs/Console', 0.5);

    _autonStartPub = client.publishNewTopic('/AccelerationStation/SelectedAutonomousStartPosition', NT4TypeStr.typeStr);
    _autonScorePub = client.publishNewTopic('/AccelerationStation/SelectedAutonomousScorePosition', NT4TypeStr.typeStr);
    _autonFuelPub = client.publishNewTopic('/AccelerationStation/SelectedAutonomousFuelPickup', NT4TypeStr.typeStr);
    _autonClimbPub = client.publishNewTopic('/AccelerationStation/SelectedAutonomousClimbPosition', NT4TypeStr.typeStr);

    client.setProperties(_autonStartPub, false, true);
    client.setProperties(_autonScorePub, false, true);
    client.setProperties(_autonFuelPub, false, true);
    client.setProperties(_autonClimbPub, false, true);

    _redAllianceSub.stream().listen((value) {
      if (value is bool) _isRedAlliance = value;
    });
    _matchTimeSub.stream().listen((value) {
      if (value is double) _gameTime = value;
    });
    _gsmSub.stream().listen((value) {
      if (value is String) _gsm = value;
    });
  }

  Stream<bool> connected() =>
      client.connectionStatusStream().asBroadcastStream();

  Stream<double> matchTime() async* {
    await for (final value in _matchTimeSub.stream()) {
      if (value is double) yield value;
    }
  }

  Stream<bool> isHubEnabled() async* {
    await for (final _ in _matchTimeSub.stream()) {

      final gsm = _gsm;
      if (gsm.isEmpty) continue;

      if (_gameTime <= 30.0 || _gameTime > 130.0) {
        yield true;
        continue;
      }

      if ((_gameTime > 30.0 && _gameTime <= 55.0) || (_gameTime > 80.0 && _gameTime <= 105.0)) {
        switch (gsm) {
          case 'B':
            yield !_isRedAlliance;
            break;
          case 'R':
            yield _isRedAlliance;
            break;
        }
        continue;
      }
      switch (gsm) {
        case 'B':
          yield _isRedAlliance;
          break;
        case 'R':
          yield !_isRedAlliance;
          break;
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

  void setAutoStartPos(String pos) {
    client.addSample(_autonStartPub, pos);
  }

  void setAutoScorePos(String pos) {
    client.addSample(_autonScorePub, pos);
  }

  void setAutoFuelPickup(String option) {
    client.addSample(_autonFuelPub, option);
  }

  void setAutoClimbPos(String pos) {
    client.addSample(_autonClimbPub, pos);
  }
}