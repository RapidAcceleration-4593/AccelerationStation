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
  late final NT4Subscription _matchTimeSub;
  late final NT4Subscription _dsSub;
  late final NT4Subscription _fmsSub;
  late final NT4Subscription _gsmSub;

  // Publishers
  late final NT4Topic _autonStartPub;
  late final NT4Topic _autonScorePub;
  late final NT4Topic _autonFuelPub;
  late final NT4Topic _autonClimbPub;

  DashboardState(): client = NT4Client(serverBaseAddress: robotAddress) {
    _redAllianceSub = client.subscribePeriodic('/FMSInfo/IsRedAlliance', 1.0);
    _matchTimeSub = client.subscribePeriodic('/AdvantageKit/DriverStation/MatchTime', 1.0);
    _dsSub = client.subscribePeriodic('/AdvantageKit/DriverStation/DSAttached', 1.0);
    _fmsSub = client.subscribePeriodic('/AdvantageKit/DriverStation/FMSAttached', 1.0);
    _gsmSub = client.subscribePeriodic('/FMSInfo/GameSpecificMessage', 1.0);

    _autonStartPub = client.publishNewTopic('/AccelerationStation/SelectedAutonomousStartPosition', NT4TypeStr.typeStr);
    _autonScorePub = client.publishNewTopic('/AccelerationStation/SelectedAutonomousScorePosition', NT4TypeStr.typeInt);
    _autonFuelPub = client.publishNewTopic('/AccelerationStation/SelectedAutonomousFuelPickup', NT4TypeStr.typeInt);
    _autonClimbPub = client.publishNewTopic('/AccelerationStation/SelectedAutonomousClimbPosition', NT4TypeStr.typeInt);

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

  Stream<bool> hubEnabled() async* {
    await for (final _ in _matchTimeSub.stream()) {

      final gsm = _gsm;
      if (gsm.isEmpty) continue;

      if (_gameTime <= 30.0 || _gameTime > 130.0) {
        yield false;
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

  // void setAutonomous(String autonName) {
  //   client.addSample(_autonPub, autonName);
  // }

  void setAutoStartPos(String pos) {
    // things
  }

  void setAutoScorePos(String pos) {

  }

  void setAutoFuelPickup(String option) {

  }

  void setAutoClimbPos(String pos) {

  }

  // void setPoseId(int poseId) {
  //   client.addSample(_poseIdPub, poseId);
  // }
}