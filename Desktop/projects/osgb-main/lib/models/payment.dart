
import 'package:json_annotation/json_annotation.dart';
import 'package:osgb/models/yearly.dart';

part 'payment.g.dart';

@JsonSerializable()
class Payment {
  final String? paymentID;
  final String? customerID;
  List<dynamic>? paymentYearList;
  final int? workerCount;
  final int? currentInspectionCount;

  Payment(
      {this.paymentID,
      this.customerID,
      this.paymentYearList,
      this.workerCount,
      this.currentInspectionCount});

  factory Payment.fromJson(Map<String, dynamic> json) {
    return _$PaymentFromJson(json);
  }


  Map<String, dynamic> toJson() {
    return _$PaymentToJson(this);
  }
}