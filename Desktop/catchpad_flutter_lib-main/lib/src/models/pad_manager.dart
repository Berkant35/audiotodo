import 'dart:convert';
import 'dart:math';

import '../catchpad_flutter_lib_init.dart';
import 'battery_model.dart';
import 'ble_manager.dart';
import 'dev_info_model.dart';
import 'enviroment_model.dart';
import 'pad_sensor_manager.dart';
import 'sides_colors_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provs/enviroment_prov.dart';
import '../utils/big_guy.dart';
import '../utils/pad_consts.dart';

export 'sides_colors_model.dart';

// TODO: seperate every service to its own file (e.g. led, audio, etc.)
abstract class PadManager {

  static Future<bool> toggleLight(String deviceId, {
    required WidgetRef ref,
  }) async {
    return await ledColor(
      deviceId,
      const SidesColorsModel(
        tr: Color.fromARGB(255, 0, 0, 255),
        tl: Color.fromARGB(255, 0, 255, 0),
        br: Color.fromARGB(255, 255, 0, 0),
        bl: Color.fromARGB(255, 255, 255, 0),
      ),
      ref: ref,
    );
  }


  static Future<bool> ledOff(String deviceId, {
    required WidgetRef ref,
    bool isCommand = false,
  }) async {

    return await ledColor(
      deviceId,
      SidesColorsModel.off(),
      ref: ref,
      isCommand: isCommand,
    );
  }


  static Future<bool> sleepDevice(String deviceId, {
    required WidgetRef ref,
    bool isCommand = false,
  }) async {
    const dt = 'S';
    return await BleManager.writeCharacteristic(
      c: sleepCharacteristicAdminInfo.qualCharacteristic(deviceId),
      data: utf8.encode(dt),
      withResponse: true,
      ref: ref,
    );
  }


  static Future<bool> ledOffNoResponse(String deviceId, {
    required WidgetRef ref,
    bool isCommand = false,
  }) async {

    return await ledColor(
      deviceId,
      SidesColorsModel.off(),
      ref: ref,
      isCommand: isCommand,
      withResponse: false,
    );
  }

  static Future<bool> randomColors(String deviceId, {
    required WidgetRef ref,
  }) async {

    for (var i = 0; i < 100; i++) {
      await ledColor(
        deviceId,
        // random color
        SidesColorsModel.all(BigGuy.randomColor()),
        ref: ref,
      );
    }

    return true;
  }

  static Future<bool> sendIsCommand(String deviceId, {
    required WidgetRef ref,
  }) {
    return ledColor(
      deviceId,
      const SidesColorsModel(same: true),
      ref: ref,
      isCommand: true,
    );
  }

  static Future<bool> ledColorNoResponse(String deviceId,
      SidesColorsModel colorModel, {
        bool isCommand = false,
        required WidgetRef ref,

        /// for how long to flash the led
        /// if null, it will flash forever
        Duration? duration,
      }) async {
    return ledColor(
      deviceId,
      colorModel,
      ref: ref,
      isCommand: isCommand,
      duration: duration,
      withResponse: false,
    );
  }

  static Future<bool> ledMultiColor(Set<String> deviceIds,
      Set<SidesColorsModel> colorModels, {
        bool isCommand = false,
        required WidgetRef ref,
        bool withResponse = true,

        /// for how long to flash the led
        /// if null, it will flash forever
        Duration? duration,
      }) async {
    bool ret = false;
    List<bool> futs = [];

    final idColorMap = <String, SidesColorsModel>{
      for (int i = 0; i < deviceIds.length; i++)
        deviceIds.elementAt(i): colorModels.elementAt(i),
    };
    futs.addAll(
      await Future.wait(
        idColorMap.entries.map((entry) async {
          final devId = entry.key;
          final colorModel = entry.value;

          return await ledColor(
            devId,
            colorModel,
            ref: ref,
            isCommand: isCommand,
            duration: duration,
            withResponse: withResponse,
          );
        }),
      ),
    );

    if (duration != null) {
      await Future.delayed(duration);

      futs.addAll(
        await Future.wait(
          idColorMap.keys.map((deviceId) async {
            return await ledOff(
              deviceId,
              ref: ref,
              isCommand: isCommand,
            );
          }),
        ),
      );
    }

    ret = futs.every((fut) => fut);

    return ret;
  }

  static Future<bool> ledColor(String deviceId,
      SidesColorsModel colorModel, {
        bool isCommand = false,
        required WidgetRef ref,
        bool withResponse = true,

        /// for how long to flash the led
        /// if null, it will flash forever
        Duration? duration,
      }) async {
    final led = await _ledColor(
      deviceId,
      colorModel,
      isCommand: isCommand,
      ref: ref,
      withResponse: withResponse,
    );
    bool ledoff = true;

    if (duration != null) {
      await Future.delayed(duration);
      ledoff = await ledOff(
        deviceId,
        ref: ref,
      );
    }

    return led && ledoff;
  }

  static Future<bool> _ledColor(String deviceId,
      SidesColorsModel colorModel, {
        bool isCommand = false,
        required WidgetRef ref,
        bool withResponse = true,
      }) async {
    if (debugMode) {
      EnviromentModel? env;

      try {
        env = ref.read(enviromentProv);
      } catch (e) {
        logger.e(e);
      }

      final isReal = env?.enviromentType.isReal ?? true;
      // we're doing this inside debugMode so we would not decrease
      // performance in production as ref.read is a bit expensive
      // and _ledColor is called often.
      //
      // we wanna reduce the opacity of the color to .02 which will
      // better for the eyes of the developer when debugging on the
      // pad. but this cant be applied on the simulator as that will
      // translate all the colors to black.
      if (isReal) {
        colorModel = colorModel.opacity(.02);
      }
    }

    final dt = [
      BigGuy.boolToNumString(isCommand),
      colorModel,
    ].join(defaultSeperator);
    final charac = colorModel.allColorsSame
        ? ledAllCharacteristic.qualCharacteristic(deviceId)
        : ledCharacteristic.qualCharacteristic(deviceId);

    return await BleManager.writeCharacteristic(
      c: charac,
      data: utf8.encode(dt),
      withResponse: withResponse,
      ref: ref,
    );
  }

  //otaContiuneFlag
  static Future<bool> otaContiuneFlag(String deviceId, {
    required WidgetRef ref,
    bool isCommand = false,
    bool withResponse = false
  }) async {
    const dt = 'SETOTA/-1/1';

    return await BleManager.writeCharacteristic(
      c: otaFwCharacteristic.qualCharacteristic(deviceId),
      data: utf8.encode(dt),
      withResponse: withResponse,
      ref: ref,
    );
  }

  static Future<bool> sendPart512(String deviceId, {
    required WidgetRef ref,
    required List<int> byteList,
    bool isCommand = false,
    bool withResponse = false
  }) async {

    return await BleManager.writeCharacteristic(
      c: otaFwCharacteristic.qualCharacteristic(deviceId),
      data: byteList,
      withResponse: withResponse,
      ref: ref,
    );
  }


  //play Music
  static Future<bool> playMusic(String deviceId, {
    required WidgetRef ref,
    bool isCommand = false,
    bool withResponse = false,
  }) async {
    const dt = 'PLAY';
    return await BleManager.writeCharacteristic(
      c: audioCharacteristic.qualCharacteristic(deviceId),
      data: utf8.encode(dt),
      withResponse: withResponse,
      ref: ref,
    );
  }

  static Future<bool> sendPartMusicFile(String deviceId, {
    required WidgetRef ref,
    required List<int> byteList,
    bool isCommand = false,
    bool withResponse = false
  }) async {
    return await BleManager.writeCharacteristic(
      c: mp3transferCharacteristic.qualCharacteristic(deviceId),
      data: byteList,
      withResponse: withResponse,
      ref: ref,
    );
  }


  /// restart the device
  static Future<bool> resetDevice(String deviceId, {
    required WidgetRef ref,
  }) async {
    const dt = 'R';
    return await BleManager.writeCharacteristic(
      c: adminCharacteristic.qualCharacteristic(deviceId),
      data: utf8.encode(dt),
      withResponse: false,
      ref: ref,
    );
  }

  static Future<bool> resetDeviceSettings(String deviceId, {
    required WidgetRef ref,
  }) async {

    final futures = [
          () =>
          PadSensorManager.configAccSensor(
            deviceId: deviceId,
            ref: ref,
            model: defAccConfigModel,
            intModel: accInterruptConfigModelWithMinusOne,
          ),
          () =>
          PadSensorManager.configDstSensor(
            deviceId: deviceId,
            ref: ref,
            model: defDstConfigModel,
          ),
    ];

    bool ret = false;

    for (var future in futures) {
      final r = await future();

      if (!r) {
        ret = r;
      }
    }

    return ret;
  }

  static Future<bool> toggleDebug(String deviceId, {
    required bool enable,
    AdminMonitorType type = AdminMonitorType.serial,
    required WidgetRef ref,
    bool? inGame,
  }) async {
    final dt = [
      BigGuy.boolToInt(enable),
      type.index,
      (inGame == null) ? -1 : BigGuy.boolToInt(inGame)
    ].join(defaultSeperator);

    return await BleManager.writeCharacteristic(
      c: adminCharacteristic.qualCharacteristic(deviceId),
      data: utf8.encode(dt),
      withResponse: true,
      ref: ref,
    );
  }

  // #region device info
  static Future<bool> _sendGetDeviceInfoSignal(String deviceId, {
    required WidgetRef ref,
  }) async {
    const dt = '?';

    return await BleManager.writeCharacteristic(
      c: infoCharacteristic.qualCharacteristic(deviceId),
      data: utf8.encode(dt),
      withResponse: true,
      ref: ref,
    );
  }

  static Future<DevInfoModel?> getDeviceInfo(String deviceId, {
    required WidgetRef ref,
  }) async {
    await _sendGetDeviceInfoSignal(deviceId, ref: ref);

    final dt = await BleManager.readCharacteristic(
      infoCharacteristic.qualCharacteristic(deviceId),
      ref: ref,
    );

    if (dt == null) {
      return null;
    }

    return DevInfoModel.fromBytes(dt);
  }

  static Future<bool> _setDeviceSetName(String deviceId, {
    required WidgetRef ref,
    String? cpId,
    String? bleName,
    String? cpSN,
    String? noTM,
    String? variantId,
    String? stickerId,
  }) async {
    final dt = [
      'SETINFO',
      noTM ?? '-1',
      variantId ?? '-1',
      cpSN ?? '-1',
      bleName ?? '-1',
      stickerId ?? '-1',
    ].join(defaultSeperator);

    return await BleManager.writeCharacteristic(
      c: infoCharacteristic.qualCharacteristic(deviceId),
      data: utf8.encode(dt),
      withResponse: true,
      ref: ref,
    );
  }



  static Future<bool> requestErrorLog(String deviceId, {
    required WidgetRef ref,
    withResponse =  true,
  }) async {
    const dt = '?';
    return await BleManager.writeCharacteristic(
      c: errorLog.qualCharacteristic(deviceId),
      data: utf8.encode(dt),
      withResponse: true,
      ref: ref,
    );
  }
  //readErrorLog
  static Future<List<int>?> readErrorLog(String deviceId, {
    required WidgetRef ref,
    withResponse =  true,
  }) async {
    return await BleManager.readCharacteristic(
        errorLog.qualCharacteristic(deviceId),
        ref: ref
    );
  }

  static Future<bool> setDeviceCpId(String deviceId, {
    required WidgetRef ref,
    required String id,
  }) async {
    return _setDeviceSetName(
      deviceId,
      ref: ref,
      cpId: id,
    );
  }

  static Future<bool> setDeviceBleName(String deviceId, {
    required WidgetRef ref,
    required String name,
    String? cpSN,
    String? noTM,
    String? variantId,
    String? stickerId,
  }) async {
    return _setDeviceSetName(
      deviceId,
      ref: ref,
      bleName: name,
      cpSN: cpSN,
    );
  }

  // #region battery
  static Future<bool> _sendGetBatterySignal(String deviceId, {
    required WidgetRef ref,
  }) async {

    const dt = '?';
    return await BleManager.writeCharacteristic(
      c: batteryCharacteristic.qualCharacteristic(deviceId),
      data: utf8.encode(dt),
      withResponse: true,
      ref: ref,
    );
  }

  static Future<BatteryModel?> readBattery(String deviceId, {
    required WidgetRef ref,
  }) async {
    final signal = await _sendGetBatterySignal(deviceId, ref: ref);
    if (!signal) {
      return null;
    }

    BatteryModel? bat;

    try {
      // WHY???
      // well, TIL it's basic math
      // when we write a '?' on the characteristic,
      // apparently the characteristic shares that value
      // over the air, so when u try to read it, u actually
      // stumble upon what u've written '?', if the device
      // has not written anything yet. so we keep reading,
      // but not forever, we'll keep reading for 10 seconds,
      // until we get real data that the device has written.
      // if we don't get anything, we'll give up and return
      // null, and log the error.

      DateTime start = DateTime.now();
      await Future.doWhile(
            () async {
          // keep the dart event loop running
          await Future.delayed(Duration.zero);

          final dt = await BleManager.readCharacteristic(
            batteryCharacteristic.qualCharacteristic(deviceId),
            ref: ref,
          );

          if (dt != null) {
            bat = BatteryModel.fromBytes(dt);
          }

          // do not reverse this, bcz we need
          // the next condition to always run.
          if (bat != null) {
            return false;
          }

          final now = DateTime.now();

          if (now
              .difference(start)
              .inSeconds > 10) {
            logger.e('readBattery: timeout for MAC Address: $deviceId');
            return false;
          }

          return true;
        },
      );

      return bat;
    } catch (e) {
      assert(false);
      logger.e(e);
      return null;
    }
  }

  static Stream<BatteryModel> listenToBattery(String deviceId, {
    required WidgetRef ref,
  }) async* {
    final batt = await readBattery(deviceId, ref: ref);
    if (batt != null) {
      yield batt;
      yield* BleManager.subscribeToCharacteristic(
        batteryCharacteristic.qualCharacteristic(deviceId),
        ref: ref,
      )
          .map((dt) => BatteryModel.fromBytes(dt))
          .where((event) => event != null)
          .map((event) => event!);
    }
  }


  static Stream<String> listenToResponseForOTAUpdate(String deviceId, {
    required WidgetRef ref,
  }) async* {
    yield* BleManager.subscribeToCharacteristic(
      otaFwCharacteristic.qualCharacteristic(deviceId),
      ref: ref,
    ).map((event) => String.fromCharCodes(event));
  }


  // #endregion

  // #endregion

  // #region audio

  static Future<bool> _turnAudio(WidgetRef ref, String deviceId,
      bool enable) async {
    return await BleManager.writeCharacteristic(
      c: audioCharacteristic.qualCharacteristic(deviceId),
      data: utf8.encode(enable ? 'ON' : 'OFF'),
      withResponse: true,
      ref: ref,
    );
  }

  static Future<bool> _turnAudioOn(WidgetRef ref, String deviceId) =>
      _turnAudio(ref, deviceId, true);

  static Future<bool> _turnAudioOff(WidgetRef ref, String deviceId) =>
      _turnAudio(ref, deviceId, false);

  static Future<bool> playAudio(String deviceId, {
    required WidgetRef ref,
    // required String fileName,
    double level = 1.0,
  }) async {
    assert(level >= 0.0 && level <= 1.0);

    await _turnAudioOn(ref, deviceId);

    const data =
    // TODO: data = readFile(fileName);
    <int>[];
    // martilar15s;

    const wholeSize = 500;
    const width = 1;

    // 500
    const size = wholeSize ~/ width;

    // [08 -> 8, 1f -> 31, 2d -> 45, ...]
    final st = data.map((e) => (e * level).toInt()).toList();

    final len = st.length;

    bool b = false;
    int indx = 0;

    final sw = Stopwatch();
    final sums = <int>[];

    while (!b) {
      final start = indx * size;
      final end = min((indx + 1) * size, len);

      b = end == len;

      // list of current 500
      final ls = st.sublist(start, end);

      sw.start();
      await BleManager.writeCharacteristic(
        c: audioCharacteristic.qualCharacteristic(deviceId),
        data: ls,
        withResponse: false,
        ref: ref,
      );
      sw.stop();
      int s = sw.elapsedMilliseconds;
      sums.add(s);
      logger.d('playAudio: ms $indx: $s');

      indx++;
    }

    await _turnAudioOff(ref, deviceId);

    logger.d(
        'playAudio: played into total of ${sw.elapsedMilliseconds}ms, avg ${sw
            .elapsedMilliseconds / indx}ms');
    logger.d('playAudio: $sums');

    return true;
  }

// #endregion

}

/// where to print the debug info
enum AdminMonitorType {
  serial,
  ble,
}
