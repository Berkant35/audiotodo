


import 'package:json_annotation/json_annotation.dart';

part 'wait_fix.g.dart';

@JsonSerializable()
class WaitFix {
  final String? waitFixID;
  final String? waitFixTitle;
  final String? waitFixContent;
  final List<String>? waitFixPhotos;
  final String? waitFixDegree;
  final String? waitFixInspectionID;
  final String? waitFixExpertID;
  final String? deadlineDate;
  final String? adviceExplain;

  WaitFix(
      {this.waitFixID,
      this.waitFixTitle,
      this.waitFixContent,
      this.waitFixPhotos,
      this.waitFixDegree,
      this.waitFixInspectionID,
      required this.deadlineDate,
      required this.adviceExplain,
      this.waitFixExpertID});


  factory WaitFix.fromJson(Map<String, dynamic> json) {
    return _$WaitFixFromJson(json);
  }

  @override
  Map<String, dynamic> toJson() {
    return _$WaitFixToJson(this);
  }


}