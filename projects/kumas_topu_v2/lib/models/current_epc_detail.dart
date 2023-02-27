


import 'package:kumas_topu/models/epc_detail.dart';

class CurrentEpcDetail
{

  EpcDetail? epcDetail;
  String? currentEpc;

  CurrentEpcDetail({this.epcDetail, this.currentEpc});

  @override
  String toString() {
    return 'CurrentEpcDetail{epcDetail: $epcDetail, currentEpc: $currentEpc}';
  }

}