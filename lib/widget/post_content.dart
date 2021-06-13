import 'package:bbs_flutter/module/post.dart';
import 'package:bbs_flutter/module/self.dart';
import 'package:bbs_flutter/net/netutil.dart';
import 'package:bbs_flutter/util/colors.dart';
import 'package:bbs_flutter/util/time_format.dart';
import 'package:bbs_flutter/util/util.dart';
import 'package:bbs_flutter/widget/post_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

class PostContent extends StatefulWidget {
  int id;
  PostContent() {
    this.id = int.parse(Get.parameters['id']);
  }

  @override
  _PostContentStat createState() => _PostContentStat(id);
}

class _PostContentStat extends State<PostContent> {
  int id;
  var _io = Get.put(NetIo(), permanent: true);
  _PostContentStat(int id) {
    this.id = id;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("帖子正文"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_outlined),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: Container(
        alignment: Alignment.topCenter,
        child: Container(
          width: 700,
          child: drawPost(),
        ),
      ),
    );
  }

  Widget drawPost() {
    //FutureBuilder
    return FutureBuilder(
      future: _io.onePost(id, true),
      builder: (BuildContext ctx, AsyncSnapshot<PostData> thisPost) {
        if (thisPost.connectionState != ConnectionState.done) {
          return Center(
            child: Container(width: 400, height: 300, child: _loading()),
          );
        }
        if (thisPost.hasData) {
          return DrawContent(thisPost.requireData);
        }
        return Container(width: 400, height: 300, child: Text('loading...'));
      },
    );
  }

  Widget _loading() {
    return Stack(
      children: <Widget>[
        new Padding(
          padding: new EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 35.0),
          child: new Center(
            child: SpinKitRotatingPlain(
              color: BBSColors.green,
              size: 40.0,
            ),
          ),
        ),
        new Padding(
          padding: new EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
          child: new Center(
            child: new Text('正在加载...'),
          ),
        ),
      ],
    );
  }
}

class DrawContent extends StatefulWidget {
  PostData data;
  DrawContent(PostData data) {
    this.data = data;
  }
  @override
  _DrawContentState createState() => _DrawContentState();
}

class _DrawContentState extends State<DrawContent> {
  Self _self  = Get.put(Self(), permanent: true);
  NetIo _io  = Get.put(NetIo(), permanent: true);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 10, 5, 5),
      child: SingleChildScrollView(
        child: Column(
          children: [
            //user info
            Row(
              // header
              children: [
                GestureDetector(
                  onTap: () {
                    Get.toNamed('/profile?id=${widget.data.creatorId}');
                  },
                  child: CircleAvatar(
                    child: ClipOval(
                      child: Image.network(
                        widget.data.creatorFace == ""
                            ? "https://api.prodless.com/avatar.png"
                            : '${NetIo.imageBaseUrl}${widget.data.creatorFace}',
                        width: 128,
                        height: 128,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${widget.data.creatorName}",
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(TimeFormat().format(widget.data.createdAt))
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(left: 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "uid: ${widget.data.creatorId}",
                      ),
                      SizedBox(
                        height: 5,
                        width: 2,
                      ),
                      Text("tid: ${widget.data.id}")
                    ],
                  ),
                )
              ],
            ),
            Container(
              width: 600,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                child: SingleChildScrollView(
                  // width: 600,
                  child: Card(
                    color: BBSColors.gray[0],
                    elevation: 20.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    ),
                    clipBehavior: Clip.antiAlias,
                    semanticContainer: false,
                    child: MarkdownBody(data: widget.data.content),
                  ),
                ),
              ),
            ),
            Container(
              child: InteractiveLine(
                data: this.widget.data,
              ),
            ),
            Container(
              height: 10,
            ),
            buildReply()
          ],
        ),
      ),
    );
  }

  Widget buildReply() {
    print("data.replys.length = ${widget.data.replys.length}");
    if (widget.data.replys.length == 0) {
      return ListTile(
        title: Text("暂无评论"),
        subtitle: Text("点我创建第一条评论"),
        onTap: () => sendReply(widget.data.id, 0),
      );
    }
    return Container(
      width: 500,
      child: buildSubReply(0),
    );
  }

  // buildSubReply 多级回复
  Widget buildSubReply(int rootId) {
    List<Replys> rootReply = Util.getReplyByParentId(widget.data.replys, rootId);
    if(rootReply.length == 0) {
      return Container(width: 1,height: 1,);
    }
    return ListView.builder(
      shrinkWrap: true,
      itemCount: rootReply.length,
      itemBuilder: (BuildContext context, int i) {
        var it = rootReply[i];
        var time = TimeFormat().format(it.createdAt);
        print('draw item reply: id:${it.id},pid: ${it.parentId}');
        return GestureDetector(
          child: Column(
            children: [
              // root reply
              ListTile(
                title: Text(
                    "uid:${it.creatorId} time:$time rid: ${it.id} parent: ${it.parentId}"),
                subtitle: Text("${rootReply[i].content}"),
                // sub reply
                onTap: () => sendReply(widget.data.id,rootReply[i].id),
              ),
              Divider(height: 1,color: BBSColors.cyan,),
              Padding(
                padding: const EdgeInsets.fromLTRB(25,2,2,2),
                child: buildSubReply(rootReply[i].id),
              )
            ],
          ),
        );
      },
    );
  }
  // Widget buildSubReply(List<Replys> replys,int rootId) {
  //   replys.forEach((e) {print('reply id:${e.id},pid: ${e.parentId}');});
  //   List<Replys> rootReply = [];
  //   rootReply = Util.getReplyByParentId(replys, rootId);
  //   if(rootReply.length == 0) {
  //     return Container(width: 1,height: 1,);
  //   }
  //   return ListView.builder(
  //     shrinkWrap: true,
  //     itemCount: rootReply.length,
  //     itemBuilder: (BuildContext context, int i) {
  //       var it = rootReply[i];
  //       var time = TimeFormat().format(it.createdAt);
  //       print('draw item reply: id:${it.id},pid: ${it.parentId}');
  //       return GestureDetector(
  //         child: Column(
  //           children: [
  //             // root reply
  //             ListTile(
  //               title: Text(
  //                   "uid:${it.creatorId} time:$time rid: ${it.id} parent: ${it.parentId}"),
  //               subtitle: Text("${rootReply[i].content}"),
  //               // sub reply
  //               onTap: () => sendReply(widget.data.id,rootReply[i].id),
  //             ),
  //             Divider(height: 1,color: BBSColors.cyan,),
  //             Padding(
  //               padding: const EdgeInsets.fromLTRB(25,2,2,2),
  //               child: buildSubReply(Util.getReplyByParentId(widget.data.replys, rootReply[i].id),rootReply[i].id),
  //             )
  //           ],
  //         ),
  //       );
  //     },
  //     // separatorBuilder: (BuildContext context, int index) {
  //     //   return Divider(
  //     //     height: 1,
  //     //     color: BBSColors.cyan,
  //     //   );
  //     // },
  //   );
  // }

  sendReply(int postId, subId) {
    print("sendReply()");
    if(!_self.isLogin) {
      SmartDialog.showToast("你需要登录才能评论");
      return;
    }
    SmartDialog.show(
      alignmentTemp: Alignment.bottomCenter,
      clickBgDismissTemp: true,
      widget: _sendRepluWidget(postId,subId),
    );
  }

  Widget _sendRepluWidget(int postId, subId) {
    TextEditingController c = TextEditingController();
    return Container(
      constraints: BoxConstraints(maxHeight: 200, maxWidth: double.infinity),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: BBSColors.cyan, blurRadius: 20, spreadRadius: 10)
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Container(
              width: 400,
              child: TextField(
                controller: c,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: '输入你的评论',
                ),
              ),
            ),
            IconButton(onPressed: () {
              SmartDialog.showToast("sending reply : ${c.text}");
              _io.doCreateReply(postId, subId, c.text).then((value) {
                if(value != null) {
                  widget.data.replys.add(value);
                  setState(() {});
                }
              });
            }, icon: Icon(Icons.send))
          ],
        ),
      ),
    );
  }
}
