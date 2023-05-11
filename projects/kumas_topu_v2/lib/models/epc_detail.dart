import 'err.dart';


class EpcDetail {
  bool? status;
  int? code;
  Data? data;
  Err? err;

  EpcDetail({this.status, this.code, this.data, this.err});

  EpcDetail.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    err = json['err'] != null ? Err.fromJson(json['err']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['code'] = code;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['err'] = err;
    return data;
  }
}

class Data {
  String? epc;
  String? companyName;
  String? userBank;
  String? tid;
  String? supplierId;
  String? deviceName;
  String? deviceIp;
  String? recordDate;
  String? recordUser;
  String? barcode;

  Data(
      {this.epc,
        this.companyName,
        this.userBank,
        this.tid,
        this.supplierId,
        this.deviceName,
        this.deviceIp,
        this.recordDate,
        this.barcode,
        this.recordUser});

  Data.fromJson(Map<String, dynamic> json) {
    epc = json['epc'];
    companyName = json['company_name'];
    userBank = json['user_bank'];
    tid = json['tid'];
    supplierId = json['supplier_id'];
    deviceName = json['device name'];
    barcode = json['barcode'];
    deviceIp = json['device_ip'];
    recordDate = json['record_date'];
    recordUser = json['record_user'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['epc'] = epc;
    data['company_name'] = companyName;
    data['user_bank'] = userBank;
    data['tid'] = tid;
    data['supplier_id'] = supplierId;
    data['device name'] = deviceName;
    data['device_ip'] = deviceIp;
    data['barcode'] = barcode;
    data['record_date'] = recordDate;
    data['record_user'] = recordUser;
    return data;
  }
}