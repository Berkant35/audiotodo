

import 'package:json_annotation/json_annotation.dart';
import 'package:osgb/models/root_user.dart';

part 'doctor.g.dart';

@JsonSerializable()
class Doctor extends RootUser{
  final String? doctorID;
  final String? doctorName;
  final String? doctorPhoneNumber;
  final String? doctorMail;
  String? pushToken;
  String? photoURL;

  Doctor({
    this.doctorID,
    this.doctorName,
    this.doctorPhoneNumber,
    this.doctorMail,
    this.photoURL,
    this.pushToken,
    super.rootUserID,
    required super.typeOfUser,

  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return _$DoctorFromJson(json);
  }

  @override
  Map<String, dynamic> toJson() {
    return _$DoctorToJson(this);
  }
}