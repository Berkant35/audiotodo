



import 'package:json_annotation/json_annotation.dart';

part 'payment_action.g.dart';

@JsonSerializable()
class PaymentAction {
  String? paymentActionID;
  String? explain;
  double? amount;
  String? dateTime;

  PaymentAction(
      {this.paymentActionID, this.explain, this.amount, this.dateTime});

  factory PaymentAction.fromJson(Map<String, dynamic> json) {
    return _$PaymentActionFromJson(json);
  }


  Map<String, dynamic> toJson() {
    return _$PaymentActionToJson(this);
  }

}