// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dst_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DistanceModel _$DistanceModelFromJson(Map<String, dynamic> json) =>
    DistanceModel(
      commandTime: json['commandTime'] as int,
      actionTime: json['actionTime'] as int,
      distance: json['distance'] as int,
      rangeStatus: json['rangeStatus'] as int,
      limitCheckCurrent: json['limitCheckCurrent'] as int,
    );

Map<String, dynamic> _$DistanceModelToJson(DistanceModel instance) =>
    <String, dynamic>{
      'commandTime': instance.commandTime,
      'actionTime': instance.actionTime,
      'distance': instance.distance,
      'rangeStatus': instance.rangeStatus,
      'limitCheckCurrent': instance.limitCheckCurrent,
    };
