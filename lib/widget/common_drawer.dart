import 'package:bbs_flutter/module/self.dart';
import 'package:bbs_flutter/net/netutil.dart';
import 'package:bbs_flutter/util/colors.dart';
import 'package:bbs_flutter/widget/about_card.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';


class CommonDrawer extends StatelessWidget {
  final Self _self = Get.put(Self(),permanent: true);
  String getName() => _self.isLogin?_self.name:"请先登录";
  int getId() => _self.isLogin?_self.id:0;
  String getEmail() => _self.isLogin?_self.email:"";
  String getImage() => _self.image != "" ?_self.image:NetIo.defaultAvatar;


  @override
  Widget build(BuildContext context) {
    Fluttertoast.showToast(msg: 'CommonDrawer,isLogin:${_self.isLogin}');
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Row(
              children: <Widget>[
                Text(getName(), style: TextStyle(color: BBSColors.gray[0])),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: RawChip(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      avatar: CircleAvatar(
                        backgroundColor: BBSColors.gray[5],
                        child: Text('id'),
                      ),
                      label: Text('${_self.id}'),
                    ),
                  ),
              ],
            ),
            accountEmail: Text(
              getEmail(),
            ),
            currentAccountPicture: new GestureDetector(
              onTap: (){_self.isLogin?Get.toNamed('/profile?id=${_self.id}'):Get.toNamed('/login');},
                child: CircleAvatar(
                    backgroundImage:
                        NetworkImage(getImage()))),
          ),
          new ListTile(
            onTap: (){
              _self.isLogin?Get.toNamed('/profile?id=${_self.id}'):Get.toNamed('/login');
            },
            title: Text(
              "主页",
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18.0),
            ),
            leading: Icon(
              Icons.person,
              color: BBSColors.blue,
            ),
          ),
          new ListTile(
            title: Text(
              "信箱",
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18.0),
            ),
            leading: Icon(
              Icons.mail,
              color: BBSColors.green,
            ),
          ),
          new ListTile(
            onTap: () {
              Get.toNamed('/live');
            },
            title: Text(
              "直播",
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18.0),
            ),
            leading: Icon(
              Icons.dashboard,
              color: BBSColors.red,
            ),
          ),
          new ListTile(
            onTap: (){
              Get.toNamed('/tribes/list');
            },
            title: Text(
              "时间线",
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18.0),
            ),
            leading: Icon(
              Icons.timeline,
              color: BBSColors.cyan,
            ),
          ),
          new ListTile(
            onTap: (){
              _self.isLogin?Get.toNamed('/gallery?id=${_self.id}'):Get.toNamed('/login');
            },
            title: Text(
              "相册",
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18.0),
            ),
            leading: Icon(
              Icons.image_outlined,
              color: BBSColors.cyan,
            ),
          ),
          Divider(),
          new ListTile(
            title: Text(
              "Setting",
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18.0),
            ),
            leading: Icon(
              Icons.settings,
              color: BBSColors.black,
            ),
          ),
          new ListTile(
            title: Text(
              "退出登录",
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18.0),
            ),
            leading: Icon(
              Icons.exit_to_app_sharp,
              color: BBSColors.black,
            ),
            onTap: (){
              NetIo().logout().then((value) {
                Fluttertoast.showToast(msg: 'logout $value');
                Get.offAllNamed("/");
              });
            },
          ),
          Divider(),
          MyAboutTile()
        ],
      ),
    );
  }

  ListTile ListTileFac(String title, IconData icon, Color color) {
    return new ListTile(
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18.0),
        ),
        leading: Icon(
          icon,
          color: color,
        ),
      );
  }
}
