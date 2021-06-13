
import 'package:bbs_flutter/module/tribe.dart';
import 'package:bbs_flutter/net/netutil.dart';
import 'package:bbs_flutter/util/time_format.dart';
import 'package:bbs_flutter/widget/timeline_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TribesList extends StatefulWidget {
  const TribesList({Key key}) : super(key: key);

  @override
  _TribesListState createState() => _TribesListState();
}

class _TribesListState extends State<TribesList> {
  //         DropdownMenuItem(child: Text('杂谈'), value: 1),
  //         DropdownMenuItem(child: Text('时间线'), value: 2),
  //         DropdownMenuItem(child: Text('亚文化'), value: 3),
  //         DropdownMenuItem(child: Text('科技'), value: 4),
  //         DropdownMenuItem(child: Text('影视'), value: 5),
  //         DropdownMenuItem(child: Text('值班室'), value: 6),
  var _io = Get.put(NetIo(), permanent: true);
  List<String> classes = ['杂谈','时间线','亚文化','科技','影视','值班室'];
  List<String> disc = [
    '杂谈版，找不到分类的可以先放在这里',
    '综合版，集齐一手消息',
    '沵竾湜②佽沅嬤',
    '科学技术是第一生产力 /n/t ————邓小平',
    '影视杂谈',
    '门卫大爷们的值班室'
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Get.back();
            }),
      ),
      body: Container(
        alignment: Alignment.topCenter,
        width: 600,
        child: ListView.builder(
            itemCount:classes.length,
            itemBuilder:(context, item){
              return Column(
                children: [
                  ListTile(
                    onTap: () {
                    //  class id = ?
                      Get.to(TimeLineView('class','${item+1}'));
                    },
                    title: Text('${classes[item]}'),
                    subtitle: Text('${disc[item]}'),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: FutureBuilder(
                      future: _io.doTribeList(item+1),
                      builder: (BuildContext ctx, AsyncSnapshot<List<TribeBData>> tribes) {
                        if (tribes.connectionState != ConnectionState.done) {
                          return Container(width: 1,height: 1,);
                        }
                        if (tribes.hasData) {
                          return _drawTribeItems(tribes.requireData);
                        }
                        return Container(width: 400, height: 50, child: Text('loading...'));
                      },
                    ),
                  ),
                  Divider(height: 2,)
                ],
              );
            }
        ),
      ),
    );
  }
  Widget _drawTribeItems(List<TribeBData> items) {
    return ListView.builder(
        shrinkWrap: true,
      itemCount: items.length,
        itemBuilder: (context, i){
          return ListTile(
            onTap: () {
              //timeline tribe id = ?
              Get.to(TimeLineView('tribe','${items[i].id}'));
            },
            title: Text('${items[i].name}'),
            subtitle: Text('创建时间 ${TimeFormat().format(items[i].createdAt)},介绍 ${items[i].disc},帖子数 ${items[i].postsCount}'),
          );
    });
  }
}
