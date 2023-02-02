// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'accident_case.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccidentCase _$AccidentCaseFromJson(Map<String, dynamic> json) => AccidentCase(
      caseID: json['caseID'] as String?,
      caseCompanyID: json['caseCompanyID'] as String?,
      caseName: json['caseName'] as String?,
      caseContent: json['caseContent'] as String?,
      caseDate: json['caseDate'] as String?,
      caseCompanyName: json['caseCompanyName'] as String?,
      caseCompanyEmail: json['caseCompanyEmail'] as String?,
      affectedExplain: json['affectedExplain'] as String?,
      caseCompanyPhone: json['caseCompanyPhone'] as String?,
      caseCompanyPresentationPersonPhoneNumber:
          json['caseCompanyPresentationPersonPhoneNumber'] as String?,
      caseConfirmedByAdmin: json['caseConfirmedByAdmin'] as bool?,
      caseAffectedWorkerList: json['caseAffectedWorkerList'] as List<dynamic>?,
      casePhotos: json['casePhotos'] as List<dynamic>?,
    );

Map<String, dynamic> _$AccidentCaseToJson(AccidentCase instance) =>
    <String, dynamic>{
      'caseID': instance.caseID,
      'caseCompanyID': instance.caseCompanyID,
      'caseCompanyName': instance.caseCompanyName,
      'affectedExplain': instance.affectedExplain ?? "Etkilenen Bir Çalışan Yok",
      'caseCompanyEmail': instance.caseCompanyEmail,
      'caseCompanyPhone': instance.caseCompanyPhone,
      'caseCompanyPresentationPersonPhoneNumber':
          instance.caseCompanyPresentationPersonPhoneNumber,
      'caseName': instance.caseName,
      'caseContent': instance.caseContent,
      'caseDate': instance.caseDate,
      'caseConfirmedByAdmin': instance.caseConfirmedByAdmin,
      'caseAffectedWorkerList': instance.caseAffectedWorkerList,
      'casePhotos': instance.casePhotos,
    };
