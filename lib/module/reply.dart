import 'package:bbs_flutter/module/post.dart';

class ReplyB {
  int time;
  int replyCode;
  String result;
  int count;
  Replys data;

  ReplyB({this.time, this.replyCode, this.result, this.count, this.data});

  ReplyB.fromJson(Map<String, dynamic> json) {
    time = json['Time'];
    replyCode = json['ReplyCode'];
    result = json['Result'];
    count = json['Count'];
    data = json['Data'] != null ? new Replys.fromJson(json['Data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Time'] = this.time;
    data['ReplyCode'] = this.replyCode;
    data['Result'] = this.result;
    data['Count'] = this.count;
    if (this.data != null) {
      data['Data'] = this.data.toJson();
    }
    return data;
  }
}