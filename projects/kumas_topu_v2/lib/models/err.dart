class Err {
  int? code;
  String? message;

  Err({this.code, this.message});

  Err.fromJson(Map<String, dynamic> json)
  {
    code = json['code'];
    message = json['message'];
  }

  Map<String, dynamic> toJson()
  {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['message'] = message;
    return data;
  }
}
/*
*
* {
    "status": true,
    "code": 200,
    "data": null,
    "err": null
}
* */