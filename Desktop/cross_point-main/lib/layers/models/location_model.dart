import 'err.dart';

class Locations {
  bool? status;
  int? code;
  List<Location>? data;
  Err? err;

  Locations({this.status, this.code, this.data, this.err});

  Locations.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    if (json['data'] != null) {
      data = <Location>[];
      json['data'].forEach((v) {
        data!.add(Location.fromJson(v));
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
    data['err'] = err;
    return data;
  }
}

class Location {
  String? id;
  String? name;

  Location({this.id, this.name});

  Location.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}