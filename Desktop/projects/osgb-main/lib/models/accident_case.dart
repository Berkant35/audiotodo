
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:osgb/models/worker.dart';

part 'accident_case.g.dart';

@JsonSerializable()
class AccidentCase {
  final String? caseID;
  final String? caseCompanyID;
  final String? caseCompanyName;
  final String? caseCompanyEmail;
  final String? caseCompanyPhone;
  final String? caseCompanyPresentationPersonPhoneNumber;
  final String? caseName;
  final String? caseContent;
  final String? caseDate;
  final String? affectedExplain;
  final bool? caseConfirmedByAdmin;
  final List<dynamic>? caseAffectedWorkerList;
  final List<dynamic>? casePhotos;


  AccidentCase(
      {this.caseID,
      this.caseCompanyID,
      this.caseName,
      this.caseContent,
      this.affectedExplain,
      this.caseDate,
      required this.caseCompanyName,
      required this.caseCompanyEmail,
      required this.caseCompanyPhone,
      required this.caseCompanyPresentationPersonPhoneNumber,
      this.caseConfirmedByAdmin,
      this.caseAffectedWorkerList,
      this.casePhotos});

  factory AccidentCase.fromJson(Map<String, dynamic> json) {
    return _$AccidentCaseFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$AccidentCaseToJson(this);
  }


}