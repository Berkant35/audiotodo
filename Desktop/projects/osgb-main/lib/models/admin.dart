import 'package:json_annotation/json_annotation.dart';

import 'package:osgb/models/root_user.dart';




part 'admin.g.dart';

@JsonSerializable()
class Admin extends RootUser {
  String? pushToken;

  final List<dynamic>? customerList;
  final List<dynamic>? expertList;
  final List<dynamic>? inspectionList;
  final List<dynamic>? accidentCaseList;
  final List<dynamic>? wishList;
  final List<dynamic>? paymentList;

  Admin({
    this.expertList,
    this.customerList,
    this.pushToken,
    this.inspectionList,
    this.accidentCaseList,
    this.wishList,
    this.paymentList,
    super.rootUserID,
    required super.typeOfUser,
  });

  factory Admin.fromJson(Map<String, dynamic> json) {
    return _$AdminFromJson(json);
  }

  @override
  Map<String, dynamic> toJson() {
    return _$AdminToJson(this);
  }
}
