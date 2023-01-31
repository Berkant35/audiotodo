import 'err.dart';

class LoginSuccess {
  bool? status;
  int? code;
  String? accessToken;
  String? data;
  Err? err;

  LoginSuccess({this.status, this.code, this.accessToken, this.data, this.err});

  LoginSuccess.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    accessToken = json['access_token'];
    data = json['data'];
    err = json['err'] != null ? Err.fromJson(json['err']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['code'] = code;
    data['access_token'] = accessToken;
    data['data'] = this.data;
    data['err'] = err;
    return data;
  }
}
