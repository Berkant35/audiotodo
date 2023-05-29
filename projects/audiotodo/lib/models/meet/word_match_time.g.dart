// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'word_match_time.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_WordMatchTime _$$_WordMatchTimeFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['wordMatchTimeId', 'meetId'],
  );
  return _$_WordMatchTime(
    wordMatchTimeId: json['wordMatchTimeId'] as String?,
    meetId: json['meetId'] as String?,
    contentWord: json['contentWord'] as String?,
    contentWords: (json['contentWords'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    timeMs: json['timeMs'] as int?,
    timeMin: json['timeMin'] as int?,
    timeSec: json['timeSec'] as int?,
    starTimePointWithMs: json['starTimePointWithMs'] as int?,
    endTimePointWithMs: json['endTimePointWithMs'] as int?,
    soundQuality: json['soundQuality'] as String?,
    backgroundNoiseLevel: json['backgroundNoiseLevel'] as String?,
  );
}

Map<String, dynamic> _$$_WordMatchTimeToJson(_$_WordMatchTime instance) =>
    <String, dynamic>{
      'wordMatchTimeId': instance.wordMatchTimeId,
      'meetId': instance.meetId,
      'contentWord': instance.contentWord,
      'contentWords': instance.contentWords,
      'timeMs': instance.timeMs,
      'timeMin': instance.timeMin,
      'timeSec': instance.timeSec,
      'starTimePointWithMs': instance.starTimePointWithMs,
      'endTimePointWithMs': instance.endTimePointWithMs,
      'soundQuality': instance.soundQuality,
      'backgroundNoiseLevel': instance.backgroundNoiseLevel,
    };
