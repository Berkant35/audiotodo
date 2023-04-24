// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'acc_config_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_AccConfigModel _$$_AccConfigModelFromJson(Map<String, dynamic> json) =>
    _$_AccConfigModel(
      scale: $enumDecodeNullable(_$ConfigScaleEnumMap, json['scale']),
      mode: $enumDecodeNullable(_$ConfigModeEnumMap, json['mode']),
      dataRate: $enumDecodeNullable(_$DataRateEnumMap, json['dataRate']),
      threshold: json['threshold'] as int?,
      timeout: json['timeout'] as int?,
    );

Map<String, dynamic> _$$_AccConfigModelToJson(_$_AccConfigModel instance) =>
    <String, dynamic>{
      'scale': _$ConfigScaleEnumMap[instance.scale],
      'mode': _$ConfigModeEnumMap[instance.mode],
      'dataRate': _$DataRateEnumMap[instance.dataRate],
      'threshold': instance.threshold,
      'timeout': instance.timeout,
    };

const _$ConfigScaleEnumMap = {
  ConfigScale.LIS2DH12_2g: 'LIS2DH12_2g',
  ConfigScale.LIS2DH12_4g: 'LIS2DH12_4g',
  ConfigScale.LIS2DH12_8g: 'LIS2DH12_8g',
  ConfigScale.LIS2DH12_16g: 'LIS2DH12_16g',
};

const _$ConfigModeEnumMap = {
  ConfigMode.LIS2DH12_HR_12bit: 'LIS2DH12_HR_12bit',
  ConfigMode.LIS2DH12_NM_10bit: 'LIS2DH12_NM_10bit',
};

const _$DataRateEnumMap = {
  DataRate.LIS2DH12_POWER_DOWN: 'LIS2DH12_POWER_DOWN',
  DataRate.LIS2DH12_ODR_1Hz: 'LIS2DH12_ODR_1Hz',
  DataRate.LIS2DH12_ODR_10Hz: 'LIS2DH12_ODR_10Hz',
  DataRate.LIS2DH12_ODR_25Hz: 'LIS2DH12_ODR_25Hz',
  DataRate.LIS2DH12_ODR_50Hz: 'LIS2DH12_ODR_50Hz',
  DataRate.LIS2DH12_ODR_100Hz: 'LIS2DH12_ODR_100Hz',
  DataRate.LIS2DH12_ODR_200Hz: 'LIS2DH12_ODR_200Hz',
  DataRate.LIS2DH12_ODR_400Hz: 'LIS2DH12_ODR_400Hz',
  DataRate.LIS2DH12_ODR_1kHz620_LP: 'LIS2DH12_ODR_1kHz620_LP',
  DataRate.LIS2DH12_ODR_5kHz376_LP_1kHz344_NM_HP:
      'LIS2DH12_ODR_5kHz376_LP_1kHz344_NM_HP',
};
