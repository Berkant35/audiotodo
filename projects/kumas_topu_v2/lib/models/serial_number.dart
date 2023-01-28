import 'err.dart';

class SerialNumber {
  bool? status;
  int? code;
  Serial? data;
  Err? err;

  SerialNumber({this.status, this.code, this.data, this.err});

  SerialNumber.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    data = json['data'] != null ? Serial.fromJson(json['data']) : null;
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

class Serial {
  int? serialNumber;

  Serial({this.serialNumber});

  Serial.fromJson(Map<String, dynamic> json) {
    serialNumber = json['serial_number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['serial_number'] = serialNumber;
    return data;
  }
}