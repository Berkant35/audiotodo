

import 'package:json_annotation/json_annotation.dart';

part 'monthly.g.dart';

@JsonSerializable()
class Monthly {
  String? monthName;
  double? amountOfWaiting;
  double? amountOfDone;
  List<dynamic>? paymentActionList;

  Monthly(
      {this.monthName,
      this.amountOfWaiting,
      this.amountOfDone,
      required this.paymentActionList
      });

  factory Monthly.fromJson(Map<String, dynamic> json) {
    return _$MonthlyFromJson(json);
  }


  Map<String, dynamic> toJson() {
    return _$MonthlyToJson(this);
  }
}