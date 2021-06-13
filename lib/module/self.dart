import 'package:bbs_flutter/module/user.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class Self extends GetxController{
  bool isLogin = false;
  String accessKey = "";
  int id = 0;
  String name = "";
  String email = "";
  String image = "";
  UserBData data;
}