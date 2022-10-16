class Items {
  bool? status;
  int? code;
  List<Item>? data;

  Items({this.status, this.code, this.data});

  Items.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    if (json['data'] != null) {
      data = <Item>[];
      json['data'].forEach((v) {
        data!.add(Item.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['code'] = code;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Item {
  String? id;
  String? epc;
  String? ean;
  String? userData;
  String? color;
  String? sizes;
  String? notes;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? label;

  Item(
      {this.id,
        this.epc,
        this.ean,
        this.userData,
        this.color,
        this.sizes,
        this.notes,
        this.status,
        this.label,
        this.createdAt,
        this.updatedAt});

  Item.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    epc = json['epc'];
    ean = json['ean'];
    userData = json['user_data'];
    color = json['color'];
    sizes = json['sizes'];
    notes = json['notes'];
    status = json['status'];
    label = json['label'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['epc'] = epc;
    data['ean'] = ean;
    data['user_data'] = userData;
    data['color'] = color;
    data['sizes'] = sizes;
    data['notes'] = notes;
    data['label'] = label;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}