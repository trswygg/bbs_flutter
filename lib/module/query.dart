class QueryB {
  int time;
  int replyCode;
  String result;
  int count;
  List<QueryBData> data;

  QueryB({this.time, this.replyCode, this.result, this.count, this.data});

  QueryB.fromJson(Map<String, dynamic> json) {
    time = json['Time'];
    replyCode = json['ReplyCode'];
    result = json['Result'];
    count = json['Count'];
    if (json['Data'] != null) {
      data = <QueryBData>[];
      json['Data'].forEach((v) {
        data.add(new QueryBData.fromJson(v));
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

class QueryBData {
  int id;
  int creatorId;
  int tribeId;
  String title;
  String mainImage;
  String createdAt;

  QueryBData(
      {this.id,
        this.creatorId,
        this.tribeId,
        this.title,
        this.mainImage,
        this.createdAt});

  QueryBData.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    creatorId = json['CreatorId'];
    tribeId = json['TribeId'];
    title = json['Title'];
    mainImage = json['MainImage'];
    createdAt = json['CreatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['CreatorId'] = this.creatorId;
    data['TribeId'] = this.tribeId;
    data['Title'] = this.title;
    data['MainImage'] = this.mainImage;
    data['CreatedAt'] = this.createdAt;
    return data;
  }
}
