
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
part 'word_match_time.freezed.dart';
part 'word_match_time.g.dart';

@freezed
class WordMatchTime with _$WordMatchTime {
  /// Word matching time class
  const factory WordMatchTime({
    /// Word matching time ID
    @JsonKey(name: 'wordMatchTimeId',required: true) String? wordMatchTimeId,
    /// ID of the meeting where the word matching time was recorded
    @JsonKey(name: 'meetId',required: true) String? meetId,
    /// The word used for the word matching time measurement
    @JsonKey(name: 'contentWord') String? contentWord,
    /// List of words used for the word matching time measurement
    @JsonKey(name: 'contentWords') List<String>? contentWords,
    /// The time in milliseconds for the word matching time measurement
    @JsonKey(name: 'timeMs') int? timeMs,
    /// The time in minutes for the word matching time measurement
    @JsonKey(name: 'timeMin') int? timeMin,
    /// The time in seconds for the word matching time measurement
    @JsonKey(name: 'timeSec') int? timeSec,
    /// The start time point in milliseconds for the word matching time measurement
    @JsonKey(name: 'starTimePointWithMs') int? starTimePointWithMs,
    /// The end time point in milliseconds for the word matching time measurement
    @JsonKey(name: 'endTimePointWithMs') int? endTimePointWithMs,
    /// The sound quality of the meeting where the word matching time was recorded
    @JsonKey(name: 'soundQuality') String? soundQuality,
    /// The background noise level of the meeting where the word matching time was recorded
    @JsonKey(name: 'backgroundNoiseLevel') String? backgroundNoiseLevel,
  }) = _WordMatchTime;

  /// Convert the given JSON object to a [WordMatchTime] instance.
  factory WordMatchTime.fromJson(Map<String, Object?> json) =>
      _$WordMatchTimeFromJson(json);
}

