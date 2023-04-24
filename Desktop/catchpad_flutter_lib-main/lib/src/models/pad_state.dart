import 'package:flutter/foundation.dart';

import '../utils/big_guy.dart';
import '../utils/pad_consts.dart';
import 'pad_manager.dart';

class ActivatedSensorsModel {
  final bool tap;
  final bool gravity;
  final bool distance;

  const ActivatedSensorsModel({
    this.tap = false,
    this.gravity = false,
    this.distance = false,
  });

  factory ActivatedSensorsModel.fromString(String s) {
    final sp = s.split(subSeperator);

    return ActivatedSensorsModel(
      tap: BigGuy.numStringToBool(sp[0]),
      gravity: BigGuy.numStringToBool(sp[1]),
      distance: BigGuy.numStringToBool(sp[2]),
    );
  }
}

@immutable
class PadState {
  final String padId;
  final String name;

  final SidesColorsModel color;
  final bool isCommand;

  final int? _timerStart;

  int get timerStart => _timerStart ?? -1;

  final ActivatedSensorsModel activatedSensors;

  PadState({
    required this.padId,
    required this.name,
    this.isCommand = false,
    SidesColorsModel? color,
    int? timerStart,
    required this.activatedSensors,
  })  : color = color ?? SidesColorsModel.off(),
        _timerStart = timerStart;

  // padId / name / isComamnd / color /
  // timerStart / responseTime /
  // activatedSensors
  factory PadState.fromString(String s) {
    final sp = s.split(defaultSeperator);

    return PadState(
      padId: sp[0],
      name: sp[1],
      isCommand: BigGuy.numStringToBool(sp[2]),
      color: SidesColorsModel.fromString(sp.sublist(3, 7).join('/')),
      timerStart: int.tryParse(sp[7]),
      activatedSensors: ActivatedSensorsModel.fromString(sp[8]),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PadState &&
          runtimeType == other.runtimeType &&
          padId == other.padId;

  @override
  int get hashCode => padId.hashCode;

  @override
  toString() => '''
    PadState {
      padId: $padId,
      name: $name,
      isCommand: $isCommand,
      color: $color,
      timerStart: $timerStart,
      activatedSensors: $activatedSensors,
    }
    ''';
}
