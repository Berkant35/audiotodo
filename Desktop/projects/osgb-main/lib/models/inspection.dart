

import 'package:json_annotation/json_annotation.dart';
import 'package:osgb/models/wait_fix.dart';

import 'customer.dart';
import 'expert.dart';
part 'inspection.g.dart';


@JsonSerializable()
class Inspection {
  final String? inspectionID;
  final String? customerID;
  final String? customerName;
  final String? customerPresentationName;
  final String? customerAddress;
  final String? customerSector;
  final String? customerPushToken;
  final String? customerPhotoURL;
  final String? expertID;
  final String? expertName;
  final String? doctorID;
  final String? doctorName;
  final String? inspectionExplain;
  final String? inspectionTitle;
  final String? dangerLevelOfCustomer;
  final String? inspectionDate;
  final bool? inspectionIsStarted;
  final int? currentHasMustFixCount;
  final int? workerCount;
  int? highDanger;
  int? normalDanger;
  int? lowDanger;
  final List<dynamic>? waitFixList;
  final bool? inspectionIsDone;

  Inspection(
      {
      required this.inspectionID,
      required this.customerID,
      required this.doctorID,
      required this.expertID,
      required this.customerPresentationName,
      required this.customerAddress,
      required this.customerSector,
      required this.dangerLevelOfCustomer,
      this.workerCount,
      this.inspectionDate,
      this.doctorName,
      this.customerName,
      this.customerPushToken,
      this.customerPhotoURL,
      this.lowDanger,
      this.normalDanger,
      this.highDanger,
      this.inspectionTitle,
      this.expertName,
      this.inspectionExplain,
      this.inspectionIsStarted,
      this.currentHasMustFixCount,
      this.waitFixList,
      this.inspectionIsDone});
  factory Inspection.fromJson(Map<String, dynamic> json) {
    return _$InspectionFromJson(json);
  }

  @override
  Map<String, dynamic> toJson() {
    return _$InspectionToJson(this);
  }
}