import 'dart:convert';
import 'dart:math';

import 'package:json_annotation/json_annotation.dart';

import '../../utils/big_guy.dart';
import '../../utils/pad_consts.dart';

part 'acc_gravity_model.g.dart';

@JsonSerializable()
class AcceleremetorGravityModel {
  final double x, y, z, temperature;

  final int commandTime, actionTime;

  Duration? get responseTime => BigGuy.responseTime(actionTime, commandTime);

  const AcceleremetorGravityModel({
    required this.commandTime,
    required this.actionTime,
    required this.x,
    required this.y,
    required this.z,
    required this.temperature,
  });

  AcceleremetorGravityModel copyWith(
    double? x,
    double? y,
    double? z,
    double? temperature,
    int? commandTime,
    int? actionTime,
  ) => AcceleremetorGravityModel(
    actionTime: actionTime ?? this.actionTime,
    commandTime: commandTime ?? this.commandTime,
    x: x ?? this.x,
    y: y ?? this.y,
    z: z ?? this.z,
    temperature: temperature ?? this.temperature,
  );

  factory AcceleremetorGravityModel.fromBytes(List<int> bytes) {
    // format: command_time / action_time / x / y / z / temperature
    final s = utf8.decode(bytes);
    final sp = s.split(defaultSeperator);

    double parse(String s) {
      return (double.tryParse(s) ?? 0.0);
    }

    return AcceleremetorGravityModel(
      commandTime: parse(sp[0]).floor(),
      actionTime: parse(sp[1]).floor(),
      x: parse(sp[2]),
      y: parse(sp[3]),
      z: parse(sp[4]),
      temperature: parse(sp[5]),
    );
  }

  String toParseString() {
    return [x, y, z, temperature].join(defaultSeperator);
  }

  List<int> toBytes() {
    final st = toParseString();
    return utf8.encode(st);
  }

  double get roll {
    var r = atan2(y, z) * 57.3;

    // TODO: this is a temporary thing.
    // because of manually producing the pad,
    // the sensor is not sensitive enough,
    // so it is giving a wrong value.
    {
      r = 180 - r;
      if (r > 180) {
        r -= 360;
      }
    }

    return r;
  }

  static double rl(double r) {
    r = 180 - r;

    if (r > 180) {
      r -= 360;
    }

    return r;
  }

  double get pitch {
    return atan2((-1 * x), sqrt(y * y + z * z)) * 57.3;
  }

  @override
  String toString() {
    return {
      'x': x,
      'y': y,
      'z': z,
      'temperature': temperature,
      'roll': roll,
      'pitch': pitch,
    }.entries.map((e) => '${e.key}: ${e.value}').join('\n');
  }

  factory AcceleremetorGravityModel.fromJson(Map<String, dynamic> json) =>
      _$AcceleremetorGravityModelFromJson(json);
  Map<String, dynamic> toJson() => _$AcceleremetorGravityModelToJson(this);
}
