
import 'package:kumas_topu/models/err.dart';

class CreateSuccess {
  bool? status;
  int? code;
  bool? data;
  Err? err;

  CreateSuccess({this.status, this.code, this.data, this.err});

  CreateSuccess.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    data = json['data'];
    err = json['err'] != null ? Err.fromJson(json['err']) : null;
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
