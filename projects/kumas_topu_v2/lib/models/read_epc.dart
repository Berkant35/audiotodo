

class ReadEpc {
  String? epc;
  String? readDate;

  ReadEpc({this.epc, this.readDate});

  ReadEpc.fromJson(Map<String, dynamic> json) {
    epc = json['epc'];
    readDate = json['read_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['epc'] = epc;
    data['read_date'] = readDate;
    return data;
  }
}