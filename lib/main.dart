import 'package:bbs_flutter/util/colors.dart';
import 'package:bbs_flutter/widget/create_post.dart';
import 'package:bbs_flutter/widget/gallery_page.dart';
import 'package:bbs_flutter/widget/home_page.dart';
import 'package:bbs_flutter/widget/live_page.dart';
import 'package:bbs_flutter/widget/login.dart';
import 'package:bbs_flutter/widget/mailbox.dart';
import 'package:bbs_flutter/widget/post_content.dart';
import 'package:bbs_flutter/widget/search_page.dart';
import 'package:bbs_flutter/widget/timeline.dart';
import 'package:bbs_flutter/widget/tribes.dart';
import 'package:bbs_flutter/widget/unknown_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';


Future<void> main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    debugPaintSizeEnabled = false; // 绘制布局边界
    return GetMaterialApp( // Before: MaterialApp((
      title: 'BBS',
      theme: ThemeData(
          primaryColor: BBSColors.black,
          primarySwatch: Colors.blueGrey),
      unknownRoute: GetPage(name: '/notfound', page: () => UnknownPage()),
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => IndexPage()),
        GetPage(name: '/login', page: () => Login()),
        GetPage(name: '/profile', page: () => HomePage()),
        GetPage(name: '/post', page: () => PostContent()),
        GetPage(name: '/gallery', page: () => GalleryPage()),
        GetPage(name: '/search', page: () => SearchPage()),
        GetPage(name: '/live', page: () => Live()),
        GetPage(name: '/tribes/list', page: () => TribesList()),
        GetPage(name: '/tribes', page: () => TribesList()),
        GetPage(name: '/class', page: () => TribesList()),
        GetPage(name: '/post/create', page: () => CreatePost()),
      ],
      builder: (BuildContext context, Widget child) {
        return FlutterSmartDialog(child: child);
      },
    );
  }
}

class IndexPage extends StatefulWidget {
  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  final List<BottomNavigationBarItem> bottomTabs = [
    BottomNavigationBarItem(icon: Icon(Icons.timeline), label: "时间线"),
    BottomNavigationBarItem(icon: Icon(Icons.mail), label: "消息"),
  ];
  final List<Widget> tabBodies = [TimeLine(), MailBox()];

  int currentIndex = 0;
  var currentPage;

  @override
  void initState() {
    currentPage = tabBodies[currentIndex];
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: tabBodies[currentIndex],
      bottomNavigationBar: CupertinoTabBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
            currentPage = tabBodies[currentIndex];
          },);
        },
        items: bottomTabs,
      ),
    );
  }
}