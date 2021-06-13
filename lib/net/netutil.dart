import 'package:bbs_flutter/module/cache.dart';
import 'package:bbs_flutter/module/images.dart';
import 'package:bbs_flutter/module/login.dart';
import 'package:bbs_flutter/module/post.dart';
import 'package:bbs_flutter/module/query.dart';
import 'package:bbs_flutter/module/reply.dart';
import 'package:bbs_flutter/module/self.dart';
import 'package:bbs_flutter/module/tags.dart';
import 'package:bbs_flutter/module/tribe.dart';
import 'package:bbs_flutter/module/user.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart' as getx;

class NetIo {
  static final baseUrl = "http://49.232.82.14";
  // static final baseUrl = "http://127.0.0.1";
  static final defaultAvatar = '$baseUrl/images/d.jpg';
  static final defaultImage = '$baseUrl/images/bg.jpg';
  static final imageBaseUrl = '$baseUrl/images/';
  static final NetIo _instance = NetIo._internal();
  factory NetIo() => _instance;
  String _accessKey;
  BaseOptions _op = BaseOptions(
    baseUrl: '$baseUrl/api',
    connectTimeout: 5000,
    receiveTimeout: 3000,
  );
  Dio _dio;
  Cache _cache = getx.Get.put(Cache(),permanent:true);
  NetIo._internal() {
    print("*** NetIo._internal() ***");
    init();
  }

  // 初始化请求配置
  init() {
    _dio = Dio(_op);
    // _dio.interceptors.add(LogInterceptor(requestBody:true,responseBody: true)); //开启请求日志
    _dio.interceptors.add(CookieManager(CookieJar()));
  }



  Future<bool> login(String email, String password) async {
    Self self = getx.Get.put(Self());
    try {
      //open loading
      SmartDialog.showLoading();
      FormData form = FormData.fromMap({"email": email, "password": password});
      Response response = await _dio.post("/user/login", data: form);
      if (response.statusCode == 200) {
        LoginB result = LoginB.fromJson(response.data);
        if (result.code == 0) {
          self.isLogin = true;
          self.accessKey = result.data.key;
          self.id = result.data.uID;
          _accessKey = result.data.key;
          await getUser(result.data.uID).then((v) {
            self.data = v;
            self.email = v.email;
            self.name = v.name;
            SmartDialog.dismiss();
          });
          return true;
        }
      }
      SmartDialog.dismiss();
      return false;
    } catch (exception) {
      print("E: $exception");
      SmartDialog.dismiss();
      return false;
    }
  }

  Future<bool> logout() async {
    Self self = getx.Get.put(Self(),permanent: false);
    try {
      FormData form = FormData.fromMap({"AccessKey": self.accessKey, "id": self.id});
      Response response = await _dio.post("/user/logout", data: form);
      if (response.statusCode == 200) {
        LoginB result = LoginB.fromJson(response.data);
        if (result.code == 0) {
          getx.Get.delete<Self>(force: true);
          return true;
        }
      }
      return false;
    } catch (exception) {
      print("E: $exception");
      return false;
    }
  }

  Future<UserBData> getUser(int id) async {
      try {
        Map<String, dynamic> param = Map();
        param["id"] = id;
        Response response =
            await _dio.get("/user/info", queryParameters: param);
        if (response.statusCode == 200) {
          UserB result = UserB.fromJson(response.data);
          if (result.code == 0) {
            if (!_cache.haveUser(result.data.id)) {
              _cache.insertUser(
                  result.data.id, result.data.name, result.data.face);
            }
            return result.data;
          }
        }
        return null;
      } catch (exception) {
        print("E: $exception");
        return null;
      }
    }

    // timeLine type [all,user,class,tribe,rand,tribes,follow]
  Future<List<QueryBData>> timeLine(String type,String id,int limit, offset) async {
    try {
      Map<String, dynamic> param = Map();
      param["limit"] = limit;
      param["offset"] = offset-1;
      param["type"] = type;
      param["id"] = id;
      param['AccessKey'] = _accessKey;
      Response response =
          await _dio.get("/bbs/post/timeline", queryParameters: param);
      if (response.statusCode == 200) {
        QueryB result = QueryB.fromJson(response.data);
        if (result.replyCode == 0) {
          return result.data;
        }
      }
      return null;
    } catch (exception) {
      print("E: $exception");
      return null;
    }
  }

  Future<List<ImagesBData>> images(int id,int limit, offset) async {
    try {
      Map<String, dynamic> param = Map();
      param["limit"] = limit;
      param["offset"] = offset-1;
      param["id"] = id; // user的id
      param['AccessKey'] = _accessKey;
      Response response =
      await _dio.get("/image/list", queryParameters: param);
      if (response.statusCode == 200) {
        ImagesB result = ImagesB.fromJson(response.data);
        if (result.replyCode == 0) {
          return result.data;
        }
      }
      return null;
    } catch (exception) {
      print("E: $exception");
      return null;
    }
  }


  // get post info
  Future<PostData> onePost(int id,bool content) async {
      if(!content && _cache.havePost(id)) {
        return _cache.getPost(id);
      }
      try {
        Map<String, dynamic> param = Map();
        param["id"] = id;
        param["content"] = content;
        param['AccessKey'] = _accessKey;
        Response response = await _dio.get("/bbs/post", queryParameters: param);
        if (response.statusCode == 200) {
          PostB result = PostB.fromJson(response.data);
          if (result.replyCode == 0) {
            _cache.insertPost(id, result.data);
            return result.data;
          }
        }
        return null;
      } catch (exception) {
        print("E: $exception");
        return null;
      }
    }

    Future<bool> doLike(int id) async {
      Self self = getx.Get.put(Self(),permanent: true);
    if(!self.isLogin) return false;
      FormData form = FormData.fromMap({"post_id": id, "AccessKey": _accessKey});
      Response resp = await _dio.post("/bbs/like", data: form);
      if(resp.data['Result'] == "success" || resp.data['ReplyCode'] == 0) {
        print("doLike($id) success");
        return true;
      }
      return false;
    }

  Future<bool> doFavorite(int id) async {
    Self self = getx.Get.put(Self(),permanent: true);
    if(!self.isLogin) return false;
    FormData form = FormData.fromMap({"post_id": id, "AccessKey": _accessKey});
    Response resp = await _dio.post("/bbs/favorite", data: form);
    if(resp.data['Result'] == "success" || resp.data['ReplyCode'] == 0) {
      print("doFavorite($id) success");
      return true;
    }
    return false;
  }

  Future<bool> doUnLike(int id) async {
    Self self = getx.Get.put(Self(),permanent: true);
    if(!self.isLogin) return false;
    FormData form = FormData.fromMap({"post_id": id, "AccessKey": _accessKey});
    Response resp = await _dio.post("/bbs/unlike", data: form);
    if(resp.data['Result'] == "success" || resp.data['ReplyCode'] == 0) {
      print("doLike($id) success");
      return true;
    }
    return false;
  }

  Future<bool> doUnFavorite(int id) async {
    Self self = getx.Get.put(Self(),permanent: true);
    if(!self.isLogin) return false;
    FormData form = FormData.fromMap({"post_id": id, "AccessKey": _accessKey});
    Response resp = await _dio.post("/bbs/unfavorite", data: form);
    if(resp.data['Result'] == "success" || resp.data['ReplyCode'] == 0) {
      print("doFavorite($id) success");
      return true;
    }
    return false;
  }

  // :text:text_type:limit:offset
  Future<List<QueryBData>> doQuery(String type,text) async {
      Map<String, dynamic> param = Map();
  param["text"] = text;
  param["text_type"] = type;
  param['limit'] = 15;
  param['offset'] = 0;
  Response response = await _dio.get("/bbs/post/query", queryParameters: param);
  if (response.statusCode == 200) {
    QueryB result = QueryB.fromJson(response.data);
    return result.data;
  }
  return null;
  }

  // do create post
  // tribe_id	1
  // AccessKey	d
  // title	这是一条测试帖子
  // content	#这是一条测试帖子 \n [TOC] \n \n> 这是一条测试帖子
  // tag_ids	1,2,3,4
  // main_image	bg1.jpg
  Future<bool> doCreatePost(int tribeId,title,content,tagIds,mainImage) async {
    Self self = getx.Get.put(Self(),permanent: true);
    if(!self.isLogin) return false;
    FormData form = FormData.fromMap({
      "tribe_id": tribeId,
      "AccessKey": _accessKey,
      "title": title,
      "content":content,
      "tag_ids":tagIds,
      "main_image":mainImage
    });
    Response resp = await _dio.post("/bbs/post/create", data: form);
    if(resp.data['Result'] == "success" || resp.data['ReplyCode'] == 0) {
      print("doCreatePost($tribeId,$title) success");
      return true;
    }
    return false;
  }

  Future<Replys> doCreateReply(int postId,parentId,content) async {
    SmartDialog.showLoading();
    Self self = getx.Get.put(Self(),permanent: true);
    if(!self.isLogin) return null;
    FormData form = FormData.fromMap({
      "post_id": postId,
      "parent_id": parentId,
      "AccessKey": _accessKey,
      "content":content,
    });
    Response resp = await _dio.post("/bbs/reply/create", data: form);
    if (resp.statusCode == 200) {
      ReplyB result = ReplyB.fromJson(resp.data);
      SmartDialog.dismiss();
      return result.data;
    }
    SmartDialog.dismiss();
    return null;
  }

  Future<List<TribeBData>> doTribeList(int id) async {
    Map<String, dynamic> param = Map();
    param["id"] = id;
    Response response = await _dio.get("/bbs/tribe/list", queryParameters: param);
    if (response.statusCode == 200) {
      TribeB result = TribeB.fromJson(response.data);
      if (result.replyCode == 0) {
        return result.data;
      }
    }
    return null;
  }
  Future<List<Tags>> doTagList() async {
    Response response = await _dio.get("/bbs/tag/query");
    if (response.statusCode == 200) {
      TagsB result = TagsB.fromJson(response.data);
      if (result.replyCode == 0) {
        return result.data;
      }
    }
    return null;
  }
}
