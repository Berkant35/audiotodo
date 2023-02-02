// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'demand.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DemandWorker _$DemandWorkerFromJson(Map<String, dynamic> json) => DemandWorker(
      demandID: json['demandID'] as String?,
      demandByCustomer: json['demandByCustomer'] == null
          ? null
          : Customer.fromJson(json['demandByCustomer'] as Map<String, dynamic>),
      demandWorker: json['demandWorker'] == null
          ? null
          : Worker.fromJson(json['demandWorker'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DemandWorkerToJson(DemandWorker instance) =>
    <String, dynamic>{
      'demandID': instance.demandID,
      'demandByCustomer': instance.demandByCustomer,
      'demandWorker': instance.demandWorker,
    };
