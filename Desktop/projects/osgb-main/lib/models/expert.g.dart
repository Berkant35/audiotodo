// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expert.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Expert _$ExpertFromJson(Map<String, dynamic> json) => Expert(
      expertID: json['expertID'] as String?,
      expertName: json['expertName'] as String?,
      expertPhoneNumber: json['expertPhoneNumber'] as String?,
      expertMail: json['expertMail'] as String?,
      photoURL: json['photoURL'] as String?,
      inspectionList: (json['inspectionList'] as List<dynamic>?)
          ?.map((e) => Inspection.fromJson(e as Map<String, dynamic>))
          .toList(),
      expertMaster: json['expertMaster'] as String?,
      pushToken: json['pushToken'] as String?,
      rootUserID: json['rootUserID'] as String?,
      typeOfUser: json['typeOfUser'] as String,
    );

Map<String, dynamic> _$ExpertToJson(Expert instance) => <String, dynamic>{
      'rootUserID': instance.rootUserID,
      'typeOfUser': instance.typeOfUser,
      'expertID': instance.expertID,
      'expertName': instance.expertName,
      'expertPhoneNumber': instance.expertPhoneNumber,
      'expertMail': instance.expertMail,
      'expertMaster': instance.expertMaster,
      'photoURL': instance.photoURL,
      'inspectionList': instance.inspectionList,
      'pushToken': instance.pushToken,
    };
