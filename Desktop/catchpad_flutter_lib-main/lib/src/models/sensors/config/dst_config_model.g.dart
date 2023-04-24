// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dst_config_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_DstConfigModel _$$_DstConfigModelFromJson(Map<String, dynamic> json) =>
    _$_DstConfigModel(
      threshold: json['threshold'] as int?,
      timeout: json['timeout'] as int?,
      limitValue: json['limitValue'] as int? ?? 6,
    );

Map<String, dynamic> _$$_DstConfigModelToJson(_$_DstConfigModel instance) =>
    <String, dynamic>{
      'threshold': instance.threshold,
      'timeout': instance.timeout,
      'limitValue': instance.limitValue,
    };
