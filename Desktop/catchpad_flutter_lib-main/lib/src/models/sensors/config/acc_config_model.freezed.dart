// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'acc_config_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

AccConfigModel _$AccConfigModelFromJson(Map<String, dynamic> json) {
  return _AccConfigModel.fromJson(json);
}

/// @nodoc
mixin _$AccConfigModel {
  ConfigScale? get scale => throw _privateConstructorUsedError;
  ConfigMode? get mode => throw _privateConstructorUsedError;
  DataRate? get dataRate => throw _privateConstructorUsedError;

  /// 0-127
  int? get threshold => throw _privateConstructorUsedError;

  /// 0 - 99999 ms
  int? get timeout => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AccConfigModelCopyWith<AccConfigModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AccConfigModelCopyWith<$Res> {
  factory $AccConfigModelCopyWith(
          AccConfigModel value, $Res Function(AccConfigModel) then) =
      _$AccConfigModelCopyWithImpl<$Res>;
  $Res call(
      {ConfigScale? scale,
      ConfigMode? mode,
      DataRate? dataRate,
      int? threshold,
      int? timeout});
}

/// @nodoc
class _$AccConfigModelCopyWithImpl<$Res>
    implements $AccConfigModelCopyWith<$Res> {
  _$AccConfigModelCopyWithImpl(this._value, this._then);

  final AccConfigModel _value;
  // ignore: unused_field
  final $Res Function(AccConfigModel) _then;

  @override
  $Res call({
    Object? scale = freezed,
    Object? mode = freezed,
    Object? dataRate = freezed,
    Object? threshold = freezed,
    Object? timeout = freezed,
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
      timeout: timeout == freezed
          ? _value.timeout
          : timeout // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
abstract class _$$_AccConfigModelCopyWith<$Res>
    implements $AccConfigModelCopyWith<$Res> {
  factory _$$_AccConfigModelCopyWith(
          _$_AccConfigModel value, $Res Function(_$_AccConfigModel) then) =
      __$$_AccConfigModelCopyWithImpl<$Res>;
  @override
  $Res call(
      {ConfigScale? scale,
      ConfigMode? mode,
      DataRate? dataRate,
      int? threshold,
      int? timeout});
}

/// @nodoc
class __$$_AccConfigModelCopyWithImpl<$Res>
    extends _$AccConfigModelCopyWithImpl<$Res>
    implements _$$_AccConfigModelCopyWith<$Res> {
  __$$_AccConfigModelCopyWithImpl(
      _$_AccConfigModel _value, $Res Function(_$_AccConfigModel) _then)
      : super(_value, (v) => _then(v as _$_AccConfigModel));

  @override
  _$_AccConfigModel get _value => super._value as _$_AccConfigModel;

  @override
  $Res call({
    Object? scale = freezed,
    Object? mode = freezed,
    Object? dataRate = freezed,
    Object? threshold = freezed,
    Object? timeout = freezed,
  }) {
    return _then(_$_AccConfigModel(
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
      timeout: timeout == freezed
          ? _value.timeout
          : timeout // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_AccConfigModel extends _AccConfigModel {
  const _$_AccConfigModel(
      {this.scale, this.mode, this.dataRate, this.threshold, this.timeout})
      : super._();

  factory _$_AccConfigModel.fromJson(Map<String, dynamic> json) =>
      _$$_AccConfigModelFromJson(json);

  @override
  final ConfigScale? scale;
  @override
  final ConfigMode? mode;
  @override
  final DataRate? dataRate;

  /// 0-127
  @override
  final int? threshold;

  /// 0 - 99999 ms
  @override
  final int? timeout;

  @override
  String toString() {
    return 'AccConfigModel(scale: $scale, mode: $mode, dataRate: $dataRate, threshold: $threshold, timeout: $timeout)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_AccConfigModel &&
            const DeepCollectionEquality().equals(other.scale, scale) &&
            const DeepCollectionEquality().equals(other.mode, mode) &&
            const DeepCollectionEquality().equals(other.dataRate, dataRate) &&
            const DeepCollectionEquality().equals(other.threshold, threshold) &&
            const DeepCollectionEquality().equals(other.timeout, timeout));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(scale),
      const DeepCollectionEquality().hash(mode),
      const DeepCollectionEquality().hash(dataRate),
      const DeepCollectionEquality().hash(threshold),
      const DeepCollectionEquality().hash(timeout));

  @JsonKey(ignore: true)
  @override
  _$$_AccConfigModelCopyWith<_$_AccConfigModel> get copyWith =>
      __$$_AccConfigModelCopyWithImpl<_$_AccConfigModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_AccConfigModelToJson(
      this,
    );
  }
}

abstract class _AccConfigModel extends AccConfigModel {
  const factory _AccConfigModel(
      {final ConfigScale? scale,
      final ConfigMode? mode,
      final DataRate? dataRate,
      final int? threshold,
      final int? timeout}) = _$_AccConfigModel;
  const _AccConfigModel._() : super._();

  factory _AccConfigModel.fromJson(Map<String, dynamic> json) =
      _$_AccConfigModel.fromJson;

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

  /// 0 - 99999 ms
  int? get timeout;
  @override
  @JsonKey(ignore: true)
  _$$_AccConfigModelCopyWith<_$_AccConfigModel> get copyWith =>
      throw _privateConstructorUsedError;
}
