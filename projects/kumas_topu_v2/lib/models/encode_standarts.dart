import 'err.dart';

class EncodeStandarts {
  bool? status;
  int? code;
  List<PerStandart>? data;
  Err? err;

  EncodeStandarts({this.status, this.code, this.data, this.err});

  EncodeStandarts.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    if (json['data'] != null) {
      data = <PerStandart>[];
      json['data'].forEach((v) {
        data!.add(PerStandart.fromJson(v));
      });
    }
    err = json['err'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['code'] = code;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['err'] = Err.fromJson(err!.toJson());
    return data;
  }
}

class PerStandart {
  String? id;
  String? encodeName;

  PerStandart({this.id, this.encodeName});

  PerStandart.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    encodeName = json['encode_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['encode_name'] = encodeName;
    return data;
  }
}