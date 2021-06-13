import 'package:bbs_flutter/module/self.dart';
import 'package:bbs_flutter/util/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'common_drawer.dart';
import 'empty_content.dart';

class MailBox extends StatefulWidget {
  @override
  _MailBoxState createState() => _MailBoxState();
}

class _MailBoxState extends State<MailBox> {
  Self _self = Get.put(Self(),permanent: true);
  Widget _MailBoxWidget() {
    return Scaffold(
      appBar: AppBar(
        elevation: 4.0,
        backgroundColor: BBSColors.cyan,
        title: Text('消息'),
        actions: <Widget>[
          SizedBox(
            width: 5.0,
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.more_vert),
          )
        ],
      ),
      drawer: CommonDrawer(),
      body:  _body(),
    );
  }

  Widget _body() {
    if (_self.name == "trswygg") {
      return ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.all(20.0),
        children: <Widget>[
          const ListTile(
            title: Text("from: system || title: 自动消亡 || time:5-16"),
            subtitle: Text("您创建的部落：`闲置部落` tid:11 由于:活跃度归零超过7天，将被清理 \n 请注意：部落内的帖子也将被删除"),
          ),
          const ListTile(
            title: Text("from: system || title: 自动消亡 || time:5-9"),
            subtitle: Text("您创建的部落：`闲置部落` tid:11 由于:活跃度归零，将被隐藏"),
          ),
        ],
      );
    } else {
      EmptyContent('暂无消息',Icons.mail_outline);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _MailBoxWidget();
  }
}