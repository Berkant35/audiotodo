
class CityListOfTurkey {
  List<CityList>? cityList;

  CityListOfTurkey({this.cityList});

  CityListOfTurkey.fromJson(Map<String, dynamic> json) {
    if (json['cityList'] != null) {
      cityList = <CityList>[];
      json['cityList'].forEach((v) {
        cityList!.add(new CityList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.cityList != null) {
      data['cityList'] = this.cityList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CityList {
  int? value;
  String? text;
  List<Districts>? districts;

  CityList({this.value, this.text, this.districts});

  CityList.fromJson(Map<String, dynamic> json) {
    value = json['value'];
    text = json['text'];
    if (json['districts'] != null) {
      districts = <Districts>[];
      json['districts'].forEach((v) {
        districts!.add(new Districts.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['value'] = this.value;
    data['text'] = this.text;
    if (this.districts != null) {
      data['districts'] = this.districts!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Districts {
  int? value;
  String? text;

  Districts({this.value, this.text});

  Districts.fromJson(Map<String, dynamic> json) {
    value = json['value'];
    text = json['text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['value'] = this.value;
    data['text'] = this.text;
    return data;
  }
}