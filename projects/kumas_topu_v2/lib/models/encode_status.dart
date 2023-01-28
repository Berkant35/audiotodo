import 'err.dart';

class EncodeStatus {
  bool? status;
  int? code;
  String? data;
  Err? err;

  EncodeStatus({this.status, this.code, this.data, this.err});

  EncodeStatus.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    data = json['data'];
    err = json['err'] != null ?  Err.fromJson(json['err']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['code'] = code;
    data['data'] = this.data;
    data['err'] = err;
    return data;
  }
}