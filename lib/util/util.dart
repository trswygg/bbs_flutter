
import 'package:bbs_flutter/module/post.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hex_color/flutter_hex_color.dart';

class Util {
  static List<Widget> buildFromTags(List<Tags> tags){
    List<Widget> result = <Widget>[];
    if (tags != null) {
      tags.forEach((v) {
        result.add(new RawChip(
          backgroundColor: HexColor(v.color),
          label: Text(v.name),
        )
        );
      });
    }
    if(result.length == 0) {
      result.add(Container(width: 10,height: 10,));
    }
    return result;
  }
  static List<Replys> getReplyByParentId(List<Replys> replys,int id) {
    List<Replys> root = [];
    replys.forEach((e) {
      if(e.parentId == id) {
        root.add(e);
      }
    });
    print("${root.length} getReplyByParentId(len:${replys.length},id: $id)");
    return root;
  }
}