// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inspection.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Inspection _$InspectionFromJson(Map<String, dynamic> json) => Inspection(
      inspectionID: json['inspectionID'] as String?,
      customerID: json['customerID'] as String?,
      doctorID: json['doctorID'] as String?,
      expertID: json['expertID'] as String?,
      customerPresentationName: json['customerPresentationName'] as String?,
      customerAddress: json['customerAddress'] as String?,
      customerSector: json['customerSector'] as String?,
      dangerLevelOfCustomer: json['dangerLevelOfCustomer'] as String?,
      workerCount: json['workerCount'] as int?,
      inspectionDate: json['inspectionDate'] as String?,
      createdDate: json['createdDate'] as String?,
      updatedDate: json['updatedDate'] as String?,
      doctorName: json['doctorName'] as String?,
      customerName: json['customerName'] as String?,
      customerPushToken: json['customerPushToken'] as String?,
      customerPhotoURL: json['customerPhotoURL'] as String?,
      lowDanger: json['lowDanger'] as int?,
      normalDanger: json['normalDanger'] as int?,
      highDanger: json['highDanger'] as int?,
      inspectionTitle: json['inspectionTitle'] as String?,
      expertName: json['expertName'] as String?,
      inspectionExplain: json['inspectionExplain'] as String?,
      inspectionIsStarted: json['inspectionIsStarted'] as bool?,
      currentHasMustFixCount: json['currentHasMustFixCount'] as int?,
      waitFixList: json['waitFixList'] as List<dynamic>?,
      inspectionIsDone: json['inspectionIsDone'] as bool?,
    );

Map<String, dynamic> _$InspectionToJson(Inspection instance) =>
    <String, dynamic>{
      'inspectionID': instance.inspectionID,
      'customerID': instance.customerID,
      'customerName': instance.customerName,
      'customerPresentationName': instance.customerPresentationName,
      'customerAddress': instance.customerAddress,
      'customerSector': instance.customerSector,
      'customerPushToken': instance.customerPushToken,
      'customerPhotoURL': instance.customerPhotoURL,
      'expertID': instance.expertID,
      'expertName': instance.expertName,
      'doctorID': instance.doctorID,
      'doctorName': instance.doctorName,
      'inspectionExplain': instance.inspectionExplain,
      'inspectionTitle': instance.inspectionTitle,
      'dangerLevelOfCustomer': instance.dangerLevelOfCustomer,
      'inspectionDate': instance.inspectionDate,
      'createdDate': instance.createdDate ?? DateTime.now().toString().substring(0,16),
      'updatedDate': instance.updatedDate ?? DateTime.now().toString().substring(0,16),
      'inspectionIsStarted': instance.inspectionIsStarted,
      'currentHasMustFixCount': instance.currentHasMustFixCount,
      'workerCount': instance.workerCount,
      'highDanger': instance.highDanger,
      'normalDanger': instance.normalDanger,
      'lowDanger': instance.lowDanger,
      'waitFixList': instance.waitFixList,
      'inspectionIsDone': instance.inspectionIsDone,
    };
