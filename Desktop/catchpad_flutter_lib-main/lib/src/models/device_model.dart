import 'dart:typed_data';

import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

typedef DeviceModel = DiscoveredDevice;
typedef DevList = List<DeviceModel>;

extension CatchpadConnection on ConnectionStateUpdate {
  bool get isConnected => connectionState == DeviceConnectionState.connected;
}

extension CpDiscoveredDevice on DiscoveredDevice {
  bool get isCPDevice => name.toLowerCase().contains('catchpad');

  int? get deviceNumber {
    final d = deviceNameId;
    if (d == null) return null;
    return int.tryParse(d);
  }

  String? get deviceNameId {
    List<String> sp;
    sp = name.split(' ');

    if (sp.length == 2) {
      return sp[0];
    }

    return null;
  }

  Future<String?> deviceStickerId(WidgetRef ref) async {
    if (deviceNumber != null) {
      return deviceNumber.toString();
    }

    final sp = deviceNameId?.split('sticker_title');

    if (sp == null || sp.isEmpty) {
      assert(false);
      return null;
    }

    final stId = sp[1];
    return stId;
  }

  static Map<String, String?> devIdNameIdMap(Iterable<DeviceModel> devs) {
    return devs.fold(
      {},
      (Map<String, String?> map, DeviceModel dev) {
        map[dev.id] = dev.deviceNameId;
        return map;
      },
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }

  static DeviceModel fromJson(Map<String, dynamic> json) {
    return DeviceModel(
      id: json['id'] as String,
      name: json['name'] as String,
      manufacturerData: Uint8List.fromList([]),
      rssi: 0,
      serviceData: const {},
      serviceUuids: const [],
    );
  }
}
