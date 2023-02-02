// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Admin _$AdminFromJson(Map<String, dynamic> json) => Admin(
      expertList: json['expertList'] as List<dynamic>?,
      customerList: json['customerList'] as List<dynamic>?,
      pushToken: json['pushToken'] as String?,
      inspectionList: json['inspectionList'] as List<dynamic>?,
      accidentCaseList: json['accidentCaseList'] as List<dynamic>?,
      wishList: json['wishList'] as List<dynamic>?,
      paymentList: json['paymentList'] as List<dynamic>?,
      rootUserID: json['rootUserID'] as String?,
      typeOfUser: json['typeOfUser'] as String,
    );

Map<String, dynamic> _$AdminToJson(Admin instance) => <String, dynamic>{
      'rootUserID': instance.rootUserID,
      'typeOfUser': instance.typeOfUser,
      'pushToken': instance.pushToken,
      'customerList': instance.customerList,
      'expertList': instance.expertList,
      'inspectionList': instance.inspectionList,
      'accidentCaseList': instance.accidentCaseList,
      'wishList': instance.wishList,
      'paymentList': instance.paymentList,
    };
