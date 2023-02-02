import 'package:osgb/models/admin.dart';
import 'package:osgb/models/doctor.dart';

import 'accountant.dart';
import 'customer.dart';
import 'expert.dart';

class BaseUserModel {
  final Admin? admin;
  final Expert? expert;
  final Accountant? accountant;
  final Customer? customer;
  final Doctor? doctor;

  BaseUserModel(
      {this.admin, this.expert, this.accountant, this.customer, this.doctor});
}
