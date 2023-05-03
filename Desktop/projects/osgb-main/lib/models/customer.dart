import 'package:json_annotation/json_annotation.dart';
import 'package:osgb/models/doctor.dart';
import 'package:osgb/models/expert.dart';
import 'package:osgb/models/root_user.dart';
import 'package:osgb/models/worker.dart';

import '../utilities/constants/app/enums.dart';
import 'accident_case.dart';
import 'inspection.dart';

part 'customer.g.dart';

@JsonSerializable()
class Customer extends RootUser {
  final String? customerID;
  final String? customerName;
  final String? customerCity;
  final String? customerDistrict;
  final String? customerSector;
  final String? customerAddress;
  final String? customerPhoneNumber;
  final String? representativePerson;
  final String? representativePersonPhone;
  final String? purserName;
  final String? dangerLevel;
  final String? purserPhoneNumber;
  final String? email;
  final String? password;
  String? photoURL;
  String? qrCodeURL;
  final String? dailyPeriod;
  final String? companyDetectNumber;
  final dynamic definedExpert;
  final dynamic definedDoctor;
  final bool? stateOfCompany;
  final List<Worker>? workerList;
  final List<Inspection>? inspectionList;
  final List<AccidentCase>? accidentCaseList;
  String? pushToken;

  Customer(
      {this.customerID,
      this.customerName,
      this.customerCity,
      this.customerDistrict,
      this.customerSector,
      this.customerAddress,
      this.dailyPeriod,
      this.definedExpert,
      this.companyDetectNumber,
      this.definedDoctor,
      this.customerPhoneNumber,
      this.representativePerson,
      this.representativePersonPhone,
      this.purserName,
      this.stateOfCompany,
      this.purserPhoneNumber,
      this.dangerLevel,
      this.qrCodeURL,
      this.photoURL,
      this.workerList,
      this.inspectionList,
      this.accidentCaseList,
      this.email,
      this.password,
      this.pushToken,
      super.rootUserID,
      required super.typeOfUser});

  factory Customer.fromJson(Map<String, dynamic> json) {
    return _$CustomerFromJson(json);
  }

  @override
  Map<String, dynamic> toJson() {
    return _$CustomerToJson(this);
  }
}
