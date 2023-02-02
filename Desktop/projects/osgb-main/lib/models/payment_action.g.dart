// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_action.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentAction _$PaymentActionFromJson(Map<String, dynamic> json) =>
    PaymentAction(
      paymentActionID: json['paymentActionID'] as String?,
      explain: json['explain'] as String?,
      amount: (json['amount'] as num?)?.toDouble(),
      dateTime: json['dateTime'] as String?,
    );

Map<String, dynamic> _$PaymentActionToJson(PaymentAction instance) =>
    <String, dynamic>{
      'paymentActionID': instance.paymentActionID,
      'explain': instance.explain,
      'amount': instance.amount,
      'dateTime': instance.dateTime,
    };
