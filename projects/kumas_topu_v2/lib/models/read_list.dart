import 'package:kumas_topu/models/read_epc.dart';

class ReadList {
  bool? status;
  int? code;
  List<ReadEpc>? data;
  Null? err;

  ReadList({this.status, this.code, this.data, this.err});

  ReadList.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    if (json['data'] != null) {
      data = <ReadEpc>[];
      json['data'].forEach((v) {
        data!.add(ReadEpc.fromJson(v));
      });
    }
    err = json['err'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['status'] = this.status;
    data['code'] = this.code;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['err'] = this.err;
    return data;
  }
}

