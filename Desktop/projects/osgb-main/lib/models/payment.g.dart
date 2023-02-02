// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Payment _$PaymentFromJson(Map<String, dynamic> json) => Payment(
      paymentID: json['paymentID'] as String?,
      customerID: json['customerID'] as String?,
      paymentYearList: json['paymentYearList'] as List<dynamic>?,
      workerCount: json['workerCount'] as int?,
      currentInspectionCount: json['currentInspectionCount'] as int?,
    );

Map<String, dynamic> _$PaymentToJson(Payment instance) => <String, dynamic>{
      'paymentID': instance.paymentID,
      'customerID': instance.customerID,
      'paymentYearList': instance.paymentYearList,
      'workerCount': instance.workerCount,
      'currentInspectionCount': instance.currentInspectionCount,
    };
