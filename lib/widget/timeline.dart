import 'package:bbs_flutter/module/post.dart';
import 'package:bbs_flutter/module/query.dart';
import 'package:bbs_flutter/module/self.dart';
import 'package:bbs_flutter/net/netutil.dart';
import 'package:bbs_flutter/util/colors.dart';
import 'package:bbs_flutter/widget/common_drawer.dart';
import 'package:bbs_flutter/widget/post_card.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import 'empty_content.dart';

class TimeLine extends StatefulWidget {
  @override
  _TimeLineState createState() => _TimeLineState();
}

class _TimeLineState extends State<TimeLine> {
  //
  int limit = 10;
  int offset = 1;
  var _self = Get.put(Self(), permanent: true);

  String _type;
  String _id;
  double _offset;
  bool _needOffset;
  ScrollController controller;
  var _io = Get.put(NetIo(), permanent: true);
  Map<String,List<QueryBData>> _postList = <String,List<QueryBData>>{
    "all":[],
    "user":[],
    "follow":[],
    "rand":[],
    "tribes":[]
  };

  Map<String,int> _postListStat = <String,int>{
    "all":-1,
    "user":-1,
    "follow":-1,
    "rand":-1,
    "tribes":-1
  };
  String dropdownValue = '全部';

  Widget timeLienWidget() {
    return Scaffold(
      appBar: AppBar(
        elevation: 4.0,
        backgroundColor: BBSColors.cyan,
        title: DropdownButton<String>(
          value: dropdownValue,
          onChanged: (String newValue) {
            setState(() {
              dropdownValue = newValue;
            });
          },
          items: <String>['全部', '我的', '关注', '部落', '发现']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value, style: TextStyle(color: BBSColors.gray[5])),
            );
          }).toList(),
        ),
        actions: <Widget>[
          SizedBox(
            width: 5.0,
          ),
          IconButton( // search
            onPressed: () {Get.toNamed("/search");},
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          )
        ],
      ),
      drawer: CommonDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed('/post/create');
          if(!_self.isLogin) {
            Fluttertoast.showToast(msg: "你还没有登录，暂时不能发帖");
            return;
          } else {
            Fluttertoast.showToast(msg: "---");
            Get.toNamed('/post/create');
          }
        },
        child: const Icon(Icons.edit),
      ),
      body: Container(
        margin: EdgeInsets.all(10),
          child: _buildTimeLine(dropdownValue)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return timeLienWidget();
  }

  @override
  void initState() {
    controller = new ScrollController()..addListener(_scrollListener);
    _offset = 0.0;
    super.initState();
  }

  // TabBar ['全部', '我的', '关注', '部落', '发现']
  Widget _buildTimeLine(String type) {
    _id = '${_self.id}';
    switch (type) {
      case '全部':
        {
          // _postListStat = -1;
          return buldPostTimeLine( 'all','');
          // Widget childWidget;
          // if (_postListAll.length != 0) {
          //   childWidget = new Padding(
          //     padding: EdgeInsets.all(6.0),
          //     child: new StaggeredGridView.countBuilder(
          //       primary: false,
          //       staggeredTileBuilder: (index) => StaggeredTile.fit(2),
          //       crossAxisCount: 4,
          //       mainAxisSpacing: 4.0,
          //       crossAxisSpacing: 4.0,
          //       itemCount: _postListAll.length,
          //       itemBuilder: (context, item) {
          //         if (item >= _postListAll.length - 2) {
          //           //预加载 2
          //           print("$item >= ${_postListAll.length}");
          //           addTimeLineAll();
          //         }
          //         return buildPostCard(_postListAll[item]);
          //       },
          //     ),
          //   );
          // } else {
          //   // init
          //   childWidget = _loading(type);
          // }
          // return childWidget;
        }
        break;
      case '我的':
        {
          if (!_self.isLogin) {
            return EmptyContent('暂无帖子 in 你的$type 你还没有登录', Icons.subject);
          }
          // _postListStat = -1;
          return buldPostTimeLine( 'user','${_self.id}');
        }
        break;
      case '关注':
        {
          if (!_self.isLogin) {
            return EmptyContent('暂无帖子 in $type 你还没有登录', Icons.subject);
          }
          // _postListStat = -1;
          return buldPostTimeLine( 'follow','${_self.id}');
        }
        break;
      case '部落':
        if (!_self.isLogin) {
          return EmptyContent('暂无帖子 in 你的$type 你还没有登录', Icons.subject);
        }
        // _postListStat = -1;
        return buldPostTimeLine( 'tribes','${_self.id}');
        break;
      case '发现':
        // _postListStat = -1;
        return buldPostTimeLine( 'rand','${_self.id}');
        break;
      default:
        {
          return EmptyContent('暂无帖子 in ' + dropdownValue, Icons.subject);
        }
    }
  }

  Widget buldPostTimeLine(String type,String id) {
    _type = type;
    Widget childWidget;
    if (_postList[type]!=null && _postList[type].length != 0) {
      childWidget = new Container(
        color: BBSColors.gray[1],
        padding: EdgeInsets.fromLTRB(6,6,6,6),
        child: new StaggeredGridView.countBuilder(
          shrinkWrap: true,
          controller: controller,
          crossAxisCount: 4,
          mainAxisSpacing: 20,
          crossAxisSpacing: 5,
          itemCount: _postList[type].length,
          itemBuilder: (context, item) {
            List v = _postList[type];
            return Center(child: buildPostCard(v[item]));
          }, staggeredTileBuilder: (int index) {
          if(ScreenUtil.getInstance().screenWidth >=1000) {
            return StaggeredTile.fit(2);
          }
          return StaggeredTile.fit(4);
        },
        ),
      );
    } else {
      // init
      if (_postListStat[type] == 3 && _postList[type].length == 0) {
        return EmptyContent('暂无帖子', Icons.subject);
      }else  if (_postListStat[type] == 3) {
        return Container(
            width: 200, height: 100, child: Text('已经到底了'));
      }else if (_postListStat[type] == -1) {
        addTimeLine(type,id);
      }
      childWidget = _loading("");
    }
    return childWidget;
  }

  void _scrollListener() async {
    if (_needOffset) {
      controller.jumpTo(_offset);
      _needOffset = false;
    }
    var px = controller.position.pixels;
    var max = controller.position.maxScrollExtent;
    // print('max - px = ${max - px}');
    if (max - px <100) {//判断剩下的距离
      _offset = controller.offset;
      if (_postListStat[_type] != 0){
        await addTimeLine(_type,_id);
      }
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
    _postListStat[type] = 0;
    if(_postList[type] == null) {
      _postList[type] = [];
    }
    print("addTimeLine($type,$id) ${_postList[type].length}");
    _io.timeLine(type, id, 15, _postList[type].length + 1).then((value) {
      if (value == null) {
        _postListStat[type] = 3;
        return;
      }
      value.forEach((element) {
        _postList[type].add(element);
      });
      _postListStat[type] = 2;
      setState(() {
        print('setState(),${_postList[type].length}');
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
            child: new Text('正在加载$type帖子...'),
          ),
        ),
      ],
    );
  }
}
