// ignore_for_file: constant_identifier_names

import 'dart:convert';

import 'package:async/async.dart' show StreamGroup;
import 'package:catchpad_flutter_lib/catchpad_flutter_lib.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../enums/sensors/config/sensor_type.dart';
import 'sensors/config/sensor_config_model.dart';

abstract class PadSensorManager {
  // #region activate

  // #region dst methods
  static Future<bool> activateDst({
    required WidgetRef ref,
    required String deviceId,
  }) async {
    await _deactivateAll(deviceId: deviceId, ref: ref);
    return _activate(
      sensorType: SensorType.dst,
      status: true,
      ref: ref,
      deviceId: deviceId,
    );
  }

  static Future<bool> deactivateDst({
    required WidgetRef ref,
    required String deviceId,
  }) async {
    return _activate(
      sensorType: SensorType.dst,
      status: false,
      ref: ref,
      deviceId: deviceId,
    );
  }

  static Future<bool> lockDstThreshold({
    required WidgetRef ref,
    required String deviceId,
  }) =>
      _lockThreshold(
        sensorType: SensorType.dst,
        ref: ref,
        deviceId: deviceId,
      );

  static Future<bool> unlockDstThreshold({
    required WidgetRef ref,
    required String deviceId,
  }) =>
      _unlockThreshold(
        sensorType: SensorType.dst,
        ref: ref,
        deviceId: deviceId,
      );

  // #endregion

  // #region acc methods

  static Future<bool> activateAccForce({
    required WidgetRef ref,
    required String deviceId,
  }) async {
    await _deactivateAll(
        deviceId: deviceId, ref: ref);
    return _activate(
      sensorType: SensorType.acc,
      accSensorType: AccSensorType.force,
      status: true,
      ref: ref,
      deviceId: deviceId,
    );
  }

  static Future<bool> activateAccGravity({
    required WidgetRef ref,
    required String deviceId,
  }) async {
    await _deactivateAll(
        deviceId: deviceId, ref: ref);
    return _activate(
      sensorType: SensorType.acc,
      accSensorType: AccSensorType.gravity,
      status: true,
      ref: ref,
      deviceId: deviceId,
    );
  }

  static Future<bool> activateAccTap(
      {required WidgetRef ref, required String deviceId}) async {
    await _deactivateAll(
        deviceId: deviceId, ref: ref);
    return _activate(
      sensorType: SensorType.acc,
      accSensorType: AccSensorType.tap,
      status: true,
      ref: ref,
      deviceId: deviceId,
    );
  }

  static Future<bool> deactivateAccTap({
    required WidgetRef ref,
    required String deviceId,
  }) async {
    return _deactivateAcc(
      ref: ref,
      deviceId: deviceId,
      accSensorType: AccSensorType.tap,
    );
  }

  static Future<bool> deactivateAccForce({
    required WidgetRef ref,
    required String deviceId,
  }) async {
    return _deactivateAcc(
      ref: ref,
      deviceId: deviceId,
      accSensorType: AccSensorType.force,
    );
  }

  static Future<bool> deactivateAccGravity({
    required WidgetRef ref,
    required String deviceId,
  }) async {
    return _deactivateAcc(
      ref: ref,
      deviceId: deviceId,
      accSensorType: AccSensorType.gravity,
    );
  }

  static Future<bool> _deactivateAcc({
    required WidgetRef ref,
    required String deviceId,
    required AccSensorType accSensorType,
  }) async {
    return _activate(
      sensorType: SensorType.acc,
      accSensorType: accSensorType,
      status: false,
      ref: ref,
      deviceId: deviceId,
    );
  }

  static Future<bool> lockAccGravityThreshold({
    required WidgetRef ref,
    required String deviceId,
  }) =>
      _lockThreshold(
        sensorType: SensorType.acc,
        accSensorType: AccSensorType.gravity,
        ref: ref,
        deviceId: deviceId,
      );

  static Future<bool> lockAccForceThreshold({
    required WidgetRef ref,
    required String deviceId,
  }) =>
      _lockThreshold(
        sensorType: SensorType.acc,
        accSensorType: AccSensorType.force,
        ref: ref,
        deviceId: deviceId,
      );

  static Future<bool> unlockAccForceThreshold({
    required WidgetRef ref,
    required String deviceId,
  }) =>
      _unlockThreshold(
        sensorType: SensorType.acc,
        accSensorType: AccSensorType.force,
        ref: ref,
        deviceId: deviceId,
      );

  static Future<bool> unlockAccGravityThreshold({
    required WidgetRef ref,
    required String deviceId,
  }) =>
      _unlockThreshold(
        sensorType: SensorType.acc,
        accSensorType: AccSensorType.gravity,
        ref: ref,
        deviceId: deviceId,
      );

  static Future<bool> lockAccTapThreshold({
    required WidgetRef ref,
    required String deviceId,
  }) =>
      _lockThreshold(
        sensorType: SensorType.acc,
        accSensorType: AccSensorType.tap,
        ref: ref,
        deviceId: deviceId,
      );

  static Future<bool> unlockAccTapThreshold({
    required WidgetRef ref,
    required String deviceId,
  }) =>
      _unlockThreshold(
        sensorType: SensorType.acc,
        accSensorType: AccSensorType.tap,
        ref: ref,
        deviceId: deviceId,
      );

  // #endregion

  static Future<bool> _lockThreshold({
    required SensorType sensorType,
    required WidgetRef ref,
    required String deviceId,
    AccSensorType? accSensorType,
  }) async {
    return _activate(
      sensorType: sensorType,
      status: true,
      ref: ref,
      deviceId: deviceId,
      accSensorType: accSensorType,
      // this kinda works in reverse, the comment in _activate
      thrLock: false,
    );
  }

  static Future<bool> _unlockThreshold({
    required SensorType sensorType,
    required WidgetRef ref,
    required String deviceId,
    AccSensorType? accSensorType,
  }) async {
    return _activate(
      sensorType: sensorType,
      status: true,
      ref: ref,
      deviceId: deviceId,
      accSensorType: accSensorType,
      // this kinda works in reverse, the comment in _activate
      thrLock: true,
    );
  }

  static Future<bool> _activate({
    required SensorType sensorType,
    AccSensorType? accSensorType,

    /// true if enable, false if disable
    required bool status,

    /// wether to respect the threshold or not.
    /// if true, the sensor will keep streaming
    /// even if the threshold is not met.
    bool thrLock = false,
    required WidgetRef ref,
    required String deviceId,
  }) async {
    // SENSOR TYPE NAME	/	SENSOR STATUS	/	ACC SENSOR TYPE	/	THRLOCK
    final dt = [
      BigGuy.sensorTypeToStr(sensorType),
      BigGuy.boolToInt(status),
      (accSensorType
              // we have to send a value for the acc sensor type
              // even if it is not used.
              ??
              AccSensorType.values[0])
          .index,
      BigGuy.boolToInt(thrLock),
    ].join(defaultSeperator);
    return await BleManager.writeCharacteristic(
      ref: ref,
      c: activateCharacteristic.qualCharacteristic(deviceId),
      data: utf8.encode(dt),
      withResponse: true,
    );
  }

  static Future<bool> deactivateAll(
          {required WidgetRef ref,
          required String deviceId}) =>
      _deactivateAll(ref: ref, deviceId: deviceId);

  static Future<bool> _deactivateAll(
      {required WidgetRef ref,
      required String deviceId}) async {
    final reqs = [
      // only one acc deactivate
      // is enough to deactivate
      // both tap and gravity
      // deactivateAccGravity,
      deactivateAccTap,
      deactivateDst,
    ];

    bool allTrue = true;

    for (final req in reqs) {
      final res = await req(ref: ref, deviceId: deviceId);
      await Future.delayed(const Duration(milliseconds: 100));
      if (!res) {
        allTrue = false;
      }
    }
    await Future.delayed(const Duration(milliseconds: 100));
    return allTrue;
  }
  // #endregion

  // #region config
  static Future<bool> _config({
    required String deviceId,
    required WidgetRef ref,
    required SensorConfigModel model,
  }) {
    final dt = [
      BigGuy.sensorTypeToStr(model.sensorType),
      model.scale?.index,
      model.mode?.index,
      model.dataRate?.index,
      model.threshold,
      model.timeout,
      if (model.sensorType != SensorType.dst) ...[
        model.intScale?.index ?? '-1',
        model.intMode?.index ?? '-1',
        model.intDataRate?.index ?? '-1',
        model.intThreshold ?? '-1',
        model.intDuration ?? '-1',
        model.intTimeout ?? '-1',
        model.intSleepEnable == null
            ? '-1'
            : BigGuy.boolToNumString(model.intSleepEnable!),
      ],
      if (model.sensorType == SensorType.dst) ...[model.limitValue]
    ].map((e) => e ?? '-1').join(defaultSeperator);

    return BleManager.writeCharacteristic(
      ref: ref,
      c: configCharacteristic.qualCharacteristic(deviceId),
      data: utf8.encode(dt),
      withResponse: true,
    );
  }

  static Future<bool> configAccSensor({
    required String deviceId,
    required WidgetRef ref,
    AccConfigModel? model
    // TODO: temporarily the acc does not handle
    // -1's, so we have to send the default one
    // if it is null.
    = defAccConfigModel,
    AccInterruptConfigModel? intModel
    // TODO: temporarily the interrupt does not handle
    // -1's, so we have to send the default one
    // if it is null.
    = accInterruptConfigModelWithMinusOne,
  }) {
    assert(model != null || intModel != null);

    final models = [
      if (model != null) model.toSensorConfigModel(),
      if (intModel != null) intModel.toSensorConfigModel(),
    ];

    var newModel = const SensorConfigModel(sensorType: SensorType.acc);

    for (final m in models) {
      newModel = newModel.copyWith(
        scale: m.scale ?? newModel.scale,
        mode: m.mode ?? newModel.mode,
        dataRate: m.dataRate ?? newModel.dataRate,
        threshold: m.threshold ?? newModel.threshold,
        timeout: m.timeout ?? newModel.timeout,
        intScale: m.intScale ?? newModel.intScale,
        intMode: m.intMode ?? newModel.intMode,
        intDataRate: m.intDataRate ?? newModel.intDataRate,
        intThreshold: m.intThreshold ?? newModel.intThreshold,
        intDuration: m.intDuration ?? newModel.intDuration,
        intTimeout: m.intTimeout ?? newModel.intTimeout,
        intSleepEnable: m.intSleepEnable ?? newModel.intSleepEnable,
      );
    }

    return _config(
      deviceId: deviceId,
      ref: ref,
      model: newModel,
    );
  }

  static Future<bool> configDstSensor({
    required String deviceId,
    required WidgetRef ref,
    required DstConfigModel model,
  }) =>
      _config(
        deviceId: deviceId,
        ref: ref,
        model: model.toSensorConfigModel(),
      );

  // #endregion

  // #region listeners

  // #region distance
  static Stream<DistanceEvent> listenToDistance(
    String deviceId, {
    required WidgetRef ref,
  }) async* {
    yield* BleManager.subscribeToCharacteristic(
      dstCharacteristic.qualCharacteristic(deviceId),
      ref: ref,
    ).map(
      (bytes) {
        return DistanceEvent(
          deviceId,
          DistanceModel.fromBytes(bytes),
        );
      },
    ).where(
      (event) {
        // TODO: temporarily, the hardware is giving us
        // some innocent surprises of negative values
        // sometimes 😇. @fatih says that the source is
        // because of the plastic cover, and this will
        // be fixed soon.
        return event.distance.isPositive;
      },
    );
  }

  static Stream<DistanceEvent> listenToDistanceMulti(
    Iterable<String> deviceIds, {
    required WidgetRef ref,
  }) {
    return StreamGroup.merge(
      deviceIds.map(
        (deviceId) => listenToDistance(
          deviceId,
          ref: ref,
        ),
      ),
    );
  }
  // #endregion

  // #region motion
  static Stream<MotionEvent> listenToMotion(
    String deviceId, {
    required WidgetRef ref,
  }) async* {
    yield* BleManager.subscribeToCharacteristic(
      accCharacteristic.qualCharacteristic(deviceId),
      ref: ref,
    ).map(
      (bytes) => MotionEvent(
        deviceId,
        AcceleremetorGravityModel.fromBytes(bytes),
      ),
    );
  }

  static Stream<MotionEvent> listenToMotionMulti(
    Iterable<String> deviceIds, {
    required WidgetRef ref,
  }) {
    return StreamGroup.merge(
      deviceIds.map(
        (deviceId) => listenToMotion(
          deviceId,
          ref: ref,
        ),
      ),
    );
  }
  // #endregion

  // #region touch
  static Stream<TouchEvent> listenToTouch(
    String deviceId, {
    required WidgetRef ref,
  }) async* {
    yield* BleManager.subscribeToCharacteristic(
      accCharacteristic.qualCharacteristic(deviceId),
      ref: ref,
    ).map(
      (bytes) => TouchEvent(
        deviceId,
        AcceleremetorTapModel.fromBytes(bytes),
      ),
    );
  }

  static Stream<TouchEvent> listenToTouchMulti(
    Iterable<String> deviceIds, {
    required WidgetRef ref,
  }) {
    return StreamGroup.merge(
      deviceIds.map(
        (deviceId) => listenToTouch(
          deviceId,
          ref: ref,
        ),
      ),
    );
  }
  // #endregion

  // #endregion
}
