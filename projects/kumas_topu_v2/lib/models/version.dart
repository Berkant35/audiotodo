class Version {
  bool? status;
  int? code;
  Data? data;


  Version({this.status, this.code, this.data});

  Version.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['code'] = this.code;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }

    return data;
  }
}

class Data {
  String? message;
  String? appVersion;
  String? serverVersion;
  String? date;

  Data({this.message, this.appVersion, this.serverVersion, this.date});

  Data.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    appVersion = json['app_version'];
    serverVersion = json['server_version'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['app_version'] = this.appVersion;
    data['server_version'] = this.serverVersion;
    data['date'] = this.date;
    return data;
  }
}