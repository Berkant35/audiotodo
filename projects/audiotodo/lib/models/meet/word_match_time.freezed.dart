// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'word_match_time.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

WordMatchTime _$WordMatchTimeFromJson(Map<String, dynamic> json) {
  return _WordMatchTime.fromJson(json);
}

/// @nodoc
mixin _$WordMatchTime {
  /// Word matching time ID
  @JsonKey(name: 'wordMatchTimeId', required: true)
  String? get wordMatchTimeId => throw _privateConstructorUsedError;

  /// ID of the meeting where the word matching time was recorded
  @JsonKey(name: 'meetId', required: true)
  String? get meetId => throw _privateConstructorUsedError;

  /// The word used for the word matching time measurement
  @JsonKey(name: 'contentWord')
  String? get contentWord => throw _privateConstructorUsedError;

  /// List of words used for the word matching time measurement
  @JsonKey(name: 'contentWords')
  List<String>? get contentWords => throw _privateConstructorUsedError;

  /// The time in milliseconds for the word matching time measurement
  @JsonKey(name: 'timeMs')
  int? get timeMs => throw _privateConstructorUsedError;

  /// The time in minutes for the word matching time measurement
  @JsonKey(name: 'timeMin')
  int? get timeMin => throw _privateConstructorUsedError;

  /// The time in seconds for the word matching time measurement
  @JsonKey(name: 'timeSec')
  int? get timeSec => throw _privateConstructorUsedError;

  /// The start time point in milliseconds for the word matching time measurement
  @JsonKey(name: 'starTimePointWithMs')
  int? get starTimePointWithMs => throw _privateConstructorUsedError;

  /// The end time point in milliseconds for the word matching time measurement
  @JsonKey(name: 'endTimePointWithMs')
  int? get endTimePointWithMs => throw _privateConstructorUsedError;

  /// The sound quality of the meeting where the word matching time was recorded
  @JsonKey(name: 'soundQuality')
  String? get soundQuality => throw _privateConstructorUsedError;

  /// The background noise level of the meeting where the word matching time was recorded
  @JsonKey(name: 'backgroundNoiseLevel')
  String? get backgroundNoiseLevel => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $WordMatchTimeCopyWith<WordMatchTime> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WordMatchTimeCopyWith<$Res> {
  factory $WordMatchTimeCopyWith(
          WordMatchTime value, $Res Function(WordMatchTime) then) =
      _$WordMatchTimeCopyWithImpl<$Res, WordMatchTime>;
  @useResult
  $Res call(
      {@JsonKey(name: 'wordMatchTimeId', required: true)
          String? wordMatchTimeId,
      @JsonKey(name: 'meetId', required: true)
          String? meetId,
      @JsonKey(name: 'contentWord')
          String? contentWord,
      @JsonKey(name: 'contentWords')
          List<String>? contentWords,
      @JsonKey(name: 'timeMs')
          int? timeMs,
      @JsonKey(name: 'timeMin')
          int? timeMin,
      @JsonKey(name: 'timeSec')
          int? timeSec,
      @JsonKey(name: 'starTimePointWithMs')
          int? starTimePointWithMs,
      @JsonKey(name: 'endTimePointWithMs')
          int? endTimePointWithMs,
      @JsonKey(name: 'soundQuality')
          String? soundQuality,
      @JsonKey(name: 'backgroundNoiseLevel')
          String? backgroundNoiseLevel});
}

/// @nodoc
class _$WordMatchTimeCopyWithImpl<$Res, $Val extends WordMatchTime>
    implements $WordMatchTimeCopyWith<$Res> {
  _$WordMatchTimeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? wordMatchTimeId = freezed,
    Object? meetId = freezed,
    Object? contentWord = freezed,
    Object? contentWords = freezed,
    Object? timeMs = freezed,
    Object? timeMin = freezed,
    Object? timeSec = freezed,
    Object? starTimePointWithMs = freezed,
    Object? endTimePointWithMs = freezed,
    Object? soundQuality = freezed,
    Object? backgroundNoiseLevel = freezed,
  }) {
    return _then(_value.copyWith(
      wordMatchTimeId: freezed == wordMatchTimeId
          ? _value.wordMatchTimeId
          : wordMatchTimeId // ignore: cast_nullable_to_non_nullable
              as String?,
      meetId: freezed == meetId
          ? _value.meetId
          : meetId // ignore: cast_nullable_to_non_nullable
              as String?,
      contentWord: freezed == contentWord
          ? _value.contentWord
          : contentWord // ignore: cast_nullable_to_non_nullable
              as String?,
      contentWords: freezed == contentWords
          ? _value.contentWords
          : contentWords // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      timeMs: freezed == timeMs
          ? _value.timeMs
          : timeMs // ignore: cast_nullable_to_non_nullable
              as int?,
      timeMin: freezed == timeMin
          ? _value.timeMin
          : timeMin // ignore: cast_nullable_to_non_nullable
              as int?,
      timeSec: freezed == timeSec
          ? _value.timeSec
          : timeSec // ignore: cast_nullable_to_non_nullable
              as int?,
      starTimePointWithMs: freezed == starTimePointWithMs
          ? _value.starTimePointWithMs
          : starTimePointWithMs // ignore: cast_nullable_to_non_nullable
              as int?,
      endTimePointWithMs: freezed == endTimePointWithMs
          ? _value.endTimePointWithMs
          : endTimePointWithMs // ignore: cast_nullable_to_non_nullable
              as int?,
      soundQuality: freezed == soundQuality
          ? _value.soundQuality
          : soundQuality // ignore: cast_nullable_to_non_nullable
              as String?,
      backgroundNoiseLevel: freezed == backgroundNoiseLevel
          ? _value.backgroundNoiseLevel
          : backgroundNoiseLevel // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_WordMatchTimeCopyWith<$Res>
    implements $WordMatchTimeCopyWith<$Res> {
  factory _$$_WordMatchTimeCopyWith(
          _$_WordMatchTime value, $Res Function(_$_WordMatchTime) then) =
      __$$_WordMatchTimeCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'wordMatchTimeId', required: true)
          String? wordMatchTimeId,
      @JsonKey(name: 'meetId', required: true)
          String? meetId,
      @JsonKey(name: 'contentWord')
          String? contentWord,
      @JsonKey(name: 'contentWords')
          List<String>? contentWords,
      @JsonKey(name: 'timeMs')
          int? timeMs,
      @JsonKey(name: 'timeMin')
          int? timeMin,
      @JsonKey(name: 'timeSec')
          int? timeSec,
      @JsonKey(name: 'starTimePointWithMs')
          int? starTimePointWithMs,
      @JsonKey(name: 'endTimePointWithMs')
          int? endTimePointWithMs,
      @JsonKey(name: 'soundQuality')
          String? soundQuality,
      @JsonKey(name: 'backgroundNoiseLevel')
          String? backgroundNoiseLevel});
}

/// @nodoc
class __$$_WordMatchTimeCopyWithImpl<$Res>
    extends _$WordMatchTimeCopyWithImpl<$Res, _$_WordMatchTime>
    implements _$$_WordMatchTimeCopyWith<$Res> {
  __$$_WordMatchTimeCopyWithImpl(
      _$_WordMatchTime _value, $Res Function(_$_WordMatchTime) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? wordMatchTimeId = freezed,
    Object? meetId = freezed,
    Object? contentWord = freezed,
    Object? contentWords = freezed,
    Object? timeMs = freezed,
    Object? timeMin = freezed,
    Object? timeSec = freezed,
    Object? starTimePointWithMs = freezed,
    Object? endTimePointWithMs = freezed,
    Object? soundQuality = freezed,
    Object? backgroundNoiseLevel = freezed,
  }) {
    return _then(_$_WordMatchTime(
      wordMatchTimeId: freezed == wordMatchTimeId
          ? _value.wordMatchTimeId
          : wordMatchTimeId // ignore: cast_nullable_to_non_nullable
              as String?,
      meetId: freezed == meetId
          ? _value.meetId
          : meetId // ignore: cast_nullable_to_non_nullable
              as String?,
      contentWord: freezed == contentWord
          ? _value.contentWord
          : contentWord // ignore: cast_nullable_to_non_nullable
              as String?,
      contentWords: freezed == contentWords
          ? _value._contentWords
          : contentWords // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      timeMs: freezed == timeMs
          ? _value.timeMs
          : timeMs // ignore: cast_nullable_to_non_nullable
              as int?,
      timeMin: freezed == timeMin
          ? _value.timeMin
          : timeMin // ignore: cast_nullable_to_non_nullable
              as int?,
      timeSec: freezed == timeSec
          ? _value.timeSec
          : timeSec // ignore: cast_nullable_to_non_nullable
              as int?,
      starTimePointWithMs: freezed == starTimePointWithMs
          ? _value.starTimePointWithMs
          : starTimePointWithMs // ignore: cast_nullable_to_non_nullable
              as int?,
      endTimePointWithMs: freezed == endTimePointWithMs
          ? _value.endTimePointWithMs
          : endTimePointWithMs // ignore: cast_nullable_to_non_nullable
              as int?,
      soundQuality: freezed == soundQuality
          ? _value.soundQuality
          : soundQuality // ignore: cast_nullable_to_non_nullable
              as String?,
      backgroundNoiseLevel: freezed == backgroundNoiseLevel
          ? _value.backgroundNoiseLevel
          : backgroundNoiseLevel // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_WordMatchTime with DiagnosticableTreeMixin implements _WordMatchTime {
  const _$_WordMatchTime(
      {@JsonKey(name: 'wordMatchTimeId', required: true) this.wordMatchTimeId,
      @JsonKey(name: 'meetId', required: true) this.meetId,
      @JsonKey(name: 'contentWord') this.contentWord,
      @JsonKey(name: 'contentWords') final List<String>? contentWords,
      @JsonKey(name: 'timeMs') this.timeMs,
      @JsonKey(name: 'timeMin') this.timeMin,
      @JsonKey(name: 'timeSec') this.timeSec,
      @JsonKey(name: 'starTimePointWithMs') this.starTimePointWithMs,
      @JsonKey(name: 'endTimePointWithMs') this.endTimePointWithMs,
      @JsonKey(name: 'soundQuality') this.soundQuality,
      @JsonKey(name: 'backgroundNoiseLevel') this.backgroundNoiseLevel})
      : _contentWords = contentWords;

  factory _$_WordMatchTime.fromJson(Map<String, dynamic> json) =>
      _$$_WordMatchTimeFromJson(json);

  /// Word matching time ID
  @override
  @JsonKey(name: 'wordMatchTimeId', required: true)
  final String? wordMatchTimeId;

  /// ID of the meeting where the word matching time was recorded
  @override
  @JsonKey(name: 'meetId', required: true)
  final String? meetId;

  /// The word used for the word matching time measurement
  @override
  @JsonKey(name: 'contentWord')
  final String? contentWord;

  /// List of words used for the word matching time measurement
  final List<String>? _contentWords;

  /// List of words used for the word matching time measurement
  @override
  @JsonKey(name: 'contentWords')
  List<String>? get contentWords {
    final value = _contentWords;
    if (value == null) return null;
    if (_contentWords is EqualUnmodifiableListView) return _contentWords;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  /// The time in milliseconds for the word matching time measurement
  @override
  @JsonKey(name: 'timeMs')
  final int? timeMs;

  /// The time in minutes for the word matching time measurement
  @override
  @JsonKey(name: 'timeMin')
  final int? timeMin;

  /// The time in seconds for the word matching time measurement
  @override
  @JsonKey(name: 'timeSec')
  final int? timeSec;

  /// The start time point in milliseconds for the word matching time measurement
  @override
  @JsonKey(name: 'starTimePointWithMs')
  final int? starTimePointWithMs;

  /// The end time point in milliseconds for the word matching time measurement
  @override
  @JsonKey(name: 'endTimePointWithMs')
  final int? endTimePointWithMs;

  /// The sound quality of the meeting where the word matching time was recorded
  @override
  @JsonKey(name: 'soundQuality')
  final String? soundQuality;

  /// The background noise level of the meeting where the word matching time was recorded
  @override
  @JsonKey(name: 'backgroundNoiseLevel')
  final String? backgroundNoiseLevel;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'WordMatchTime(wordMatchTimeId: $wordMatchTimeId, meetId: $meetId, contentWord: $contentWord, contentWords: $contentWords, timeMs: $timeMs, timeMin: $timeMin, timeSec: $timeSec, starTimePointWithMs: $starTimePointWithMs, endTimePointWithMs: $endTimePointWithMs, soundQuality: $soundQuality, backgroundNoiseLevel: $backgroundNoiseLevel)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'WordMatchTime'))
      ..add(DiagnosticsProperty('wordMatchTimeId', wordMatchTimeId))
      ..add(DiagnosticsProperty('meetId', meetId))
      ..add(DiagnosticsProperty('contentWord', contentWord))
      ..add(DiagnosticsProperty('contentWords', contentWords))
      ..add(DiagnosticsProperty('timeMs', timeMs))
      ..add(DiagnosticsProperty('timeMin', timeMin))
      ..add(DiagnosticsProperty('timeSec', timeSec))
      ..add(DiagnosticsProperty('starTimePointWithMs', starTimePointWithMs))
      ..add(DiagnosticsProperty('endTimePointWithMs', endTimePointWithMs))
      ..add(DiagnosticsProperty('soundQuality', soundQuality))
      ..add(DiagnosticsProperty('backgroundNoiseLevel', backgroundNoiseLevel));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_WordMatchTime &&
            (identical(other.wordMatchTimeId, wordMatchTimeId) ||
                other.wordMatchTimeId == wordMatchTimeId) &&
            (identical(other.meetId, meetId) || other.meetId == meetId) &&
            (identical(other.contentWord, contentWord) ||
                other.contentWord == contentWord) &&
            const DeepCollectionEquality()
                .equals(other._contentWords, _contentWords) &&
            (identical(other.timeMs, timeMs) || other.timeMs == timeMs) &&
            (identical(other.timeMin, timeMin) || other.timeMin == timeMin) &&
            (identical(other.timeSec, timeSec) || other.timeSec == timeSec) &&
            (identical(other.starTimePointWithMs, starTimePointWithMs) ||
                other.starTimePointWithMs == starTimePointWithMs) &&
            (identical(other.endTimePointWithMs, endTimePointWithMs) ||
                other.endTimePointWithMs == endTimePointWithMs) &&
            (identical(other.soundQuality, soundQuality) ||
                other.soundQuality == soundQuality) &&
            (identical(other.backgroundNoiseLevel, backgroundNoiseLevel) ||
                other.backgroundNoiseLevel == backgroundNoiseLevel));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      wordMatchTimeId,
      meetId,
      contentWord,
      const DeepCollectionEquality().hash(_contentWords),
      timeMs,
      timeMin,
      timeSec,
      starTimePointWithMs,
      endTimePointWithMs,
      soundQuality,
      backgroundNoiseLevel);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_WordMatchTimeCopyWith<_$_WordMatchTime> get copyWith =>
      __$$_WordMatchTimeCopyWithImpl<_$_WordMatchTime>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_WordMatchTimeToJson(
      this,
    );
  }
}

abstract class _WordMatchTime implements WordMatchTime {
  const factory _WordMatchTime(
      {@JsonKey(name: 'wordMatchTimeId', required: true)
          final String? wordMatchTimeId,
      @JsonKey(name: 'meetId', required: true)
          final String? meetId,
      @JsonKey(name: 'contentWord')
          final String? contentWord,
      @JsonKey(name: 'contentWords')
          final List<String>? contentWords,
      @JsonKey(name: 'timeMs')
          final int? timeMs,
      @JsonKey(name: 'timeMin')
          final int? timeMin,
      @JsonKey(name: 'timeSec')
          final int? timeSec,
      @JsonKey(name: 'starTimePointWithMs')
          final int? starTimePointWithMs,
      @JsonKey(name: 'endTimePointWithMs')
          final int? endTimePointWithMs,
      @JsonKey(name: 'soundQuality')
          final String? soundQuality,
      @JsonKey(name: 'backgroundNoiseLevel')
          final String? backgroundNoiseLevel}) = _$_WordMatchTime;

  factory _WordMatchTime.fromJson(Map<String, dynamic> json) =
      _$_WordMatchTime.fromJson;

  @override

  /// Word matching time ID
  @JsonKey(name: 'wordMatchTimeId', required: true)
  String? get wordMatchTimeId;
  @override

  /// ID of the meeting where the word matching time was recorded
  @JsonKey(name: 'meetId', required: true)
  String? get meetId;
  @override

  /// The word used for the word matching time measurement
  @JsonKey(name: 'contentWord')
  String? get contentWord;
  @override

  /// List of words used for the word matching time measurement
  @JsonKey(name: 'contentWords')
  List<String>? get contentWords;
  @override

  /// The time in milliseconds for the word matching time measurement
  @JsonKey(name: 'timeMs')
  int? get timeMs;
  @override

  /// The time in minutes for the word matching time measurement
  @JsonKey(name: 'timeMin')
  int? get timeMin;
  @override

  /// The time in seconds for the word matching time measurement
  @JsonKey(name: 'timeSec')
  int? get timeSec;
  @override

  /// The start time point in milliseconds for the word matching time measurement
  @JsonKey(name: 'starTimePointWithMs')
  int? get starTimePointWithMs;
  @override

  /// The end time point in milliseconds for the word matching time measurement
  @JsonKey(name: 'endTimePointWithMs')
  int? get endTimePointWithMs;
  @override

  /// The sound quality of the meeting where the word matching time was recorded
  @JsonKey(name: 'soundQuality')
  String? get soundQuality;
  @override

  /// The background noise level of the meeting where the word matching time was recorded
  @JsonKey(name: 'backgroundNoiseLevel')
  String? get backgroundNoiseLevel;
  @override
  @JsonKey(ignore: true)
  _$$_WordMatchTimeCopyWith<_$_WordMatchTime> get copyWith =>
      throw _privateConstructorUsedError;
}
