import 'package:kumas_topu/models/encode_standarts.dart';

class BarcodeInfo {
  String? barcodeInfo;
  String? barcodeType;
  String? barcodeErrorCode;
  String? timeout;
  PerStandart? perStandart;
  String? epc;
  String? tid;
  String? userData;
  String? password;

  BarcodeInfo(
      {this.barcodeInfo,
      this.barcodeType,
      this.barcodeErrorCode,
      this.timeout,
      this.perStandart,
      this.tid,
      this.userData,
      this.password,
      this.epc});

  BarcodeInfo.fromJson(Map<String, dynamic> json) {
    barcodeInfo = json['barcodeInfo'];
    barcodeType = json['barcodeType'];
    barcodeErrorCode = json['barcodeErrorCode'];
    timeout = json['timeout'];
    perStandart = json['perStandart'];
    userData = json['userData'];
    tid = json['tid'];
    password = json['password'];
    epc = json['epc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['barcodeInfo'] = barcodeInfo;
    data['barcodeType'] = barcodeType;
    data['barcodeErrorCode'] = barcodeErrorCode;
    data['timeout'] = timeout;
    data['perStandart'] = perStandart;
    data['userData'] = userData;
    data['tid'] = tid;
    data['password'] = password;
    data['epc'] = epc;
    return data;
  }
}
