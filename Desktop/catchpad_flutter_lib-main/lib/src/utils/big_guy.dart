import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:xrandom/xrandom.dart';

import '../enums/sensors/config/sensor_type.dart';

/// this class is just here for general purposed
/// methods
abstract class BigGuy {
  static Color randomColor() => Color(0xFF000000 | Xrandom().nextInt(0xFFFFFF));

  static int boolToInt(bool b) => b ? 1 : 0;

  static bool intToBool(int i) => i == 1;

  static String boolToNumString(bool b) => boolToInt(b).toString();

  static bool numStringToBool(String s) => intToBool(int.parse(s));

  static Duration? responseTime(int actionTime, int commandTime) {
    if (actionTime == -1 || commandTime == -1) {
      return null;
    }
    final ms = actionTime - commandTime;
    return Duration(milliseconds: ms);
  }

  static String sensorTypeToStr(SensorType type) {
    switch (type) {
      case SensorType.acc:
        return 'ACC';
      case SensorType.dst:
        return 'DST';
      case SensorType.vel:
        return 'VEL';
      default:
        return '';
    }
  }

  static void onPop(BuildContext context, VoidCallback onPop) {
    final loc = GoRouter.of(context).location;

    listener() async {
      debugPrint(GoRouter.of(context).location);
      debugPrint(loc);
      if (GoRouter.of(context).location == loc) {
        onPop();
        GoRouter.of(context).removeListener(listener);
      }
    }

    GoRouter.of(context).addListener(listener);
  }
}
