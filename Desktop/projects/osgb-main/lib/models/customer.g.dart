// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Customer _$CustomerFromJson(Map<String, dynamic> json) => Customer(
      customerID: json['customerID'] as String?,
      customerName: json['customerName'] as String?,
      customerCity: json['customerCity'] as String?,
      customerDistrict: json['customerDistrict'] as String?,
      customerSector: json['customerSector'] as String?,
      customerAddress: json['customerAddress'] as String?,
      dailyPeriod: json['dailyPeriod'] as String?,
      definedExpert: json['definedExpert'],
      companyDetectNumber: json['companyDetectNumber'] as String?,
      definedDoctor: json['definedDoctor'],
      customerPhoneNumber: json['customerPhoneNumber'] as String?,
      representativePerson: json['representativePerson'] as String?,
      representativePersonPhone: json['representativePersonPhone'] as String?,
      purserName: json['purserName'] as String?,
      purserPhoneNumber: json['purserPhoneNumber'] as String?,
      stateOfCompany: json['stateOfCompany'] as bool?,
      dangerLevel: json['dangerLevel'] as String?,
      qrCodeURL: json['qrCodeURL'] as String?,
      photoURL: json['photoURL'] as String?,
      workerList: (json['workerList'] as List<dynamic>?)
          ?.map((e) => Worker.fromJson(e as Map<String, dynamic>))
          .toList(),
      inspectionList: (json['inspectionList'] as List<dynamic>?)
          ?.map((e) => Inspection.fromJson(e as Map<String, dynamic>))
          .toList(),
      accidentCaseList: (json['accidentCaseList'] as List<dynamic>?)
          ?.map((e) => AccidentCase.fromJson(e as Map<String, dynamic>))
          .toList(),
      email: json['email'] as String?,
      password: json['password'] as String?,
      pushToken: json['pushToken'] as String?,
      rootUserID: json['rootUserID'] as String?,
      typeOfUser: json['typeOfUser'] as String,
    );

Map<String, dynamic> _$CustomerToJson(Customer instance) => <String, dynamic>{
      'rootUserID': instance.rootUserID,
      'typeOfUser': instance.typeOfUser,
      'customerID': instance.customerID,
      'customerName': instance.customerName,
      'customerCity': instance.customerCity,
      'customerDistrict': instance.customerDistrict,
      'customerSector': instance.customerSector,
      'customerAddress': instance.customerAddress,
      'stateOfCompany': instance.stateOfCompany ?? true,
      'customerPhoneNumber': instance.customerPhoneNumber,
      'representativePerson': instance.representativePerson,
      'representativePersonPhone': instance.representativePersonPhone,
      'purserName': instance.purserName,
      'dangerLevel': instance.dangerLevel,
      'purserPhoneNumber': instance.purserPhoneNumber,
      'email': instance.email,
      'password': instance.password,
      'photoURL': instance.photoURL,
      'qrCodeURL': instance.qrCodeURL,
      'dailyPeriod': instance.dailyPeriod,
      'companyDetectNumber': instance.companyDetectNumber,
      'definedExpert': instance.definedExpert,
      'definedDoctor': instance.definedDoctor,
      'workerList': instance.workerList,
      'inspectionList': instance.inspectionList,
      'accidentCaseList': instance.accidentCaseList,
      'pushToken': instance.pushToken,
    };
