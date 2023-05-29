// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meet_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Meet _$$_MeetFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['meetId'],
  );
  return _$_Meet(
    meetId: json['meetId'] as String?,
    meetTitle: json['meetTitle'] as String?,
    meetSubtitle: json['meetSubtitle'] as String?,
    meetCategory: json['meetCategory'] as String?,
    meetContent: json['meetContent'] as String?,
    meetLocaleFile: json['meetLocaleFile'] as String?,
    meetDueDate: json['meetDueDate'] as String?,
    createdAt: json['createdAt'] as String?,
    userId: json['userId'] as String?,
    createdPdfFile: json['createdPdfFile'] as bool? ?? false,
    createdWordFile: json['createdWordFile'] as bool? ?? false,
    recordTimeMin: json['recordTimeMin'] as int?,
    recordTimeMs: json['recordTimeMs'] as int?,
    contentWordCount: json['contentWordCount'] as int?,
    soundFileLink: json['soundFileLink'] as String?,
    soundFileType: json['soundFileType'] as String?,
    lang: json['lang'] as String?,
  );
}

Map<String, dynamic> _$$_MeetToJson(_$_Meet instance) => <String, dynamic>{
      'meetId': instance.meetId,
      'meetTitle': instance.meetTitle,
      'meetSubtitle': instance.meetSubtitle,
      'meetCategory': instance.meetCategory,
      'meetContent': instance.meetContent,
      'meetLocaleFile': instance.meetLocaleFile,
      'meetDueDate': instance.meetDueDate,
      'createdAt': instance.createdAt,
      'userId': instance.userId,
      'createdPdfFile': instance.createdPdfFile,
      'createdWordFile': instance.createdWordFile,
      'recordTimeMin': instance.recordTimeMin,
      'recordTimeMs': instance.recordTimeMs,
      'contentWordCount': instance.contentWordCount,
      'soundFileLink': instance.soundFileLink,
      'soundFileType': instance.soundFileType,
      'lang': instance.lang,
    };
