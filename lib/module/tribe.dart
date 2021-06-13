class TribeB {
  int time;
  int replyCode;
  String result;
  int count;
  List<TribeBData> data;

  TribeB({this.time, this.replyCode, this.result, this.count, this.data});

  TribeB.fromJson(Map<String, dynamic> json) {
    time = json['Time'];
    replyCode = json['ReplyCode'];
    result = json['Result'];
    count = json['Count'];
    if (json['Data'] != null) {
      data = <TribeBData>[];
      json['Data'].forEach((v) {
        data.add(new TribeBData.fromJson(v));
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

class TribeBData {
  int id;
  String createdAt;
  int activityDegree;
  bool protect;
  String name;
  String color;
  String disc;
  int creatorId;
  int classId;
  int postsCount;

  TribeBData(
      {this.id,
        this.createdAt,
        this.activityDegree,
        this.protect,
        this.name,
        this.color,
        this.disc,
        this.creatorId,
        this.classId,
        this.postsCount});

  TribeBData.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    createdAt = json['CreatedAt'];
    activityDegree = json['ActivityDegree'];
    protect = json['Protect'];
    name = json['Name'];
    color = json['Color'];
    disc = json['Disc'];
    creatorId = json['CreatorId'];
    classId = json['ClassId'];
    postsCount = json['PostsCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['CreatedAt'] = this.createdAt;
    data['ActivityDegree'] = this.activityDegree;
    data['Protect'] = this.protect;
    data['Name'] = this.name;
    data['Color'] = this.color;
    data['Disc'] = this.disc;
    data['CreatorId'] = this.creatorId;
    data['ClassId'] = this.classId;
    data['PostsCount'] = this.postsCount;
    return data;
  }
}
