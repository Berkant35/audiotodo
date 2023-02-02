


import 'package:json_annotation/json_annotation.dart';
import 'package:osgb/models/monthly.dart';


part 'yearly.g.dart';

@JsonSerializable()
class Yearly{
  final String? customerID;
  final int? currentYear;
  List<dynamic>? monthlyList;
  final double? currentPay;
  final double? waitingPay;

  Yearly(
      {
        this.customerID,
        this.currentYear,
        this.currentPay,
        this.monthlyList,
        this.waitingPay});

  factory Yearly.fromJson(Map<String, dynamic> json) {
    return _$YearlyFromJson(json);
  }

  @override
  Map<String, dynamic> toJson() {
    return _$YearlyToJson(this);
  }
}