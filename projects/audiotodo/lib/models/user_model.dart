import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

typedef TodoPlatformTokens = Map<String,String>;

@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    String? userId,
    String? email,
    String? userName,
    String? surName,
    String? companyName,
    String? companyId,
    String? platform,
    String? lastSignIn,
    bool? firstEnter,
    String? pushToken,
    List<String>? friendIdList,

    TodoPlatformTokens? todoPlatformTokens,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, Object?> json) => _$UserModelFromJson(json);
}
