import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../utils/big_guy.dart';
import '../../utils/pad_consts.dart';

part 'dst_model.g.dart';

@JsonSerializable()
class DistanceModel {
  final int commandTime, actionTime;
  final int distance, rangeStatus, limitCheckCurrent;

  Duration? get responseTime => BigGuy.responseTime(actionTime, commandTime);

  const DistanceModel(
      {required this.commandTime,
      required this.actionTime,
      required this.distance,
      required this.rangeStatus,
      required this.limitCheckCurrent});

  factory DistanceModel.fromBytes(List<int> bytes) {
    // format: command_time/action_time/distance/range_status/limit_check_current
    final s = utf8.decode(bytes);
    final sp = s.split(defaultSeperator);

    int parse(String s) {
      return (double.tryParse(s) ?? 0.0).toInt();
    }

    bool isNewPad = true;
    if (sp.length <= 3) {
      isNewPad = false;
    }
    return DistanceModel(
        commandTime: parse(sp[0]),
        actionTime: parse(sp[1]),
        distance: parse(sp[2]),
        rangeStatus: parse((isNewPad) ? sp[3] : '0'),
        limitCheckCurrent: parse((isNewPad) ? sp[4] : '0'));
  }

  String toParseString() {
    return [commandTime, actionTime, distance].join(defaultSeperator);
  }

  List<int> toBytes() {
    final st = toParseString();
    return utf8.encode(st);
  }

  bool get isNegative => distance.isNegative;
  bool get isPositive => !distance.isNegative;

  @override
  String toString() {
    return {
      'commandTime': commandTime,
      'actionTime': actionTime,
      'distance': distance,
      'responseTime': responseTime,
    }.entries.map((e) => '${e.key}: ${e.value}').join('\n');
  }

  factory DistanceModel.fromJson(Map<String, dynamic> json) =>
      _$DistanceModelFromJson(json);
  Map<String, dynamic> toJson() => _$DistanceModelToJson(this);
}
