// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchUser _$SearchUserFromJson(Map<String, dynamic> json) => SearchUser(
      userName: json['userName'] as String?,
      role: json['role'] as String?,
      rootUserID: json['rootUserID'] as String?,
      typeOfUser: json['typeOfUser'] as String,
    );

Map<String, dynamic> _$SearchUserToJson(SearchUser instance) =>
    <String, dynamic>{
      'rootUserID': instance.rootUserID,
      'typeOfUser': instance.typeOfUser,
      'userName': instance.userName,
      'role': instance.role,
    };
