import 'dart:math' as math;

import '../catchpad_flutter_lib_init.dart';
import '../utils/big_guy.dart';

class BatteryModel {
  final double? voltage;

  /// when plugged to a charger
  final bool isCharging;

  /// when plugged to a charger, and the
  /// battery is full.
  ///
  /// once unplugged, this will be false.
  final bool isCompleted;

  BatteryModel({
    required this.voltage,
    required this.isCharging,
    required this.isCompleted,
  });

  int get percentage => voltageToPercentage(voltage);

  /// will be used to determine if a game can be played
  /// with this pad. we don't want the user to play
  /// when the pad is plugged in.
  bool get isActive => !isCharging && !isCompleted;

  static BatteryModel? fromBytes(List<int> bytes) {
    final st = String.fromCharCodes(bytes);

    final sp = st.split('/');

    if (sp.length != 3) {
      return null;
    }

    return BatteryModel(
      isCompleted: BigGuy.intToBool(int.tryParse(sp[0]) ?? 0),
      isCharging: BigGuy.intToBool(int.tryParse(sp[1]) ?? 0),
      voltage: double.tryParse(sp[2]),
    );
  }

  @override
  String toString() {
    return [
      'Voltage: ${voltage ?? 'null'}',
      'Percentage: %$percentage',
      'Is Charging: ${isCharging ? 'true' : 'false'}',
      'Is Completed: ${isCompleted ? 'true' : 'false'}',
    ].join('\n');
  }

  double closestNumMin(double vol) {
    return closestNums(vol)[0];
  }

  double closestNumMax(double vol) {
    return closestNums(vol)[1];
  }

  List<double> closestNums(double vol) {
    final keys = voltagePercentageMap.keys.toList();

    final max = keys.reduce((value, element) => math.max(value, element)) + .0;
    final min = keys.reduce((value, element) => math.min(value, element)) + .0;
    double b = max, s = min;

    if (vol > max) {
      b = s = max;
    } else if (vol < min) {
      b = s = min;
    } else {
      for (var i = 0; i < keys.length; i++) {
        final a = keys[i] + .0;

        if (a >= vol && a < b) {
          b = a;
        }

        if (a <= vol && a > s) {
          s = a;
        }
      }
    }

    return [s, b];
  }

  int voltageToPercentage(double? v) {
    if (v == null) {
      return 0;
    }

    final vMin = closestNumMin(v);
    final vMax = closestNumMax(v);

    final lMin = voltagePercentageMap[vMin]!;
    final lMax = voltagePercentageMap[vMax]!;

    if (v == vMin) {
      return lMin;
    }

    // vol = 4150
    // minKey = 4100
    // maxKey = 4200
    // min = 92
    // max = 100

    try {
      return ((
                  //
                  (
                          //
                          (v - vMin) * (lMax - lMin)) /
                      //

                      (vMax - vMin)
              //
              ) +
              //
              lMin)
          .toInt();
    } on UnsupportedError {
      return lMax;
    } catch (e) {
      logger.e(e);
      return lMax;
    }
  }

  static const Map<int, int> voltagePercentageMap = {
    4200: 100,
    4150: 95,
    4110: 90,
    4080: 85,
    4020: 80,
    3980: 75,
    3950: 70,
    3910: 65,
    3870: 60,
    3850: 55,
    3840: 50,
    3820: 45,
    3800: 40,
    3790: 35,
    3770: 30,
    3750: 25,
    3730: 20,
    3710: 15,
    3690: 10,
    3610: 5,
    3270: 0,
  };
}
