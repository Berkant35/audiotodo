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
    err = json['err'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['code'] = this.code;
    data['access_token'] = this.accessToken;
    data['data'] = this.data;
    data['err'] = this.err;
    return data;
  }
}