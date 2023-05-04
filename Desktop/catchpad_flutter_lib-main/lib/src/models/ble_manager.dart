import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../catchpad_flutter_lib_init.dart';
import '../provs/ble_prov.dart';

abstract class BleManager {
  static FlutterReactiveBle _inst(WidgetRef ref) => ref.read(bleProv);

  static Future<List<int>?> readCharacteristic(
    QualifiedCharacteristic c, {
    required WidgetRef ref,
  }) async {
    FlutterReactiveBle inst;

    try {
      inst = _inst(ref);
    } catch (e) {
      logger.e(e);
      return null;
    }

    List<int> read;

    try {
      read = await inst.readCharacteristic(c);
    } catch (e) {
      logger.e(e);
      return null;
    }

    return read;
  }

  static Future<bool> writeCharacteristic({
    required WidgetRef ref,
    required QualifiedCharacteristic c,
    required List<int> data,
    required bool withResponse,
  }) async {
    FlutterReactiveBle inst;
    debugPrint('its in writeCharacteristic ${String.fromCharCodes(data)}');

    try {
      inst = _inst(ref);
    } catch (e) {
      debugPrint('its in writeCharacteristic and failed');
      logger.e(e);
      return false;
    }

    try {
      if (withResponse) {
        await inst.writeCharacteristicWithResponse(c, value: data);
      } else {
        await inst.writeCharacteristicWithoutResponse(c, value: data);
      }
    } catch (e) {
      logger.e(e);
      return false;
    }

    return true;
  }

  static Stream<List<int>> subscribeToCharacteristic(
    QualifiedCharacteristic c, {
    required WidgetRef ref,
  }) {
    return _inst(ref).subscribeToCharacteristic(c);
  }
}
