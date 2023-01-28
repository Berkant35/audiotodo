import 'err.dart';

class CreateResultEPC {
  bool? status;
  int? code;
  EpcResult? data;
  Err? err;

  CreateResultEPC({this.status, this.code, this.data, this.err});

  CreateResultEPC.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    data = json['data'] != null ? EpcResult.fromJson(json['data']) : null;
    err = json['err'] != null ? Err.fromJson(json['err']) :null;
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

class EpcResult {
  String? epc;
  String? userBank;
  String? password;

  EpcResult({this.epc, this.userBank, this.password});

  EpcResult.fromJson(Map<String, dynamic> json) {
    epc = json['epc'];
    userBank = json['user_bank'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['epc'] = this.epc;
    data['user_bank'] = this.userBank;
    data['password'] = this.password;
    return data;
  }
}