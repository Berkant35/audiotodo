
import 'package:json_annotation/json_annotation.dart';

part 'root_user.g.dart';

@JsonSerializable()
class RootUser {
  String? rootUserID;
  final String typeOfUser;

  RootUser({this.rootUserID, required this.typeOfUser});
  factory RootUser.fromJson(Map<String, dynamic> json) {
    return _$RootUserFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$RootUserToJson(this);
  }
}