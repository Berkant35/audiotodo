

import 'package:json_annotation/json_annotation.dart';
import 'package:osgb/models/root_user.dart';

part 'search_user.g.dart';


@JsonSerializable()
class SearchUser extends RootUser {
  final String? userName;
  final String? role;

  SearchUser({
    this.userName,
    this.role,
    super.rootUserID,
    required super.typeOfUser
  });

  factory SearchUser.fromJson(Map<String, dynamic> json) {
    return _$SearchUserFromJson(json);
  }

  @override
  Map<String, dynamic> toJson() {
    return _$SearchUserToJson(this);
  }
}