// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'acc_gravity_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AcceleremetorGravityModel _$AcceleremetorGravityModelFromJson(
        Map<String, dynamic> json) =>
    AcceleremetorGravityModel(
      commandTime: json['commandTime'] as int,
      actionTime: json['actionTime'] as int,
      x: (json['x'] as num).toDouble(),
      y: (json['y'] as num).toDouble(),
      z: (json['z'] as num).toDouble(),
      temperature: (json['temperature'] as num).toDouble(),
    );

Map<String, dynamic> _$AcceleremetorGravityModelToJson(
        AcceleremetorGravityModel instance) =>
    <String, dynamic>{
      'x': instance.x,
      'y': instance.y,
      'z': instance.z,
      'temperature': instance.temperature,
      'commandTime': instance.commandTime,
      'actionTime': instance.actionTime,
    };
