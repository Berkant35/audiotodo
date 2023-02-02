class CustomFile {
  String? customerID;
  String? uploadingDate;
  String? fileName;
  String? fileExplain;
  String? fileID;
  String? fileURL;
  String? fileSize;

  CustomFile(
      {this.customerID,
        this.uploadingDate,
        this.fileName,
        this.fileExplain,
        this.fileID,
        this.fileURL,
        this.fileSize});

  CustomFile.fromJson(Map<String, dynamic> json) {
    customerID = json['customerID'];
    uploadingDate = json['uploadingDate'];
    fileName = json['fileName'];
    fileExplain = json['fileExplain'];
    fileID = json['fileID'];
    fileURL = json['fileURL'];
    fileSize = json['fileSize'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['customerID'] = customerID;
    data['uploadingDate'] = uploadingDate;
    data['fileName'] = fileName;
    data['fileExplain'] = fileExplain;
    data['fileID'] = fileID;
    data['fileURL'] = fileURL;
    data['fileSize'] = fileSize;
    return data;
  }
}