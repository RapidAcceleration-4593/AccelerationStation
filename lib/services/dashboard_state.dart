import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:nt4/nt4.dart';

class DashboardState {
  static const String robotAddress = kDebugMode ? '127.0.0.1' : '10.45.93.2';

  final NT4Client client;

  late final NT4Subscription _redAllianceSub;
  late final NT4Subscription _matchTimeSub;
  late final NT4Subscription _dsSub;
  late final NT4Subscription _fmsSub;

  late final NT4Topic _autonPub;
  late final NT4Topic _poseIdPub;

  DashboardState(): client = NT4Client(serverBaseAddress: robotAddress) {
    _redAllianceSub = client.subscribePeriodic('/FMSInfo/IsRedAlliance', 1.0);
    _matchTimeSub = client.subscribePeriodic('/AdvantageKit/DriverStation/MatchTime', 1.0);
    _dsSub = client.subscribePeriodic('/AdvantageKit/DriverStation/DSAttached', 1.0);
    _fmsSub = client.subscribePeriodic('/AdvantageKit/DriverStation/FMSAttached', 1.0);

    _autonPub = client.publishNewTopic('/AccelerationStation/SelectedAutonomous', NT4TypeStr.typeStr);
    _poseIdPub = client.publishNewTopic('/AccelerationStation/SelectedPoseId', NT4TypeStr.typeInt);

    client.setProperties(_autonPub, false, true);
    client.setProperties(_poseIdPub, false, true);
  }

  Stream<bool> connected() =>
      client.connectionStatusStream().asBroadcastStream();

  Stream<double> matchTime() async* {
    await for (final value in _matchTimeSub.stream()) {
      if (value is double) yield value;
    }
  }

  Stream<bool> hubEnabled() async* {
    yield true;
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