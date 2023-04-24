// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'acc_tap_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AcceleremetorTapModel _$AcceleremetorTapModelFromJson(
        Map<String, dynamic> json) =>
    AcceleremetorTapModel(
      commandTime: json['commandTime'] as int,
      actionTime: json['actionTime'] as int,
      tapCounter: json['tapCounter'] as int,
      isValid: json['isValid'] as bool,
    );

Map<String, dynamic> _$AcceleremetorTapModelToJson(
        AcceleremetorTapModel instance) =>
    <String, dynamic>{
      'commandTime': instance.commandTime,
      'actionTime': instance.actionTime,
      'tapCounter': instance.tapCounter,
      'isValid': instance.isValid,
    };
