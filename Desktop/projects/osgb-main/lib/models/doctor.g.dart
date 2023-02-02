// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'doctor.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Doctor _$DoctorFromJson(Map<String, dynamic> json) => Doctor(
      doctorID: json['doctorID'] as String?,
      doctorName: json['doctorName'] as String?,
      doctorPhoneNumber: json['doctorPhoneNumber'] as String?,
      doctorMail: json['doctorMail'] as String?,
      photoURL: json['photoURL'] as String?,
      pushToken: json['pushToken'] as String?,
      rootUserID: json['rootUserID'] as String?,
      typeOfUser: json['typeOfUser'] as String,
    );

Map<String, dynamic> _$DoctorToJson(Doctor instance) => <String, dynamic>{
      'rootUserID': instance.rootUserID,
      'typeOfUser': instance.typeOfUser,
      'doctorID': instance.doctorID,
      'doctorName': instance.doctorName,
      'doctorPhoneNumber': instance.doctorPhoneNumber,
      'doctorMail': instance.doctorMail,
      'pushToken': instance.pushToken,
      'photoURL': instance.photoURL,
    };
