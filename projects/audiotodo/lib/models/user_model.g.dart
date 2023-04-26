// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_UserModel _$$_UserModelFromJson(Map<String, dynamic> json) => _$_UserModel(
      userId: json['userId'] as String?,
      email: json['email'] as String?,
      userName: json['userName'] as String?,
      surName: json['surName'] as String?,
      companyName: json['companyName'] as String?,
      companyId: json['companyId'] as String?,
      platform: json['platform'] as String?,
      lastSignIn: json['lastSignIn'] as String?,
      firstEnter: json['firstEnter'] as bool?,
      pushToken: json['pushToken'] as String?,
      friendIdList: (json['friendIdList'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      todoPlatformTokens:
          (json['todoPlatformTokens'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
    );

Map<String, dynamic> _$$_UserModelToJson(_$_UserModel instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'email': instance.email,
      'userName': instance.userName,
      'surName': instance.surName,
      'companyName': instance.companyName,
      'companyId': instance.companyId,
      'platform': instance.platform,
      'lastSignIn': instance.lastSignIn,
      'firstEnter': instance.firstEnter,
      'pushToken': instance.pushToken,
      'friendIdList': instance.friendIdList,
      'todoPlatformTokens': instance.todoPlatformTokens,
    };
