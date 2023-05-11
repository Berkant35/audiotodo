import 'err.dart';

class InventoryList {
  bool? status;
  int? code;
  List<Inventory>? data;
  Err? err;

  InventoryList({this.status, this.code, this.data, this.err});

  InventoryList.fromJson(Map<String, dynamic> json,bool isShipment) {
    status = json['status'];
    code = json['code'];
    if (json['data'] != null) {
      data = <Inventory>[];
      json['data'].forEach((v) {
        data!.add(Inventory.fromJson(v,isShipment));
      });
    }
    err = json['err'] != null ? Err.fromJson(json['err']) : null;
  }

  Map<String, dynamic> toJson(bool isShipment) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['code'] = code;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson(isShipment)).toList();
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
  String? recordDate;

  Inventory({this.iD, this.inventoryName, this.inventoryUniqueName});

  Inventory.fromJson(Map<String, dynamic> json,bool isShipment) {
    iD = json['ID'];
    inventoryName = json[isShipment ? "shipment_name" : 'inventory_name'];
    inventoryUniqueName = json[isShipment ? "shipment_unique_name" : 'inventory_unique_name'];
    prefix = json['prefix'];
    recordDate = json['record_date'] ?? "unknown";
  }

  Map<String, dynamic> toJson(bool isShipment)
  {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ID'] = iD;
    data[isShipment ? "shipment_name" : 'inventory_name'] = inventoryName;
    data[isShipment ? "shipment_unique_name" : 'inventory_unique_name'] = inventoryUniqueName;
    data['prefix'] = prefix;
    data['record_date'] = recordDate;

    return data;
  }
}
