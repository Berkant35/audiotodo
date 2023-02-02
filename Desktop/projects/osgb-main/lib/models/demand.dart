
import 'package:json_annotation/json_annotation.dart';
import 'package:osgb/models/worker.dart';

import 'customer.dart';

part 'demand.g.dart';

@JsonSerializable()
class DemandWorker {
  final String? demandID;
  Customer? demandByCustomer;
  Worker? demandWorker;

  DemandWorker({
    this.demandID,
    this.demandByCustomer,
    this.demandWorker});

  factory DemandWorker.fromJson(Map<String, dynamic> json) {
    return _$DemandWorkerFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$DemandWorkerToJson(this);
  }


}