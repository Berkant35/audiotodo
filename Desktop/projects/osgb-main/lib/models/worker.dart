

import 'package:json_annotation/json_annotation.dart';
import 'package:osgb/models/root_user.dart';
part 'worker.g.dart';


@JsonSerializable(explicitToJson: true)
class Worker extends RootUser{
  final String? workerID;
  final String? workerName;
  bool? isAcceptedByAdmin;

  final String? workerPassword;
  final String? workerCompanyID;
  final String? workerJob;
  final String? workerPhoneNumber;
  String? photoURL;

  final String? startAtCompanyDate;


  Worker(
      {
        this.workerID,
        this.workerName,
        this.workerCompanyID,
        this.workerJob,

        this.workerPassword,
        this.workerPhoneNumber,
        this.photoURL,

        this.isAcceptedByAdmin,
        this.startAtCompanyDate,
        super.rootUserID,
        required super.typeOfUser
      });

  factory Worker.fromJson(Map<String, dynamic> json) {
    return _$WorkerFromJson(json);
  }

  @override
  Map<String, dynamic> toJson() {
    return _$WorkerToJson(this);
  }
}