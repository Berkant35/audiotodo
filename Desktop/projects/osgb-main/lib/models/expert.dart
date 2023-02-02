
import 'package:json_annotation/json_annotation.dart';
import 'package:osgb/models/root_user.dart';

import 'inspection.dart';

part 'expert.g.dart';

@JsonSerializable()
class Expert extends RootUser{
  final String? expertID;
  final String? expertName;
  final String? expertPhoneNumber;
  final String? expertMail;
  final String? expertMaster;
  String? photoURL;


  final List<Inspection>? inspectionList;
  String? pushToken;

  Expert(
      {
        this.expertID,
        this.expertName,
        this.expertPhoneNumber,
        this.expertMail,
        this.photoURL,
        this.inspectionList,
        this.expertMaster,
        this.pushToken,
        super.rootUserID,
        required super.typeOfUser
      });

  factory Expert.fromJson(Map<String, dynamic> json) {
    return _$ExpertFromJson(json);
  }

  @override
  Map<String, dynamic> toJson() {
    return _$ExpertToJson(this);
  }
}