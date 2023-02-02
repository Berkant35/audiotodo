// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'worker.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Worker _$WorkerFromJson(Map<String, dynamic> json) => Worker(
      workerID: json['workerID'] as String?,
      workerName: json['workerName'] as String?,
      workerCompanyID: json['workerCompanyID'] as String?,
      workerJob: json['workerJob'] as String?,

      workerPassword: json['workerPassword'] as String?,
      workerPhoneNumber: json['workerPhoneNumber'] as String?,
      photoURL: json['photoURL'] as String?,

      isAcceptedByAdmin: json['isAcceptedByAdmin'] as bool?,
      startAtCompanyDate: json['startAtCompanyDate'] as String?,
      rootUserID: json['rootUserID'] as String?,
      typeOfUser: json['typeOfUser'] as String,
    );

Map<String, dynamic> _$WorkerToJson(Worker instance) => <String, dynamic>{
      'rootUserID': instance.rootUserID,
      'typeOfUser': instance.typeOfUser,
      'workerID': instance.workerID,
      'workerName': instance.workerName,
      'isAcceptedByAdmin': instance.isAcceptedByAdmin,
      'workerPassword': instance.workerPassword,
      'workerCompanyID': instance.workerCompanyID,
      'workerJob': instance.workerJob,
      'workerPhoneNumber': instance.workerPhoneNumber,
      'photoURL': instance.photoURL,

      'startAtCompanyDate': instance.startAtCompanyDate,
    };
