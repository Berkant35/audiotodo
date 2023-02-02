// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'accountant.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Accountant _$AccountantFromJson(Map<String, dynamic> json) => Accountant(
      paymentList: (json['paymentList'] as List<dynamic>?)
          ?.map((e) => Payment.fromJson(e as Map<String, dynamic>))
          .toList(),
      accountantName: json['accountantName'] as String?,
      accountantEmail: json['accountantEmail'] as String?,
      accountantPhoneNumber: json['accountantPhoneNumber'] as String?,
      photoURL: json['photoURL'] as String?,
      pushToken: json['pushToken'] as String?,
      rootUserID: json['rootUserID'] as String?,
      typeOfUser: json['typeOfUser'] as String,
    );

Map<String, dynamic> _$AccountantToJson(Accountant instance) =>
    <String, dynamic>{
      'rootUserID': instance.rootUserID,
      'typeOfUser': instance.typeOfUser,
      'accountantName': instance.accountantName,
      'accountantEmail': instance.accountantEmail,
      'photoURL': instance.photoURL,
      'accountantPhoneNumber': instance.accountantPhoneNumber,
      'pushToken': instance.pushToken,
      'paymentList': instance.paymentList,
    };
