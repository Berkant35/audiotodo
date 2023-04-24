import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/device_model.dart';
import 'ble_device_connector_prov.dart';

typedef DeviceStatusMapProvider = StateProvider<DeviceStatusMap>;

typedef DeviceStatusMap = Map<DeviceModel, ConnectionStateUpdate>;

typedef DeviceStatusMapEntry = MapEntry<DeviceModel, ConnectionStateUpdate>;

final bleConenctionStateProv = StreamProvider<DeviceStatusMap>(
  (ref) async* {
    final con = ref.watch(bleDeviceConnectorProv);

    final st = con.state;

    await for (final el in st) {
      ref.read(bleConPr.notifier).updateEntry(el);
    }
  },
);

final bleConPr =
    StateNotifierProvider<BleConnectionStateNotifier, DeviceStatusMap>(
  (ref) {
    return BleConnectionStateNotifier();
  },
);

class BleConnectionStateNotifier extends StateNotifier<DeviceStatusMap> {
  BleConnectionStateNotifier() : super({});

  void updateDevice(DeviceModel d, DeviceConnectionState conState) =>
      update(d, conState);

  void updateEntry(DeviceStatusMapEntry entry) =>
      update(entry.key, entry.value.connectionState);

  void update(DeviceModel device, DeviceConnectionState conState) {
    DeviceStatusMap newM = {};

    for (var item in state.entries) {
      if (item.key == device) {
        newM[item.key] = item.value.copyWith(connectionState: conState);
      } else {
        newM[item.key] = item.value;
      }
    }

    if (conState == DeviceConnectionState.connected) {
      newM[device] ??= ConnectionStateUpdate(
        connectionState: conState,
        deviceId: device.id,
        failure: null,
      );
    } else {
      newM.remove(device);
    }

    state = newM;
  }
}

final connectedDevicesProv =
    StateNotifierProvider<ConnectedDevicesNotifier, DevList>(
  (ref) {
    return ConnectedDevicesNotifier();
  },
);

class ConnectedDevicesNotifier extends StateNotifier<DevList> {
  ConnectedDevicesNotifier() : super([]);

  void addDevice(DeviceModel d) {
    state = List.from(state)..add(d);
  }

  void removeDevice(DeviceModel d) {
    state = List.from(state)..removeWhere((element) => element.id == d.id);
  }

  void updateDevice(DeviceModel d) {
    final DevList ls = List.from(state);
    ls.removeWhere((element) => element.id == d.id);
    ls.add(d);
    state = ls;
  }
}
