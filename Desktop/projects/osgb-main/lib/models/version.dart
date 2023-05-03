class Version {
  int? buildNumber;
  bool? isRequiredForceUpdate;
  String? versionNumber;

  Version({this.buildNumber, this.isRequiredForceUpdate, this.versionNumber});

  Version.fromJson(Map<String, dynamic> json) {
    buildNumber = json['buildNumber'];
    isRequiredForceUpdate = json['isRequiredForceUpdate'];
    versionNumber = json['versionNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['buildNumber'] = buildNumber;
    data['isRequiredForceUpdate'] = isRequiredForceUpdate;
    data['versionNumber'] = versionNumber;
    return data;
  }
}
