// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'yearly.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Yearly _$YearlyFromJson(Map<String, dynamic> json) => Yearly(
      customerID: json['customerID'] as String?,
      currentYear: json['currentYear'] as int?,
      currentPay: (json['currentPay'] as num?)?.toDouble(),
      monthlyList: json['monthlyList'] as List<dynamic>?,
      waitingPay: (json['waitingPay'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$YearlyToJson(Yearly instance) => <String, dynamic>{
      'customerID': instance.customerID,
      'currentYear': instance.currentYear,
      'monthlyList': instance.monthlyList,
      'currentPay': instance.currentPay,
      'waitingPay': instance.waitingPay,
    };
