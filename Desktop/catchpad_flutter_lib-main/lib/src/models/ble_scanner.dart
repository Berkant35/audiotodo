import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../catchpad_flutter_lib_init.dart';
import '../provs/ble_prov.dart';
import 'device_model.dart';
import 'reactive_state.dart';

class BleScanner implements ReactiveState<BleScannerState> {
  BleScanner(this.ref) : _ble = ref.watch(bleProv);
  final Ref ref;

  final FlutterReactiveBle _ble;

  StreamController<BleScannerState>? _stateStreamController;
  bool _pushedStateOnce = true;

  StreamSubscription? _subscription;

  var _devices = <DeviceModel>{};
  final _lastdevices = <DeviceModel>{};

  @override
  Stream<BleScannerState> get state {
    return _stateStreamController!.stream;
  }

  void updateDeviceInfo(DeviceModel newDev) {
    final d = <DeviceModel>{};

    for (var dev in _devices) {
      if (dev.id == newDev.id) {
        d.add(newDev);
      } else {
        d.add(dev);
      }
    }

    _devices = Set<DeviceModel>.from(d);

    _pushState();
  }

  void refreshScan({required List<DiscoveredDevice> connectedDevices}) async {
    final lastdevices = Set<DiscoveredDevice>.from(_lastdevices);
    for (var condev in connectedDevices) {
      lastdevices.removeWhere((lastdev) => lastdev.id == condev.id);
    }
    final orgdevs = Set<DiscoveredDevice>.from(_devices);
    final intersections = lastdevices.intersection(orgdevs);
    for (var intersec in intersections) {
      if (!lastdevices.any((lastdev) => lastdev.id == intersec.id)) {
        _devices.remove(intersec);
      }
    }
    /* if (connectedDevices.isNotEmpty) {
      debugPrint('${connectedDevices.map((e) => e.name)}');
      for (var condev in connectedDevices) {
        lastdevices
      }
      lastdevices.removeWhere((lastdev) => connectedDevices
          .any((connecteddev) => lastdev.id != connecteddev.id));
    }
    if (_devices.isNotEmpty) {
      final orgdevs = _devices.toList();
      for (var orgdev in orgdevs) {
        if (!lastdevices.map((e) => e.id).contains(orgdev.id)) {
          _devices.removeWhere((dev) => dev.id == orgdev.id);
        }
      }
    } */

    _pushState();
    debugPrint('${_devices.map((e) => e.name)}');
    debugPrint('${lastdevices.map((e) => e.name)}');
    _lastdevices.clear();
  }

  void hardRefreshScan(
      {required List<DiscoveredDevice> connectedDevices}) async {
    pauseScan();
    for (var condev in connectedDevices) {
      if (!_devices.map((e) => e.id).contains(condev.id)) {
        _devices.remove(condev);
      }
    }
    debugPrint('${_devices.map((e) => e.name)}');
    debugPrint('${_lastdevices.map((e) => e.name)}');
    _lastdevices.clear();
    _pushState();
    resumeScan();
  }

  void pauseScan() {
    if (_subscription != null) {
      _subscription?.pause();
    }
  }

  void resumeScan() {
    if (_subscription != null) {
      _subscription?.resume();
    }
  }

  void startScan() async {
    init();
    logger.i('Start ble discovery');
    _subscription = _ble.scanForDevices(
      withServices: [], requireLocationServicesEnabled: true,
      // serviceUuids,
    ).listen(
      (device) {
        // if (!device.isCPDevice) return;

        // dont add already added devices
        if (device.isCPDevice) {
          _lastdevices.add(device);
          if (_devices.any((element) => element.id == device.id)) {
            return;
          }
          _devices.add(device);
          if (_pushedStateOnce) {
            _pushState();
            Future.delayed(const Duration(seconds: 5))
                .then((value) => _pushedStateOnce = false);
          }
        }
      },
      onError: (Object e) => logger.e(
        'Device scan fails with error: $e',
      ),
      onDone: () {
        logger.d('Device scan is done.');
      },
    );

    _pushState();

    //await Future.delayed(scanDuration);

    //stopScan();
  }

  void _pushState() {
    if (!isClosed) {
      _stateStreamController!.add(
        BleScannerState(
          deviceModels: _devices,
          scanIsInProgress: _subscription != null,
        ),
      );
    }
  }

  bool get isClosed =>
      _stateStreamController == null || _stateStreamController!.isClosed;

  Future<void> stopScan() async {
    logger.i('Stop ble discovery');

    if (_subscription != null) {
      await _subscription?.cancel();
      _subscription = null;
    }

    if (!isClosed) {
      await dispose();
    }
  }

  Future<void> dispose() async {
    _pushState();

    // I've commented out these lines, because
    // as there is a widgdt listening to the
    // this stream, if we reinitialize the
    // stream when the user pressed scan
    // button, the user's stream reference
    // will stay fixed on the old instance
    // of the stream. idk if this makes sense
    // to you, this is the best I can explain.
    // but also, here's a small demonstration:
    //
    // WidgetA => listening to
    // a = _stateStreamController.stream
    // when we close and nullify
    // _stateStreamController,
    // WidgetA will stay fixed on a and not
    // listen to the new stream.
    // this is exactly the case in
    // lib/ui/device/device_list.dart _DevList
    // Widget.
    //
    // if you did not understand yet, don't
    // worry, just leave this as is and it would
    // work just fine for the eternity of this
    // codebase.
    //
    // await _stateStreamController?.close();
    // _stateStreamController = null;
  }

  void init() {
    _stateStreamController ??= StreamController();
  }
}

@immutable
class BleScannerState {
  const BleScannerState({
    required Set<DeviceModel> deviceModels,
    required this.scanIsInProgress,
  }) : _deviceModels = deviceModels;

  final Set<DeviceModel> _deviceModels;
  final bool scanIsInProgress;

  List<DeviceModel> get deviceModels =>
      _deviceModels.where((element) => element.isCPDevice).toList();
}
