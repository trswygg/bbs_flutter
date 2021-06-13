
import 'package:bbs_flutter/module/post.dart';
import 'package:bbs_flutter/module/query.dart';
import 'package:bbs_flutter/net/netutil.dart';
import 'package:bbs_flutter/util/colors.dart';
import 'package:bbs_flutter/widget/post_card.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';

import 'empty_content.dart';

class TimeLineView extends StatefulWidget {
  String type;
  String id;
  TimeLineView(String type,String id) {
    this.type = type;
    this.id = id;
  }

  @override
  _TimeLineViewState createState() {
    return new _TimeLineViewState(type,id);
  }
}

class _TimeLineViewState extends State<TimeLineView> {
  String type;
  String id;
  double _offset;
  bool _needOffset;
  ScrollController controller;
  var _io = Get.put(NetIo(), permanent: true);
  Map<String,List<QueryBData>> _postList = <String,List<QueryBData>>{};
  int _postListStat = -1;
  _TimeLineViewState(String type,String id) {
    this.type = type;
    this.id = id;
    this._postList = <String,List<QueryBData>>{
      "all":[],
      "user":[],
      "follow":[],
      "rand":[],
      "tribes":[]
    };
    _offset = 0.0;
    _needOffset = false;
  }

  @override
  void initState() {
    controller = new ScrollController()..addListener(_scrollListener);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return buldPostTimeLine( type,id);
  }

  Widget buldPostTimeLine(String type,String id) {
    Widget childWidget;
    if (_postList[type]!=null && _postList[type].length != 0) {
      childWidget = new Container(
        color: BBSColors.gray[1],
        padding: EdgeInsets.fromLTRB(6,50,6,6),
        child: new StaggeredGridView.countBuilder(
          shrinkWrap: true,
          controller: controller,
          crossAxisCount: 4,
          mainAxisSpacing: 20,
          crossAxisSpacing: 5,
          itemCount: _postList[type].length,
          itemBuilder: (context, item) {
            if (item == _postList[type].length) {
              //预加载 有问题
              print("$item >= ${_postList[type].length}");
              addTimeLine(type,id);
            }
            List v = _postList[type];
            return Center(child: buildPostCard(v[item]));
          }, staggeredTileBuilder: (int index) {
            if(ScreenUtil.getInstance().screenWidth >=1000) {
              return StaggeredTile.fit(2);
            }
            return StaggeredTile.fit(4);
        },
        ),
        // child: ListView.builder(
        //     controller: controller,
        //   itemCount: _postList[type].length,
        //     itemBuilder: (context, item) {
        //       if (item == _postList[type].length) {
        //             //预加载 有问题
        //             print("$item >= ${_postList[type].length}");
        //             addTimeLine(type,id);
        //           }
        //           List v = _postList[type];
        //           return Center(child: buildPostCard(v[item]));
        //         }
        // ),
      );
    } else {
      // init
      if (_postListStat == 3 && _postList[type].length == 0) {
        return EmptyContent('暂无帖子', Icons.subject);
      }else  if (_postListStat == 3) {
        return Container(
            width: 200, height: 100, child: Text('已经到底了'));
      }else if (_postListStat == -1) {
        addTimeLine(type,id);
      }
      addTimeLine(type,id);
      childWidget = _loading(type);
    }
    return childWidget;
  }

  void _scrollListener() {
    if (_needOffset) {
      controller.jumpTo(_offset);
      _needOffset = false;
    }
    var px = controller.position.pixels;
    var max = controller.position.maxScrollExtent;
    if (px == max) {//判断剩下的距离
      _offset = controller.offset;
      addTimeLine(type,id);
    }
  }

  // FutureBuilder
  // return a post card
  Widget buildPostCard(QueryBData data) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        FutureBuilder(
          future: _io.onePost(data.id, false),
          builder: (BuildContext ctx, AsyncSnapshot<PostData> thisPost) {
            if (thisPost.connectionState != ConnectionState.done) {
              return Center(
                child: Container(width: 0, height: 0),
              );
            }
            if (thisPost.hasData) {
              return PostCard(
                  data: thisPost.requireData
              );
            }
            return Container(width: 0, height: 0);
          },
        ),
      ],
    );
  }

  void addTimeLine(String type,String id) async {
    _postListStat = 0;
    if (_postList[type] == null) {
      _postList[type] = [];
    }
    print("addTimeLine($type,$id) ${_postList[type].length}");
    _io.timeLine(type, id, 5, _postList[type].length + 1).then((value) {
      if (value == null) {
        _postListStat = 3;
        return;
      }
      value.forEach((element) {
        _postList[type].add(element);
      });
      _postListStat = 2;
      setState(() {
        print('addTimeLine($type,$id),${_postList[type].length}');
        _needOffset = true;
      });
    });
  }

  Widget _loading(String type) {
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
          padding: new EdgeInsets.fromLTRB(0.0, 35.0, 0.0, 0.0),
          child: new Center(
            child: new Text('正在加载$type帖子... id=$id'),
          ),
        ),
      ],
    );
  }
}