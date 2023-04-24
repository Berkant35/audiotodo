import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
// ignore: implementation_imports
import 'package:flutter_reactive_ble/src/discovered_devices_registry.dart'
    show DiscoveredDevicesRegistryImpl;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_socket_channel/io.dart';

import 'catchpad_flutter_lib_init.dart';
import 'enums/sensors/config/used_sensor_type.dart';
import 'models/ble_manager.dart';
import 'models/pad_state.dart';
import 'models/sensors/acc_gravity_model.dart';
import 'models/sensors/acc_tap_model.dart';
import 'models/sensors/dst_model.dart';
import 'provs/enviroment_prov.dart';
import 'utils/consts.dart';
import 'utils/pad_consts.dart';

abstract class _FlutterReactiveBleExtender implements FlutterReactiveBle {
  // so wtf is going on here? you ask..
  // Initially I wanted to extend the `FlutterReactiveBle` class,
  // where all the stars would align and everything would go
  // alright in the Ble land.
  //
  // However, `FlutterReactiveBle` does not have a constructor,
  // it has a factory constructor with its class name. so that
  // blocks our extending with a very weird error msg.
  // https://github.com/dart-lang/sdk/issues/25874#issuecomment-536127527
  // https://www.youtube.com/watch?t=840&v=qrFTt1NZed8&feature=youtu.be
  //
  // the solution to this, is to implement the `FlutterReactiveBle`. but
  // this solution required a lot of boilerplate code, as we're required
  // to override EVERY SINGLE METHOD. it's mostly alright, we just have
  // to be up to date regularly with the latest changes.
  //
  // I just created a `FlutterReactiveBle`
  // instance, as they all map to the same instance at the end. and for
  // every method I dont wanna change, I just returned the value from
  // the `FlutterReactiveBle` instance.
  // Foo bar() => _flutterReactiveBle.bar();

  final _ble = FlutterReactiveBle();
  _FlutterReactiveBleExtender();

  @override
  Stream<CharacteristicValue> get characteristicValueStream =>
      _ble.characteristicValueStream;

  @override
  Future<void> clearGattCache(String deviceId) => _ble.clearGattCache(deviceId);

  @override
  Stream<ConnectionStateUpdate> connectToAdvertisingDevice({
    required String id,
    required List<Uuid> withServices,
    required Duration prescanDuration,
    Map<Uuid, List<Uuid>>? servicesWithCharacteristicsToDiscover,
    Duration? connectionTimeout,
  }) =>
      _ble.connectToAdvertisingDevice(
        id: id,
        withServices: withServices,
        prescanDuration: prescanDuration,
        servicesWithCharacteristicsToDiscover:
            servicesWithCharacteristicsToDiscover,
        connectionTimeout: connectionTimeout,
      );

  @override
  Stream<ConnectionStateUpdate> connectToDevice({
    required String id,
    Map<Uuid, List<Uuid>>? servicesWithCharacteristicsToDiscover,
    Duration? connectionTimeout,
  }) =>
      _ble.connectToDevice(
        id: id,
        servicesWithCharacteristicsToDiscover:
            servicesWithCharacteristicsToDiscover,
        connectionTimeout: connectionTimeout,
      );

  @override
  Stream<ConnectionStateUpdate> get connectedDeviceStream =>
      _ble.connectedDeviceStream;

  @override
  Future<void> deinitialize() => _ble.deinitialize();

  @override
  Future<List<DiscoveredService>> discoverServices(String deviceId) =>
      _ble.discoverServices(deviceId);

  @override
  Future<void> initialize() => _ble.initialize();

  @override
  set logLevel(LogLevel logLevel) => _ble.logLevel = logLevel;

  @override
  Future<List<int>> readCharacteristic(
    QualifiedCharacteristic characteristic,
  ) =>
      _ble.readCharacteristic(characteristic);

  @override
  Future<void> requestConnectionPriority({
    required String deviceId,
    required ConnectionPriority priority,
  }) =>
      _ble.requestConnectionPriority(
        deviceId: deviceId,
        priority: priority,
      );

  @override
  Future<int> requestMtu({
    required String deviceId,
    required int mtu,
  }) =>
      _ble.requestMtu(deviceId: deviceId, mtu: mtu);

  @override
  Stream<DiscoveredDevice> scanForDevices({
    required List<Uuid> withServices,
    ScanMode scanMode = ScanMode.balanced,
    bool requireLocationServicesEnabled = true,
  }) =>
      _ble.scanForDevices(
        withServices: withServices,
        scanMode: scanMode,
        requireLocationServicesEnabled: requireLocationServicesEnabled,
      );

  @override
  DiscoveredDevicesRegistryImpl get scanRegistry => _ble.scanRegistry;

  @override
  BleStatus get status => _ble.status;

  @override
  Stream<BleStatus> get statusStream => _ble.statusStream;

  @override
  Stream<List<int>> subscribeToCharacteristic(
    QualifiedCharacteristic characteristic,
  ) =>
      _ble.subscribeToCharacteristic(characteristic);

  @override
  Future<void> writeCharacteristicWithResponse(
    QualifiedCharacteristic characteristic, {
    required List<int> value,
  }) =>
      _ble.writeCharacteristicWithResponse(
        characteristic,
        value: value,
      );

  @override
  Future<void> writeCharacteristicWithoutResponse(
    QualifiedCharacteristic characteristic, {
    required List<int> value,
  }) =>
      _ble.writeCharacteristicWithoutResponse(
        characteristic,
        value: value,
      );
}

class CatchpadSimulator extends _FlutterReactiveBleExtender {
  IOWebSocketChannel? _ch;
  Future<IOWebSocketChannel> get _channel async {
    if (_ch == null) {
      initialize();
    }

    return _ch!;
  }

  final Ref ref;
  CatchpadSimulator(this.ref) : super();

  @override
  set logLevel(LogLevel logLevel) => LogLevel.verbose;

  @override
  LogLevel get logLevel => LogLevel.verbose;

  @override
  Stream<List<int>> subscribeToCharacteristic(
    QualifiedCharacteristic characteristic,
  ) {
    final env = ref.watch(enviromentProv);
    if (env == null) {
      return const Stream.empty();
    }

    late IOWebSocketChannel ch = IOWebSocketChannel.connect(
      [
        env.wsUri,
        characteristic.serviceId,
        characteristic.characteristicId,
        characteristic.deviceId,
      ].join(defaultSeperator),
    );

    ch.sink.add(startSubscriptionCommand);

    return ch.stream.map((msg) => (msg as String).codeUnits);
  }

  @override
  Stream<DiscoveredDevice> scanForDevices({
    required List<Uuid> withServices,
    ScanMode scanMode = ScanMode.balanced,
    bool requireLocationServicesEnabled = true,
  }) async* {
    final env = ref.watch(enviromentProv);
    if (env == null) return;

    final ch = IOWebSocketChannel.connect(
      [env.wsUri, scanChannelName].join(defaultSeperator),
    );

    // if `ch` is not available, the server is not running.
    try {
      ch.sink.add(startScanCommand);

      await for (final msg in ch.stream) {
        final sp = msg.split(defaultSeperator);

        final id = sp[0];
        final name = sp[1];

        final d = DiscoveredDevice(
          id: id,
          name: name,
          serviceData: const {},
          manufacturerData: Uint8List.fromList([]),
          rssi: 0,
          serviceUuids: const [],
        );

        yield d;
      }
    } catch (e) {
      logger.d('Check your server is running');
      logger.e(e);
    } finally {
      await ch.sink.close();
    }
  }

  Stream<PadState> devicesStates() async* {
    final env = ref.watch(enviromentProv);
    if (env == null) return;

    late IOWebSocketChannel ch;

    connect() async {
      ch = IOWebSocketChannel.connect(
        [env.wsUri, simulatorServiceId, stateChannelName]
            .join(defaultSeperator),
      );
    }

    connect();
    ch.sink.add(startStateListeningCommand);
    // if `ch` is not available, the server is not running.
    try {
      await for (final msg in ch.stream) {
        final state = PadState.fromString(msg);

        yield state;
      }

      logger.d('closing channel ${DateTime.now().toIso8601String()}');
    } catch (e) {
      logger.d(
          'Check your server is running ${DateTime.now().toIso8601String()}');
      logger.e(e);
    } finally {
      await ch.sink.close();
    }
  }

  Stream<AcceleremetorTapModel> devicesTouches() async* {
    final env = ref.watch(enviromentProv);
    if (env == null) return;

    late IOWebSocketChannel ch;

    connect() async {
      ch = IOWebSocketChannel.connect(
        [env.wsUri, simulatorServiceId, simulatorCharacteristic.uuid]
            .join(defaultSeperator),
      );
    }

    connect();
    ch.sink.add(startStateListeningCommand);
    // if `ch` is not available, the server is not running.
    try {
      await for (final msg in ch.stream) {
        final event = AcceleremetorTapModel.fromBytes(msg);

        yield event;
      }

      logger.d('closing channel ${DateTime.now().toIso8601String()}');
      await ch.sink.close();
    } catch (e) {
      logger.d(
          'Check your server is running ${DateTime.now().toIso8601String()}');
      logger.e(e);
    } finally {
      await ch.sink.close();
    }
  }

  @override
  Stream<ConnectionStateUpdate> connectToDevice({
    required String id,
    Map<Uuid, List<Uuid>>? servicesWithCharacteristicsToDiscover,
    Duration? connectionTimeout,
  }) async* {
    yield ConnectionStateUpdate(
      deviceId: id,
      connectionState: DeviceConnectionState.connecting,
      failure: null,
    );

    final ch = await _channel;

    ch.sink.add('connect:$id');

    yield ConnectionStateUpdate(
      deviceId: id,
      connectionState: DeviceConnectionState.connected,
      failure: null,
    );
  }

  static final Map<String, IOWebSocketChannel> _channels = {};

  @override
  Future<void> writeCharacteristicWithoutResponse(
    QualifiedCharacteristic characteristic, {
    required List<int> value,
  }) async {
    final env = ref.watch(enviromentProv);
    if (env == null) return;

    final url =
        [env.wsUri, characteristic.idForSimulator].join(defaultSeperator);

    late IOWebSocketChannel ch;
    if (_channels.containsKey(url)) {
      ch = _channels[url]!;
    } else {
      ch = IOWebSocketChannel.connect(url);
      _channels[url] = ch;
    }

    ch.sink.add(value);
  }

  @override
  Future<void> writeCharacteristicWithResponse(
    QualifiedCharacteristic characteristic, {
    required List<int> value,
  }) async {
    await writeCharacteristicWithoutResponse(characteristic, value: value);
  }

  @override
  Future<void> initialize() async {
    super.initialize();

    final env = ref.watch(enviromentProv);
    if (env == null) return;

    _ch = IOWebSocketChannel.connect(env.wsUri);
  }

  static Future<bool> simulateTapEvent(WidgetRef ref, String deviceId,
      {required AcceleremetorTapModel model}) async {
    final dt = [UsedSensorsType.tap.index, model.toParseString()]
        .join(defaultSeperator);

    return await BleManager.writeCharacteristic(
      c: simulatorCharacteristic.qualCharacteristic(deviceId),
      data: utf8.encode(dt),
      withResponse: true,
      ref: ref,
    );
  }

  static Future<bool> simulateMotionEvent(WidgetRef ref, String deviceId,
      {required AcceleremetorGravityModel model}) async {
    final dt = [UsedSensorsType.motion.index, model.toParseString()]
        .join(defaultSeperator);

    return await BleManager.writeCharacteristic(
      c: simulatorCharacteristic.qualCharacteristic(deviceId),
      data: utf8.encode(dt),
      withResponse: true,
      ref: ref,
    );
  }

  static Future<bool> simulateDstEvent(WidgetRef ref, String deviceId,
      {required DistanceModel model}) async {
    final dt = [UsedSensorsType.distance.index, model.toParseString()]
        .join(defaultSeperator);

    return await BleManager.writeCharacteristic(
      c: simulatorCharacteristic.qualCharacteristic(deviceId),
      data: utf8.encode(dt),
      withResponse: true,
      ref: ref,
    );
  }

  @override
  Future<int> requestMtu({required String deviceId, required int mtu}) {
    return Future.value(mtu);
  }

  @override
  Future<void> requestConnectionPriority(
      {required String deviceId, required ConnectionPriority priority}) {
    return Future.value();
  }
}

extension CPCharectaristic on QualifiedCharacteristic {
  String get idForSimulator => [
        serviceId,
        characteristicId,
        deviceId,
      ].join(defaultSeperator);
}
