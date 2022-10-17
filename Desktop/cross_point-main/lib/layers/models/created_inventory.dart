
class CreateInventory {
  String? location;
  List<TagList>? tagList;
  String? token;

  CreateInventory({this.location, this.tagList, this.token});

  CreateInventory.fromJson(Map<String, dynamic> json) {
    location = json['location'];
    if (json['tag_list'] != null) {
      tagList = <TagList>[];
      json['tag_list'].forEach((v) {
        tagList!.add(TagList.fromJson(v));
      });
    }

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['location'] = location;
    if (tagList != null) {
      data['tag_list'] = tagList!.map((v) => v.toJson()).toList();
    }
    data ['access_token'] = token;
    return data;
  }
}

class TagList {
  String? epc;
  String? readDate;

  TagList({this.epc, this.readDate});

  TagList.fromJson(Map<String, dynamic> json) {
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