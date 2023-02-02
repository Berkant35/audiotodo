// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'monthly.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Monthly _$MonthlyFromJson(Map<String, dynamic> json) => Monthly(
      monthName: json['monthName'] as String?,
      amountOfWaiting: (json['amountOfWaiting'] as num?)?.toDouble(),
      amountOfDone: (json['amountOfDone'] as num?)?.toDouble(),
      paymentActionList: json['paymentActionList'] as List<dynamic>?,
    );

Map<String, dynamic> _$MonthlyToJson(Monthly instance) => <String, dynamic>{
      'monthName': instance.monthName,
      'amountOfWaiting': instance.amountOfWaiting,
      'amountOfDone': instance.amountOfDone,
      'paymentActionList': instance.paymentActionList,
    };
