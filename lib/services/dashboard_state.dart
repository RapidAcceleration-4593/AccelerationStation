import 'dart:async';
import 'package:nt4/nt4.dart';
import 'package:rxdart/rxdart.dart';

class DashboardState {
  static const String robotAddress = '10.45.93.2';
  late final NT4Client client;

  bool _isRedAlliance = false;
  bool _isAutoEnabled = false;
  double _matchTime = -1.0;
  String _gsm = '';

  // Default selected autonomous routine
  String selectedAuto = 'DoNothing';
  String selectedVisionSystem = 'Oculus';

  // Publishers
  late final NT4Topic _selectedAutoPub;
  late final NT4Topic _selectedVisionSystemPub;

  // Subscibers
  late final NT4Subscription _redAllianceSub;
  late final NT4Subscription _autoEnabledSub;
  late final NT4Subscription _matchTimeSub;
  late final NT4Subscription _dsSub;
  late final NT4Subscription _fmsSub;
  late final NT4Subscription _gsmSub;
  late final NT4Subscription _consoleSub;
  late final NT4Subscription _fuelShotHubSub;
  late final NT4Subscription _fuelShotFeedingSub;
  late final NT4Subscription _oculusBatterySub;
  late final NT4Subscription _oculusConnectionSub;
  late final NT4Subscription _oculusTrackingSub;

  DashboardState(): client = NT4Client(serverBaseAddress: robotAddress) {
    _initializeTopicsAndSubscriptions();
    _initializeListeners();

    connected().listen((connected) {
      if (connected) {
        setSelectedAuto(selectedAuto);
        setSelectedVisionSystem(selectedVisionSystem);
      }
    });
  }

  void _initializeTopicsAndSubscriptions() {
    _selectedAutoPub = client.publishNewTopic('/AccelerationStation/SelectedAuto', NT4TypeStr.typeStr);
    _selectedVisionSystemPub = client.publishNewTopic('/AccelerationStation/SelectedVisionSystem', NT4TypeStr.typeStr);
  
    _redAllianceSub = client.subscribePeriodic('/FMSInfo/IsRedAlliance', 1.0);
    _autoEnabledSub = client.subscribePeriodic('/AdvantageKit/DriverStation/Autonomous', 0.1);
    _matchTimeSub = client.subscribePeriodic('/AdvantageKit/DriverStation/MatchTime', 0.05);
    _dsSub = client.subscribePeriodic('/AdvantageKit/DriverStation/DSAttached', 1.0);
    _fmsSub = client.subscribePeriodic('/AdvantageKit/DriverStation/FMSAttached', 1.0);
    _gsmSub = client.subscribePeriodic('/FMSInfo/GameSpecificMessage', 1.0);
    _consoleSub = client.subscribePeriodic('/AdvantageKit/RealOutputs/Console', 0.5);
    _fuelShotHubSub = client.subscribePeriodic('/AdvantageKit/RealOutputs/IndexerSubsystem/FuelShotHub', 0.1);
    _fuelShotFeedingSub = client.subscribePeriodic('/AdvantageKit/RealOutputs/IndexerSubsystem/FuelShotFeeding', 0.1);
    _oculusBatterySub = client.subscribePeriodic('/AdvantageKit/QuestNav/BatteryPercent', 1.0);
    _oculusConnectionSub = client.subscribePeriodic('/AdvantageKit/QuestNav/Connected', 1.0);
    _oculusTrackingSub = client.subscribePeriodic('/AdvantageKit/QuestNav/Tracking', 1.0);

    client.setProperties(_selectedAutoPub, false, true);
    client.setProperties(_selectedVisionSystemPub, false, true);
  }

  void _initializeListeners() {
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
  }

  void reconnect(String newAddress) {
    client.setServerBaseAddress(newAddress);
  }

  void setSelectedAuto(String auto) {
    selectedAuto = auto;
    client.addSample(_selectedAutoPub, auto);
  }

  void setSelectedVisionSystem(String visionSystem) {
    selectedVisionSystem = visionSystem;
    client.addSample(_selectedVisionSystemPub, visionSystem);
  }

  Stream<T> _typedStream<T>(NT4Subscription sub) {
    return sub
        .stream()
        .where((value) => value is T)
        .cast<T>()
        .asBroadcastStream();
  }

  Stream<int> fuelShotHub() => _typedStream<int>(_fuelShotHubSub);
  Stream<int> fuelShotFeeding() => _typedStream<int>(_fuelShotFeedingSub);
  Stream<double> matchTime() => _typedStream<double>(_matchTimeSub);
  Stream<bool> isRedAlliance() => _typedStream<bool>(_redAllianceSub);
  Stream<bool> isAutoEnabled() => _typedStream<bool>(_autoEnabledSub);
  Stream<String> consoleLog() => _typedStream<String>(_consoleSub);
  Stream<double> oculusBattery() => _typedStream<double>(_oculusBatterySub);
  Stream<bool> oculusConnection() => _typedStream<bool>(_oculusConnectionSub);
  Stream<bool> oculusTracking() => _typedStream<bool>(_oculusTrackingSub);

  Stream<bool> fmsConnected() => _typedStream<bool>(_fmsSub);
  Stream<bool> driverStationConnected() => _typedStream<bool>(_dsSub);
  late final Stream<bool> _connectionStream =
    client.connectionStatusStream().asBroadcastStream();

  Stream<bool> connected() => _connectionStream;

  Stream<bool> isHubEnabled() {
    return Rx.combineLatest2<dynamic, String, bool>(
      _matchTimeSub.stream(),
      _gsmSub.stream().whereType<String>().startWith(_gsm),
      (_, gsm) {
        final int shift = getCurrentShift();

        if (shift == -1 || shift == 0 || shift == 5) {
          return true;
        }

        if (_gsm.isEmpty) {
          final bool redOwnsShift = shift % 2 == 1;
          return redOwnsShift == _isRedAlliance;
        }

        final bool shift1Red = gsm == 'R';
        final bool redOwnsShift =
            (shift % 2 == 0) ? shift1Red : !shift1Red;

        return redOwnsShift == _isRedAlliance;
      },
    );
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

  double getShiftTime() {
    final int shift = getCurrentShift();
    switch (shift) {
      case 4: return _matchTime - 30.0;
      case 3: return _matchTime - 55.0;
      case 2: return _matchTime - 80.0;
      case 1: return _matchTime - 105.0;
      case 0: return _matchTime - 130.0;
      default: return _matchTime;
    }
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
      default: return 4;
    }
  }
}