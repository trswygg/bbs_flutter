import 'package:bbs_flutter/module/images.dart';
import 'package:bbs_flutter/module/self.dart';
import 'package:bbs_flutter/net/netutil.dart';
import 'package:bbs_flutter/util/colors.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';

import 'empty_content.dart';
import 'image_card.dart';

// ignore: must_be_immutable
class GalleryPage extends StatefulWidget {
  int id;
  GalleryPage() {
    this.id = int.parse(Get.parameters['id']);
  }
  GalleryPage.withId({String id}) {
    this.id = int.parse(id);
  }
  @override
  GalleryPageState createState() => new GalleryPageState(id);
}

class GalleryPageState extends State<GalleryPage> {
  Self _self = Get.put(Self(),permanent: true);
  GalleryPageState(int id) {
    this.id = id;
    this._imageList = [];
    this._imageListStat = -1;
  }
  int id = 0;
  // int _beLoad = 0; // 0表示不显示, 1表示正在请求, 2表示没有更多数据
  var _io = Get.put(NetIo(), permanent: true);
  // var _self = Get.put(Self(), permanent: true);
  List<ImagesBData> _imageList = [];
  int _imageListStat = -1;

  Widget build(BuildContext context) {
    if (id == _self.id) {
      return Scaffold(
        floatingActionButton: FloatingActionButton(
          foregroundColor: BBSColors.cyan,
          child: Icon(Icons.add),
          onPressed: () {  },
        ),
        body: buildGallery(context),
      );
    }
    return buildGallery(context);
  }

  Widget buildGallery(BuildContext context) {
    Widget childWidget;
    if (_imageList!=null && _imageList.length != 0) {
      childWidget = new Container(
        color: BBSColors.gray[1],
        padding: EdgeInsets.fromLTRB(6,50,6,6),
        child: StaggeredGridView.countBuilder(
          itemCount: _imageList.length,
          primary: false,
          crossAxisCount: 4,
          mainAxisSpacing: 20,
          crossAxisSpacing: 5,
          itemBuilder: (context, item) {
            if (item == _imageList.length) {
              //预加载
              print("$item >= ${_imageList.length}");
              addImages(id);
            }
            List v = _imageList;
            return Center(child: ImageCard(v[item]));
          },
          staggeredTileBuilder: (int index) {
            if (ScreenUtil.getInstance().screenWidth >= 1000) {
              return StaggeredTile.fit(2);
            }
            return StaggeredTile.fit(4);
          },
        ),
      );
    } else {
      // init
      if (_imageListStat == 3 && _imageList.length == 0) {
        return EmptyContent('暂无', Icons.subject);
      }else if (_imageListStat == 3) {
        return Container(
            width: 200, height: 100, child: Text('已经到底了'));
      }else if (_imageListStat == -1) {
        addImages(id);
      }
      childWidget = _loading("");
    }
    return Scaffold(body: childWidget);
  }

  void addImages(int id) async {
    _imageListStat = 0;
    print("addImages($id) ${_imageList.length}");
    _io.images(id, 15, _imageList.length + 1).then((value) {
      if (value == null || value.length == 0) {
        _imageListStat = 3;
        return;
      }
      value.forEach((element) {
        print('${element.creatorName} ${element.id}');
        _imageList.add(element);
      });
      _imageListStat = 2;
      setState(() {
        print('addImages($id),${_imageList.length}');
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
              color: BBSColors.blue,
              size: 40.0,
            ),
          ),
        ),
        new Padding(
          padding: new EdgeInsets.fromLTRB(0.0, 35.0, 0.0, 0.0),
          child: Container(
            child: new Center(
              child: new Text('正在加载相册...'),
            ),
          ),
        ),
      ],
    );
  }
}