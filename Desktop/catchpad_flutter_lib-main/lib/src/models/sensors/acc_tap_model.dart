import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import '../../utils/big_guy.dart';
import '../../utils/pad_consts.dart';

part 'acc_tap_model.g.dart';

@JsonSerializable()
class AcceleremetorTapModel {
  final int commandTime, actionTime;
  final int tapCounter;
  final bool isValid;

  Duration? get responseTime => BigGuy.responseTime(actionTime, commandTime);

  const AcceleremetorTapModel({
    required this.commandTime,
    required this.actionTime,
    required this.tapCounter,
    required this.isValid,
  });

  factory AcceleremetorTapModel.fromBytes(List<int> bytes) {
    // format: command_time/action_time/tap_counter
    final s = utf8.decode(bytes);
    final sp = s.split(defaultSeperator);

    bool isV = true;
    // TODO: there is a problem in deactivate,
    // so we're recieving data from other sensors
    int parse(String s) {
      final intV = int.tryParse(s);
      if (intV == null) {
        isV = false;
      }
      return (double.tryParse(s) ?? 0.0).toInt();
    }

    if (sp.length == 1) {
      return AcceleremetorTapModel(
        commandTime: 0,
        actionTime: 0,
        tapCounter: bytes.first,
        isValid: true,
      );
    }
    return AcceleremetorTapModel(
      commandTime: parse(sp[0]),
      actionTime: parse(sp[1]),
      tapCounter: parse(sp[2]),
      isValid: isV,
    );
  }

  String toParseString() {
    return [commandTime, actionTime, tapCounter].join(defaultSeperator);
  }

  List<int> toBytes() {
    final st = toParseString();
    return utf8.encode(st);
  }

  @override
  String toString() {
    return {
      'commandTime': commandTime,
      'actionTime': actionTime,
      'tapCounter': tapCounter,
      'responseTime': responseTime,
    }.entries.map((e) => '${e.key}: ${e.value}').join('\n');
  }

  factory AcceleremetorTapModel.fromJson(Map<String, dynamic> json) =>
      _$AcceleremetorTapModelFromJson(json);
  Map<String, dynamic> toJson() => _$AcceleremetorTapModelToJson(this);
}
