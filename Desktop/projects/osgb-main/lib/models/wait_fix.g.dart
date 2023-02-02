// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wait_fix.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WaitFix _$WaitFixFromJson(Map<String, dynamic> json) => WaitFix(
      waitFixID: json['waitFixID'] as String?,
      waitFixTitle: json['waitFixTitle'] as String?,
      waitFixContent: json['waitFixContent'] as String?,
      waitFixPhotos: (json['waitFixPhotos'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      waitFixDegree: json['waitFixDegree'] as String?,
      waitFixInspectionID: json['waitFixInspectionID'] as String?,
      deadlineDate: json['deadlineDate'] as String?,
      adviceExplain: json['adviceExplain'] as String?,
      waitFixExpertID: json['waitFixExpertID'] as String?,
    );

Map<String, dynamic> _$WaitFixToJson(WaitFix instance) => <String, dynamic>{
      'waitFixID': instance.waitFixID,
      'waitFixTitle': instance.waitFixTitle,
      'waitFixContent': instance.waitFixContent,
      'waitFixPhotos': instance.waitFixPhotos,
      'waitFixDegree': instance.waitFixDegree,
      'waitFixInspectionID': instance.waitFixInspectionID,
      'waitFixExpertID': instance.waitFixExpertID,
      'deadlineDate': instance.deadlineDate,
      'adviceExplain': instance.adviceExplain,
    };
