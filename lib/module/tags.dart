import 'package:bbs_flutter/module/post.dart';

class TagsB {
  int time;
  int replyCode;
  String result;
  int count;
  List<Tags> data;

  TagsB({this.time, this.replyCode, this.result, this.count, this.data});

  TagsB.fromJson(Map<String, dynamic> json) {
    time = json['Time'];
    replyCode = json['ReplyCode'];
    result = json['Result'];
    count = json['Count'];
    if (json['Data'] != null) {
      data = <Tags>[];
      json['Data'].forEach((v) {
        data.add(new Tags.fromJson(v));
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
