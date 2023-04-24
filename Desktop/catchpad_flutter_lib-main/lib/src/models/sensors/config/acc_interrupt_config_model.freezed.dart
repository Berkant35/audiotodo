// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'acc_interrupt_config_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

AccInterruptConfigModel _$AccInterruptConfigModelFromJson(
    Map<String, dynamic> json) {
  return _AccInterruptConfigModel.fromJson(json);
}

/// @nodoc
mixin _$AccInterruptConfigModel {
  ConfigScale? get scale => throw _privateConstructorUsedError;
  ConfigMode? get mode => throw _privateConstructorUsedError;
  DataRate? get dataRate => throw _privateConstructorUsedError;

  /// 0-127
  int? get threshold => throw _privateConstructorUsedError;

  /// ms
  /// 0 - 20 ms
  /// how long to wait for an interrupt
  int? get duration => throw _privateConstructorUsedError;

  /// MINUTE
  /// 0 - 60 minutes
  /// after how long of inactivity to go to sleep
  int? get timeout => throw _privateConstructorUsedError;

  /// wether to enable sleep mode
  bool? get sleepEnable => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AccInterruptConfigModelCopyWith<AccInterruptConfigModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AccInterruptConfigModelCopyWith<$Res> {
  factory $AccInterruptConfigModelCopyWith(AccInterruptConfigModel value,
          $Res Function(AccInterruptConfigModel) then) =
      _$AccInterruptConfigModelCopyWithImpl<$Res>;
  $Res call(
      {ConfigScale? scale,
      ConfigMode? mode,
      DataRate? dataRate,
      int? threshold,
      int? duration,
      int? timeout,
      bool? sleepEnable});
}

/// @nodoc
class _$AccInterruptConfigModelCopyWithImpl<$Res>
    implements $AccInterruptConfigModelCopyWith<$Res> {
  _$AccInterruptConfigModelCopyWithImpl(this._value, this._then);

  final AccInterruptConfigModel _value;
  // ignore: unused_field
  final $Res Function(AccInterruptConfigModel) _then;

  @override
  $Res call({
    Object? scale = freezed,
    Object? mode = freezed,
    Object? dataRate = freezed,
    Object? threshold = freezed,
    Object? duration = freezed,
    Object? timeout = freezed,
    Object? sleepEnable = freezed,
  }) {
    return _then(_value.copyWith(
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
      threshold: threshold == freezed
          ? _value.threshold
          : threshold // ignore: cast_nullable_to_non_nullable
              as int?,
      duration: duration == freezed
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as int?,
      timeout: timeout == freezed
          ? _value.timeout
          : timeout // ignore: cast_nullable_to_non_nullable
              as int?,
      sleepEnable: sleepEnable == freezed
          ? _value.sleepEnable
          : sleepEnable // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

/// @nodoc
abstract class _$$_AccInterruptConfigModelCopyWith<$Res>
    implements $AccInterruptConfigModelCopyWith<$Res> {
  factory _$$_AccInterruptConfigModelCopyWith(_$_AccInterruptConfigModel value,
          $Res Function(_$_AccInterruptConfigModel) then) =
      __$$_AccInterruptConfigModelCopyWithImpl<$Res>;
  @override
  $Res call(
      {ConfigScale? scale,
      ConfigMode? mode,
      DataRate? dataRate,
      int? threshold,
      int? duration,
      int? timeout,
      bool? sleepEnable});
}

/// @nodoc
class __$$_AccInterruptConfigModelCopyWithImpl<$Res>
    extends _$AccInterruptConfigModelCopyWithImpl<$Res>
    implements _$$_AccInterruptConfigModelCopyWith<$Res> {
  __$$_AccInterruptConfigModelCopyWithImpl(_$_AccInterruptConfigModel _value,
      $Res Function(_$_AccInterruptConfigModel) _then)
      : super(_value, (v) => _then(v as _$_AccInterruptConfigModel));

  @override
  _$_AccInterruptConfigModel get _value =>
      super._value as _$_AccInterruptConfigModel;

  @override
  $Res call({
    Object? scale = freezed,
    Object? mode = freezed,
    Object? dataRate = freezed,
    Object? threshold = freezed,
    Object? duration = freezed,
    Object? timeout = freezed,
    Object? sleepEnable = freezed,
  }) {
    return _then(_$_AccInterruptConfigModel(
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
      threshold: threshold == freezed
          ? _value.threshold
          : threshold // ignore: cast_nullable_to_non_nullable
              as int?,
      duration: duration == freezed
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as int?,
      timeout: timeout == freezed
          ? _value.timeout
          : timeout // ignore: cast_nullable_to_non_nullable
              as int?,
      sleepEnable: sleepEnable == freezed
          ? _value.sleepEnable
          : sleepEnable // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_AccInterruptConfigModel extends _AccInterruptConfigModel {
  const _$_AccInterruptConfigModel(
      {this.scale,
      this.mode,
      this.dataRate,
      this.threshold,
      this.duration,
      this.timeout,
      this.sleepEnable})
      : super._();

  factory _$_AccInterruptConfigModel.fromJson(Map<String, dynamic> json) =>
      _$$_AccInterruptConfigModelFromJson(json);

  @override
  final ConfigScale? scale;
  @override
  final ConfigMode? mode;
  @override
  final DataRate? dataRate;

  /// 0-127
  @override
  final int? threshold;

  /// ms
  /// 0 - 20 ms
  /// how long to wait for an interrupt
  @override
  final int? duration;

  /// MINUTE
  /// 0 - 60 minutes
  /// after how long of inactivity to go to sleep
  @override
  final int? timeout;

  /// wether to enable sleep mode
  @override
  final bool? sleepEnable;

  @override
  String toString() {
    return 'AccInterruptConfigModel(scale: $scale, mode: $mode, dataRate: $dataRate, threshold: $threshold, duration: $duration, timeout: $timeout, sleepEnable: $sleepEnable)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_AccInterruptConfigModel &&
            const DeepCollectionEquality().equals(other.scale, scale) &&
            const DeepCollectionEquality().equals(other.mode, mode) &&
            const DeepCollectionEquality().equals(other.dataRate, dataRate) &&
            const DeepCollectionEquality().equals(other.threshold, threshold) &&
            const DeepCollectionEquality().equals(other.duration, duration) &&
            const DeepCollectionEquality().equals(other.timeout, timeout) &&
            const DeepCollectionEquality()
                .equals(other.sleepEnable, sleepEnable));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(scale),
      const DeepCollectionEquality().hash(mode),
      const DeepCollectionEquality().hash(dataRate),
      const DeepCollectionEquality().hash(threshold),
      const DeepCollectionEquality().hash(duration),
      const DeepCollectionEquality().hash(timeout),
      const DeepCollectionEquality().hash(sleepEnable));

  @JsonKey(ignore: true)
  @override
  _$$_AccInterruptConfigModelCopyWith<_$_AccInterruptConfigModel>
      get copyWith =>
          __$$_AccInterruptConfigModelCopyWithImpl<_$_AccInterruptConfigModel>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_AccInterruptConfigModelToJson(
      this,
    );
  }
}

abstract class _AccInterruptConfigModel extends AccInterruptConfigModel {
  const factory _AccInterruptConfigModel(
      {final ConfigScale? scale,
      final ConfigMode? mode,
      final DataRate? dataRate,
      final int? threshold,
      final int? duration,
      final int? timeout,
      final bool? sleepEnable}) = _$_AccInterruptConfigModel;
  const _AccInterruptConfigModel._() : super._();

  factory _AccInterruptConfigModel.fromJson(Map<String, dynamic> json) =
      _$_AccInterruptConfigModel.fromJson;

  @override
  ConfigScale? get scale;
  @override
  ConfigMode? get mode;
  @override
  DataRate? get dataRate;
  @override

  /// 0-127
  int? get threshold;
  @override

  /// ms
  /// 0 - 20 ms
  /// how long to wait for an interrupt
  int? get duration;
  @override

  /// MINUTE
  /// 0 - 60 minutes
  /// after how long of inactivity to go to sleep
  int? get timeout;
  @override

  /// wether to enable sleep mode
  bool? get sleepEnable;
  @override
  @JsonKey(ignore: true)
  _$$_AccInterruptConfigModelCopyWith<_$_AccInterruptConfigModel>
      get copyWith => throw _privateConstructorUsedError;
}
