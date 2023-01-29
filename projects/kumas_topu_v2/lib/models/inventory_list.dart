import 'err.dart';

class InventoryList {
  bool? status;
  int? code;
  List<Inventory>? data;
  Err? err;

  InventoryList({this.status, this.code, this.data, this.err});

  InventoryList.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    if (json['data'] != null) {
      data = <Inventory>[];
      json['data'].forEach((v) {
        data!.add(Inventory.fromJson(v));
      });
    }
    err = json['err'] != null ? Err.fromJson(json['err']) : null;
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

class Inventory {
  String? iD;
  String? inventoryName;
  String? inventoryUniqueName;
  String? prefix;

  Inventory({this.iD, this.inventoryName, this.inventoryUniqueName});

  Inventory.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    inventoryName = json['inventory_name'];
    inventoryUniqueName = json['inventory_unique_name'];
    prefix = json['prefix'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ID'] = iD;
    data['inventory_name'] = inventoryName;
    data['inventory_unique_name'] = inventoryUniqueName;
    data['prefix'] = prefix;
    return data;
  }
}
