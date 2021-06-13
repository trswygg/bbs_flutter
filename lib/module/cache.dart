import 'package:bbs_flutter/module/post.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class Cache extends GetxController{
  var _users = new Map();
  var _posts = new Map();
  UserCache getUser(int id) {
    return _users[id];
  }
  void insertUser(int id,String name,String face) {
    _users[id] = UserCache(id,name,face);
  }
  bool haveUser(int id) {
    return _users.containsKey(id);
  }
  PostData getPost(int id) {
    return _posts[id];
  }
  void insertPost(int id,PostData data) {
    _posts[id] = data;
  }
  bool havePost(int id) {
    return _posts.containsKey(id);
  }
}

class UserCache {
  int id;
  String name;
  String face;
  UserCache(int id,String name,String face) {
    this.id = id;
    this.name = name;
    this.face = face;
  }
}