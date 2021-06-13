import 'package:bbs_flutter/module/self.dart';
import 'package:bbs_flutter/module/user.dart';
import 'package:bbs_flutter/net/netutil.dart';
import 'package:bbs_flutter/util/colors.dart';
import 'package:bbs_flutter/util/time_format.dart';
import 'package:bbs_flutter/widget/gallery_page.dart';
import 'package:bbs_flutter/widget/timeline_page.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  @override
  _MainPage createState() => _MainPage();
}

class _MainPage extends State<HomePage> {
  UserBData _data;
  bool firstRun = true;
  // var _io = Get.put(NetIo(), permanent: true);
  final Self _Self = Get.put(Self());
  var _tabs = <String>[
    "关于",
    "帖子",
    "相册",
  ];

  @override
  Widget build(BuildContext context) {
    if (firstRun) {
      var id = Get.parameters['id'] == null
          ? _Self.id.toString()
          : Get.parameters['id'];
      NetIo().getUser(int.parse(id)).then((r) {
        setState(() {
          // update data
          _data = r;
          firstRun = false;
        });
      });
    }
    return showMainPage();
  }

  Widget showMainPage() {
    return Scaffold(
      body: DefaultTabController(
        length: _tabs.length, // This is the number of tabs.
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            // These are the slivers that show up in the "outer" scroll view.
            return <Widget>[
              SliverOverlapAbsorber(
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                sliver: SliverAppBar(
                  leading: new IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      Get.back();
                    },
                  ),
                  title: Text('${_data?.name}'),
                  centerTitle: false,
                  pinned: true,
                  floating: true,
                  snap: true,
                  primary: true,
                  expandedHeight: 230.0,
                  elevation: 10,
                  forceElevated: innerBoxIsScrolled,
                  actions: <Widget>[
                    new IconButton(
                      icon: Icon(Icons.more_horiz),
                      onPressed: () {},
                    ),
                  ],
                  flexibleSpace: new FlexibleSpaceBar(
                    titlePadding: EdgeInsets.only(top: 10),
                    background: mainPageCard(),
                  ),
                  bottom: TabBar(
                    tabs: _tabs.map((String name) => Tab(text: name)).toList(),
                  ),
                ),
              ),
            ];
          },
          body: TabBarView(
            //TODO
            // These are the contents of the tab views, below the tabs.
            children: [
              InfoWidget(data: _data,),
              TimeLineView('user', Get.parameters['id']),
              GalleryPage.withId(id: Get.parameters['id'])
            ],
          ),
        ),
      ),
    );
  }

  Widget mainPageCard() {
    String _face, _sign;
    int _id, _exp, _post, _follow, _fans;
    if (_data == null) {
      _face = "";
      _sign = "";
      _id = 0;
      _exp = 0;
      _post = 0;
      _follow = 0;
      _fans = 0;
    } else {
      _face = _data.face;
      _sign = _data.profile.sign;
      _id = _data.id;
      _exp = _data.exp;
      _post = _data.postsCount;
      _follow = _data.followsCount;
      _fans = _data.fansCount;
    }
    return Card(
        margin: EdgeInsets.fromLTRB(5, 25, 5, 5),
        elevation: 10.0,
        //设置shape，这里设置成了R角
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
        ),
        color: BBSColors.cyan,
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                        "$_face" == ""
                            ? "https://api.prodless.com/avatar.png"
                            : '${NetIo.imageBaseUrl}$_face',
                        width: 64,
                        height: 64,
                        fit: BoxFit.cover),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          RawChip(
                            isEnabled: false,
                            labelStyle: TextStyle(fontSize: 12),
                            label: Text("id: $_id"),
                          ),
                          RawChip(
                            isEnabled: false,
                            labelStyle: TextStyle(fontSize: 12),
                            label: Text("exp: $_exp"),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(20, 10, 5, 20),
                        child: Row(
                          children: [
                            ElevatedButton(
                              child: Icon(Icons.email_outlined),
                              onPressed: () {},
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(BBSColors.orange),
                                shape:
                                    MaterialStateProperty.all(CircleBorder()),
                              ),
                            ),
                            ElevatedButton.icon(
                              icon: Icon(Icons.add),
                              label: Text("关注"),
                              onPressed: () {
                                Fluttertoast.showToast(msg: '为实现的方法');
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(BBSColors.orange),
                                shape:
                                    MaterialStateProperty.all(StadiumBorder()),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
              Container(
                  height: 20,
                  child: Text(
                    _sign,
                    style: TextStyle(color: Colors.white70),
                  )),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 64,
                    height: 25,
                    color: Colors.white38,
                    child: Text(
                      "帖子 $_post",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 25,
                    color: BBSColors.gray[5],
                  ),
                  Container(
                    width: 64,
                    height: 25,
                    color: Colors.white38,
                    child: Text(
                      "关注 $_follow",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 25,
                    color: BBSColors.gray[5],
                  ),
                  Container(
                    width: 64,
                    height: 25,
                    color: Colors.white38,
                    child: Text(
                      "粉丝 $_fans",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}

class InfoWidget extends StatelessWidget {
  UserBData data;
  InfoWidget({
    this.data
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      child: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.all(20.0),
        children: <Widget>[
          InfoCard('id','${data?.id}'),
          InfoCard('注册时间',TimeFormat().format(data?.createdAt)),
          InfoCard('姓名','${data?.name}'),
          InfoCard('邮箱','${data?.email}'),
          InfoCard('性别','${data?.profile?.sign}'),
          InfoCard('电话','${data?.profile?.phone}'),
          InfoCard('年龄','${data?.profile?.age}'),
          InfoCard('性别','${data?.profile?.sex}'),
          InfoCard('生日','${data?.profile?.birthday}'),
          // InfoCard('face','${data?.face}'),
          InfoCard('经验','${data?.exp}'),
          InfoCard('上次登录','${data?.lastLogin}'),
          // InfoCard('userGroupId','${data?.userGroupId}'),
          InfoCard('收藏数','${data?.favoritesCount}'),
          InfoCard('点赞数','${data?.likesCount}'),
          InfoCard('相册数','${data?.imagesCount}'),
          // InfoCard('classesCount','${data?.classesCount}'),
          // InfoCard('tribesCount','${data?.tribesCount}'),
          InfoCard('帖子数','${data?.postsCount}'),
          InfoCard('评论数','${data?.replysCount}'),
          InfoCard('粉丝数','${data?.fansCount}')
        ],
      ),
    );
  }
  Widget InfoCard(String a,b) {
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 5, 5, 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$a',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text('    $b'),
          Divider(
            height: 1,
          )
        ],
      ),
    );
  }
}

