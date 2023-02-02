


import 'package:json_annotation/json_annotation.dart';
import 'package:osgb/models/payment.dart';

import 'root_user.dart';

part 'accountant.g.dart';

@JsonSerializable()
class Accountant extends RootUser {
  final String? accountantName;
  final String? accountantEmail;
  String? photoURL;
  final String? accountantPhoneNumber;
  String? pushToken;
  final List<Payment>? paymentList;


  Accountant({
    this.paymentList,
    this.accountantName,
    this.accountantEmail,
    this.accountantPhoneNumber,
    this.photoURL,
    this.pushToken,
    super.rootUserID,
    required super.typeOfUser,
  });

  factory Accountant.fromJson(Map<String, dynamic> json) {
    return _$AccountantFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$AccountantToJson(this);
  }
}