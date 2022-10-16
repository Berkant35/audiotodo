class UHFTagInfo {
  String? epc;
  String? tid;
  String? userData;

  UHFTagInfo({this.epc, this.tid, this.userData});

  UHFTagInfo.fromJson(Map<String, dynamic> json) {
    epc = json['epc'];
    tid = json['tid'];
    userData = json['user_data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['epc'] = epc;
    data['tid'] = tid;
    data['user_data'] = userData;
    return data;
  }
}
