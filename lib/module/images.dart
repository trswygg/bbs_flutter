
class ImagesB {
  int time;
  int replyCode;
  String result;
  int count;
  List<ImagesBData> data;

  ImagesB({this.time, this.replyCode, this.result, this.count, this.data});

  ImagesB.fromJson(Map<String, dynamic> json) {
    time = json['Time'];
    replyCode = json['ReplyCode'];
    result = json['Result'];
    count = json['Count'];
    if (json['Data'] != null) {
      data = <ImagesBData>[];
      json['Data'].forEach((v) {
        data.add(new ImagesBData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Time'] = this.time;
    data['ReplyCode'] = this.replyCode;
    data['Result'] = this.result;
    data['Count'] = this.count;
    if (this.data != null) {
      data['Data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ImagesBData {
  int id;
  String createdAt;
  String updatedAt;
  int creatorId;
  String creatorName;
  String creatorFace;
  String imageName;

  ImagesBData(
      {this.id,
        this.createdAt,
        this.updatedAt,
        this.creatorId,
        this.creatorName,
        this.creatorFace,
        this.imageName});

  ImagesBData.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    createdAt = json['CreatedAt'];
    updatedAt = json['UpdatedAt'];
    creatorId = json['CreatorId'];
    creatorName = json['CreatorName'];
    creatorFace = json['CreatorFace'];
    imageName = json['ImageName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['CreatedAt'] = this.createdAt;
    data['UpdatedAt'] = this.updatedAt;
    data['CreatorId'] = this.creatorId;
    data['CreatorName'] = this.creatorName;
    data['CreatorFace'] = this.creatorFace;
    data['ImageName'] = this.imageName;
    return data;
  }
}
