// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'dst_config_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

DstConfigModel _$DstConfigModelFromJson(Map<String, dynamic> json) {
  return _DstConfigModel.fromJson(json);
}

/// @nodoc
mixin _$DstConfigModel {
  ///  0-2000, mm
  int? get threshold => throw _privateConstructorUsedError;

  /// 0 - 99999 ms
  int? get timeout => throw _privateConstructorUsedError;

  ///
  int? get limitValue => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DstConfigModelCopyWith<DstConfigModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DstConfigModelCopyWith<$Res> {
  factory $DstConfigModelCopyWith(
          DstConfigModel value, $Res Function(DstConfigModel) then) =
      _$DstConfigModelCopyWithImpl<$Res>;
  $Res call({int? threshold, int? timeout, int? limitValue});
}

/// @nodoc
class _$DstConfigModelCopyWithImpl<$Res>
    implements $DstConfigModelCopyWith<$Res> {
  _$DstConfigModelCopyWithImpl(this._value, this._then);

  final DstConfigModel _value;
  // ignore: unused_field
  final $Res Function(DstConfigModel) _then;

  @override
  $Res call({
    Object? threshold = freezed,
    Object? timeout = freezed,
    Object? limitValue = freezed,
  }) {
    return _then(_value.copyWith(
      threshold: threshold == freezed
          ? _value.threshold
          : threshold // ignore: cast_nullable_to_non_nullable
              as int?,
      timeout: timeout == freezed
          ? _value.timeout
          : timeout // ignore: cast_nullable_to_non_nullable
              as int?,
      limitValue: limitValue == freezed
          ? _value.limitValue
          : limitValue // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
abstract class _$$_DstConfigModelCopyWith<$Res>
    implements $DstConfigModelCopyWith<$Res> {
  factory _$$_DstConfigModelCopyWith(
          _$_DstConfigModel value, $Res Function(_$_DstConfigModel) then) =
      __$$_DstConfigModelCopyWithImpl<$Res>;
  @override
  $Res call({int? threshold, int? timeout, int? limitValue});
}

/// @nodoc
class __$$_DstConfigModelCopyWithImpl<$Res>
    extends _$DstConfigModelCopyWithImpl<$Res>
    implements _$$_DstConfigModelCopyWith<$Res> {
  __$$_DstConfigModelCopyWithImpl(
      _$_DstConfigModel _value, $Res Function(_$_DstConfigModel) _then)
      : super(_value, (v) => _then(v as _$_DstConfigModel));

  @override
  _$_DstConfigModel get _value => super._value as _$_DstConfigModel;

  @override
  $Res call({
    Object? threshold = freezed,
    Object? timeout = freezed,
    Object? limitValue = freezed,
  }) {
    return _then(_$_DstConfigModel(
      threshold: threshold == freezed
          ? _value.threshold
          : threshold // ignore: cast_nullable_to_non_nullable
              as int?,
      timeout: timeout == freezed
          ? _value.timeout
          : timeout // ignore: cast_nullable_to_non_nullable
              as int?,
      limitValue: limitValue == freezed
          ? _value.limitValue
          : limitValue // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_DstConfigModel extends _DstConfigModel {
  const _$_DstConfigModel({this.threshold, this.timeout, this.limitValue = 6})
      : super._();

  factory _$_DstConfigModel.fromJson(Map<String, dynamic> json) =>
      _$$_DstConfigModelFromJson(json);

  ///  0-2000, mm
  @override
  final int? threshold;

  /// 0 - 99999 ms
  @override
  final int? timeout;

  ///
  @override
  @JsonKey()
  final int? limitValue;

  @override
  String toString() {
    return 'DstConfigModel(threshold: $threshold, timeout: $timeout, limitValue: $limitValue)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_DstConfigModel &&
            const DeepCollectionEquality().equals(other.threshold, threshold) &&
            const DeepCollectionEquality().equals(other.timeout, timeout) &&
            const DeepCollectionEquality()
                .equals(other.limitValue, limitValue));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(threshold),
      const DeepCollectionEquality().hash(timeout),
      const DeepCollectionEquality().hash(limitValue));

  @JsonKey(ignore: true)
  @override
  _$$_DstConfigModelCopyWith<_$_DstConfigModel> get copyWith =>
      __$$_DstConfigModelCopyWithImpl<_$_DstConfigModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_DstConfigModelToJson(
      this,
    );
  }
}

abstract class _DstConfigModel extends DstConfigModel {
  const factory _DstConfigModel(
      {final int? threshold,
      final int? timeout,
      final int? limitValue}) = _$_DstConfigModel;
  const _DstConfigModel._() : super._();

  factory _DstConfigModel.fromJson(Map<String, dynamic> json) =
      _$_DstConfigModel.fromJson;

  @override

  ///  0-2000, mm
  int? get threshold;
  @override

  /// 0 - 99999 ms
  int? get timeout;
  @override

  ///
  int? get limitValue;
  @override
  @JsonKey(ignore: true)
  _$$_DstConfigModelCopyWith<_$_DstConfigModel> get copyWith =>
      throw _privateConstructorUsedError;
}
