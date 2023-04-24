// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'sensor_config_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$SensorConfigModel {
  SensorType get sensorType => throw _privateConstructorUsedError;
  ConfigScale? get scale => throw _privateConstructorUsedError;
  ConfigMode? get mode => throw _privateConstructorUsedError;
  DataRate? get dataRate => throw _privateConstructorUsedError;
  int? get limitValue => throw _privateConstructorUsedError;

  /// ACC: 0-127
  /// DST: 0-2000
  int? get threshold => throw _privateConstructorUsedError;

  /// 0 - 99999 ms
  int? get timeout => throw _privateConstructorUsedError;
  ConfigScale? get intScale => throw _privateConstructorUsedError;
  ConfigMode? get intMode => throw _privateConstructorUsedError;
  DataRate? get intDataRate => throw _privateConstructorUsedError;

  /// ACC: 0-127
  /// DST: 0-2000
  int? get intThreshold => throw _privateConstructorUsedError;

  /// 0 - 99999 ms
  int? get intTimeout => throw _privateConstructorUsedError;

  /// ms
  /// 0 - 20 ms
  /// how long to wait for an interrupt
  int? get intDuration => throw _privateConstructorUsedError;

  /// wether to enable sleep mode
  bool? get intSleepEnable => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $SensorConfigModelCopyWith<SensorConfigModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SensorConfigModelCopyWith<$Res> {
  factory $SensorConfigModelCopyWith(
          SensorConfigModel value, $Res Function(SensorConfigModel) then) =
      _$SensorConfigModelCopyWithImpl<$Res>;
  $Res call(
      {SensorType sensorType,
      ConfigScale? scale,
      ConfigMode? mode,
      DataRate? dataRate,
      int? limitValue,
      int? threshold,
      int? timeout,
      ConfigScale? intScale,
      ConfigMode? intMode,
      DataRate? intDataRate,
      int? intThreshold,
      int? intTimeout,
      int? intDuration,
      bool? intSleepEnable});
}

/// @nodoc
class _$SensorConfigModelCopyWithImpl<$Res>
    implements $SensorConfigModelCopyWith<$Res> {
  _$SensorConfigModelCopyWithImpl(this._value, this._then);

  final SensorConfigModel _value;
  // ignore: unused_field
  final $Res Function(SensorConfigModel) _then;

  @override
  $Res call({
    Object? sensorType = freezed,
    Object? scale = freezed,
    Object? mode = freezed,
    Object? dataRate = freezed,
    Object? limitValue = freezed,
    Object? threshold = freezed,
    Object? timeout = freezed,
    Object? intScale = freezed,
    Object? intMode = freezed,
    Object? intDataRate = freezed,
    Object? intThreshold = freezed,
    Object? intTimeout = freezed,
    Object? intDuration = freezed,
    Object? intSleepEnable = freezed,
  }) {
    return _then(_value.copyWith(
      sensorType: sensorType == freezed
          ? _value.sensorType
          : sensorType // ignore: cast_nullable_to_non_nullable
              as SensorType,
      scale: scale == freezed
          ? _value.scale
          : scale // ignore: cast_nullable_to_non_nullable
              as ConfigScale?,
      mode: mode == freezed
          ? _value.mode
          : mode // ignore: cast_nullable_to_non_nullable
              as ConfigMode?,
      dataRate: dataRate == freezed
          ? _value.dataRate
          : dataRate // ignore: cast_nullable_to_non_nullable
              as DataRate?,
      limitValue: limitValue == freezed
          ? _value.limitValue
          : limitValue // ignore: cast_nullable_to_non_nullable
              as int?,
      threshold: threshold == freezed
          ? _value.threshold
          : threshold // ignore: cast_nullable_to_non_nullable
              as int?,
      timeout: timeout == freezed
          ? _value.timeout
          : timeout // ignore: cast_nullable_to_non_nullable
              as int?,
      intScale: intScale == freezed
          ? _value.intScale
          : intScale // ignore: cast_nullable_to_non_nullable
              as ConfigScale?,
      intMode: intMode == freezed
          ? _value.intMode
          : intMode // ignore: cast_nullable_to_non_nullable
              as ConfigMode?,
      intDataRate: intDataRate == freezed
          ? _value.intDataRate
          : intDataRate // ignore: cast_nullable_to_non_nullable
              as DataRate?,
      intThreshold: intThreshold == freezed
          ? _value.intThreshold
          : intThreshold // ignore: cast_nullable_to_non_nullable
              as int?,
      intTimeout: intTimeout == freezed
          ? _value.intTimeout
          : intTimeout // ignore: cast_nullable_to_non_nullable
              as int?,
      intDuration: intDuration == freezed
          ? _value.intDuration
          : intDuration // ignore: cast_nullable_to_non_nullable
              as int?,
      intSleepEnable: intSleepEnable == freezed
          ? _value.intSleepEnable
          : intSleepEnable // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

/// @nodoc
abstract class _$$_SensorConfigModelCopyWith<$Res>
    implements $SensorConfigModelCopyWith<$Res> {
  factory _$$_SensorConfigModelCopyWith(_$_SensorConfigModel value,
          $Res Function(_$_SensorConfigModel) then) =
      __$$_SensorConfigModelCopyWithImpl<$Res>;
  @override
  $Res call(
      {SensorType sensorType,
      ConfigScale? scale,
      ConfigMode? mode,
      DataRate? dataRate,
      int? limitValue,
      int? threshold,
      int? timeout,
      ConfigScale? intScale,
      ConfigMode? intMode,
      DataRate? intDataRate,
      int? intThreshold,
      int? intTimeout,
      int? intDuration,
      bool? intSleepEnable});
}

/// @nodoc
class __$$_SensorConfigModelCopyWithImpl<$Res>
    extends _$SensorConfigModelCopyWithImpl<$Res>
    implements _$$_SensorConfigModelCopyWith<$Res> {
  __$$_SensorConfigModelCopyWithImpl(
      _$_SensorConfigModel _value, $Res Function(_$_SensorConfigModel) _then)
      : super(_value, (v) => _then(v as _$_SensorConfigModel));

  @override
  _$_SensorConfigModel get _value => super._value as _$_SensorConfigModel;

  @override
  $Res call({
    Object? sensorType = freezed,
    Object? scale = freezed,
    Object? mode = freezed,
    Object? dataRate = freezed,
    Object? limitValue = freezed,
    Object? threshold = freezed,
    Object? timeout = freezed,
    Object? intScale = freezed,
    Object? intMode = freezed,
    Object? intDataRate = freezed,
    Object? intThreshold = freezed,
    Object? intTimeout = freezed,
    Object? intDuration = freezed,
    Object? intSleepEnable = freezed,
  }) {
    return _then(_$_SensorConfigModel(
      sensorType: sensorType == freezed
          ? _value.sensorType
          : sensorType // ignore: cast_nullable_to_non_nullable
              as SensorType,
      scale: scale == freezed
          ? _value.scale
          : scale // ignore: cast_nullable_to_non_nullable
              as ConfigScale?,
      mode: mode == freezed
          ? _value.mode
          : mode // ignore: cast_nullable_to_non_nullable
              as ConfigMode?,
      dataRate: dataRate == freezed
          ? _value.dataRate
          : dataRate // ignore: cast_nullable_to_non_nullable
              as DataRate?,
      limitValue: limitValue == freezed
          ? _value.limitValue
          : limitValue // ignore: cast_nullable_to_non_nullable
              as int?,
      threshold: threshold == freezed
          ? _value.threshold
          : threshold // ignore: cast_nullable_to_non_nullable
              as int?,
      timeout: timeout == freezed
          ? _value.timeout
          : timeout // ignore: cast_nullable_to_non_nullable
              as int?,
      intScale: intScale == freezed
          ? _value.intScale
          : intScale // ignore: cast_nullable_to_non_nullable
              as ConfigScale?,
      intMode: intMode == freezed
          ? _value.intMode
          : intMode // ignore: cast_nullable_to_non_nullable
              as ConfigMode?,
      intDataRate: intDataRate == freezed
          ? _value.intDataRate
          : intDataRate // ignore: cast_nullable_to_non_nullable
              as DataRate?,
      intThreshold: intThreshold == freezed
          ? _value.intThreshold
          : intThreshold // ignore: cast_nullable_to_non_nullable
              as int?,
      intTimeout: intTimeout == freezed
          ? _value.intTimeout
          : intTimeout // ignore: cast_nullable_to_non_nullable
              as int?,
      intDuration: intDuration == freezed
          ? _value.intDuration
          : intDuration // ignore: cast_nullable_to_non_nullable
              as int?,
      intSleepEnable: intSleepEnable == freezed
          ? _value.intSleepEnable
          : intSleepEnable // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

/// @nodoc

class _$_SensorConfigModel implements _SensorConfigModel {
  const _$_SensorConfigModel(
      {required this.sensorType,
      this.scale,
      this.mode,
      this.dataRate,
      this.limitValue = 6,
      this.threshold,
      this.timeout,
      this.intScale,
      this.intMode,
      this.intDataRate,
      this.intThreshold,
      this.intTimeout,
      this.intDuration,
      this.intSleepEnable});

  @override
  final SensorType sensorType;
  @override
  final ConfigScale? scale;
  @override
  final ConfigMode? mode;
  @override
  final DataRate? dataRate;
  @override
  @JsonKey()
  final int? limitValue;

  /// ACC: 0-127
  /// DST: 0-2000
  @override
  final int? threshold;

  /// 0 - 99999 ms
  @override
  final int? timeout;
  @override
  final ConfigScale? intScale;
  @override
  final ConfigMode? intMode;
  @override
  final DataRate? intDataRate;

  /// ACC: 0-127
  /// DST: 0-2000
  @override
  final int? intThreshold;

  /// 0 - 99999 ms
  @override
  final int? intTimeout;

  /// ms
  /// 0 - 20 ms
  /// how long to wait for an interrupt
  @override
  final int? intDuration;

  /// wether to enable sleep mode
  @override
  final bool? intSleepEnable;

  @override
  String toString() {
    return 'SensorConfigModel(sensorType: $sensorType, scale: $scale, mode: $mode, dataRate: $dataRate, limitValue: $limitValue, threshold: $threshold, timeout: $timeout, intScale: $intScale, intMode: $intMode, intDataRate: $intDataRate, intThreshold: $intThreshold, intTimeout: $intTimeout, intDuration: $intDuration, intSleepEnable: $intSleepEnable)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_SensorConfigModel &&
            const DeepCollectionEquality()
                .equals(other.sensorType, sensorType) &&
            const DeepCollectionEquality().equals(other.scale, scale) &&
            const DeepCollectionEquality().equals(other.mode, mode) &&
            const DeepCollectionEquality().equals(other.dataRate, dataRate) &&
            const DeepCollectionEquality()
                .equals(other.limitValue, limitValue) &&
            const DeepCollectionEquality().equals(other.threshold, threshold) &&
            const DeepCollectionEquality().equals(other.timeout, timeout) &&
            const DeepCollectionEquality().equals(other.intScale, intScale) &&
            const DeepCollectionEquality().equals(other.intMode, intMode) &&
            const DeepCollectionEquality()
                .equals(other.intDataRate, intDataRate) &&
            const DeepCollectionEquality()
                .equals(other.intThreshold, intThreshold) &&
            const DeepCollectionEquality()
                .equals(other.intTimeout, intTimeout) &&
            const DeepCollectionEquality()
                .equals(other.intDuration, intDuration) &&
            const DeepCollectionEquality()
                .equals(other.intSleepEnable, intSleepEnable));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(sensorType),
      const DeepCollectionEquality().hash(scale),
      const DeepCollectionEquality().hash(mode),
      const DeepCollectionEquality().hash(dataRate),
      const DeepCollectionEquality().hash(limitValue),
      const DeepCollectionEquality().hash(threshold),
      const DeepCollectionEquality().hash(timeout),
      const DeepCollectionEquality().hash(intScale),
      const DeepCollectionEquality().hash(intMode),
      const DeepCollectionEquality().hash(intDataRate),
      const DeepCollectionEquality().hash(intThreshold),
      const DeepCollectionEquality().hash(intTimeout),
      const DeepCollectionEquality().hash(intDuration),
      const DeepCollectionEquality().hash(intSleepEnable));

  @JsonKey(ignore: true)
  @override
  _$$_SensorConfigModelCopyWith<_$_SensorConfigModel> get copyWith =>
      __$$_SensorConfigModelCopyWithImpl<_$_SensorConfigModel>(
          this, _$identity);
}

abstract class _SensorConfigModel implements SensorConfigModel {
  const factory _SensorConfigModel(
      {required final SensorType sensorType,
      final ConfigScale? scale,
      final ConfigMode? mode,
      final DataRate? dataRate,
      final int? limitValue,
      final int? threshold,
      final int? timeout,
      final ConfigScale? intScale,
      final ConfigMode? intMode,
      final DataRate? intDataRate,
      final int? intThreshold,
      final int? intTimeout,
      final int? intDuration,
      final bool? intSleepEnable}) = _$_SensorConfigModel;

  @override
  SensorType get sensorType;
  @override
  ConfigScale? get scale;
  @override
  ConfigMode? get mode;
  @override
  DataRate? get dataRate;
  @override
  int? get limitValue;
  @override

  /// ACC: 0-127
  /// DST: 0-2000
  int? get threshold;
  @override

  /// 0 - 99999 ms
  int? get timeout;
  @override
  ConfigScale? get intScale;
  @override
  ConfigMode? get intMode;
  @override
  DataRate? get intDataRate;
  @override

  /// ACC: 0-127
  /// DST: 0-2000
  int? get intThreshold;
  @override

  /// 0 - 99999 ms
  int? get intTimeout;
  @override

  /// ms
  /// 0 - 20 ms
  /// how long to wait for an interrupt
  int? get intDuration;
  @override

  /// wether to enable sleep mode
  bool? get intSleepEnable;
  @override
  @JsonKey(ignore: true)
  _$$_SensorConfigModelCopyWith<_$_SensorConfigModel> get copyWith =>
      throw _privateConstructorUsedError;
}
