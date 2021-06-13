
class LoginB {
  int timestamp;
  int code;
  String result;
  LoginData data;

  LoginB({this.timestamp, this.code, this.result, this.data});

  LoginB.fromJson(Map<String, dynamic> json) {
    timestamp = json['timestamp'];
    code = json['code'];
    result = json['result'];
    data = json['data'] != null ? new LoginData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['timestamp'] = this.timestamp;
    data['code'] = this.code;
    data['result'] = this.result;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class LoginData {
  String key;
  int uID;

  LoginData({this.key, this.uID});

  LoginData.fromJson(Map<String, dynamic> json) {
    key = json['Key'];
    uID = json['UID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Key'] = this.key;
    data['UID'] = this.uID;
    return data;
  }
}
