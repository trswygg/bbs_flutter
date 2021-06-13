class UserB {
  int timestamp;
  int code;
  String result;
  UserBData data;

  UserB({this.timestamp, this.code, this.result, this.data});

  UserB.fromJson(Map<String, dynamic> json) {
    timestamp = json['timestamp'];
    code = json['code'];
    result = json['result'];
    data = json['data'] != null ? new UserBData.fromJson(json['data']) : null;
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

class UserBData {
  int id;
  String createdAt;
  String updatedAt;
  String name;
  String email;
  String face;
  int exp;
  int prestige;
  String banTime;
  String muteTime;
  String lastLogin;
  Profile profile;
  int userGroupId;
  int favoritesCount;
  int likesCount;
  int imagesCount;
  int classesCount;
  int tribesCount;
  int postsCount;
  int replysCount;
  int followsCount;
  int fansCount;

  UserBData(
      {this.id,
        this.createdAt,
        this.updatedAt,
        this.name,
        this.email,
        this.face,
        this.exp,
        this.prestige,
        this.banTime,
        this.muteTime,
        this.lastLogin,
        this.profile,
        this.userGroupId,
        this.favoritesCount,
        this.likesCount,
        this.imagesCount,
        this.classesCount,
        this.tribesCount,
        this.postsCount,
        this.replysCount,
        this.followsCount,
        this.fansCount
      });

  UserBData.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    createdAt = json['CreatedAt'];
    updatedAt = json['UpdatedAt'];
    name = json['Name'];
    email = json['Email'];
    face = json['Face'];
    exp = json['Exp'];
    prestige = json['Prestige'];
    banTime = json['BanTime'];
    muteTime = json['MuteTime'];
    lastLogin = json['LastLogin'];
    profile =
    json['Profile'] != null ? new Profile.fromJson(json['Profile']) : null;
    userGroupId = json['UserGroupId'];
    favoritesCount = json['FavoritesCount'];
    likesCount = json['LikesCount'];
    imagesCount = json['ImagesCount'];
    classesCount = json['ClassesCount'];
    tribesCount = json['TribesCount'];
    postsCount = json['PostsCount'];
    replysCount = json['ReplysCount'];
    followsCount = json['FollowsCount'];
    fansCount = json['FansCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['CreatedAt'] = this.createdAt;
    data['UpdatedAt'] = this.updatedAt;
    data['Name'] = this.name;
    data['Email'] = this.email;
    data['Face'] = this.face;
    data['Exp'] = this.exp;
    data['Prestige'] = this.prestige;
    data['BanTime'] = this.banTime;
    data['MuteTime'] = this.muteTime;
    data['LastLogin'] = this.lastLogin;
    if (this.profile != null) {
      data['Profile'] = this.profile.toJson();
    }
    data['UserGroupId'] = this.userGroupId;
    data['FavoritesCount'] = this.favoritesCount;
    data['LikesCount'] = this.likesCount;
    data['ImagesCount'] = this.imagesCount;
    data['ClassesCount'] = this.classesCount;
    data['TribesCount'] = this.tribesCount;
    data['PostsCount'] = this.postsCount;
    data['ReplysCount'] = this.replysCount;
    data['FollowsCount'] = this.followsCount;
    data['FansCount'] = this.fansCount;
    return data;
  }
}

class Profile {
  int id;
  String createdAt;
  String updatedAt;
  int userId;
  String mainImage;
  String sign;
  String phone;
  int phoneVisibility;
  String email;
  int emailVisibility;
  int age;
  int ageVisibility;
  String sex;
  int sexVisibility;
  String birthday;
  int birthdayVisibility;

  Profile(
      {this.id,
        this.createdAt,
        this.updatedAt,
        this.userId,
        this.mainImage,
        this.sign,
        this.phone,
        this.phoneVisibility,
        this.email,
        this.emailVisibility,
        this.age,
        this.ageVisibility,
        this.sex,
        this.sexVisibility,
        this.birthday,
        this.birthdayVisibility});

  Profile.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    createdAt = json['CreatedAt'];
    updatedAt = json['UpdatedAt'];
    userId = json['UserId'];
    mainImage = json['MainImage'];
    sign = json['Sign'];
    phone = json['Phone'];
    phoneVisibility = json['PhoneVisibility'];
    email = json['Email'];
    emailVisibility = json['EmailVisibility'];
    age = json['Age'];
    ageVisibility = json['AgeVisibility'];
    sex = json['Sex'];
    sexVisibility = json['SexVisibility'];
    birthday = json['Birthday'];
    birthdayVisibility = json['BirthdayVisibility'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['CreatedAt'] = this.createdAt;
    data['UpdatedAt'] = this.updatedAt;
    data['UserId'] = this.userId;
    data['MainImage'] = this.mainImage;
    data['Sign'] = this.sign;
    data['Phone'] = this.phone;
    data['PhoneVisibility'] = this.phoneVisibility;
    data['Email'] = this.email;
    data['EmailVisibility'] = this.emailVisibility;
    data['Age'] = this.age;
    data['AgeVisibility'] = this.ageVisibility;
    data['Sex'] = this.sex;
    data['SexVisibility'] = this.sexVisibility;
    data['Birthday'] = this.birthday;
    data['BirthdayVisibility'] = this.birthdayVisibility;
    return data;
  }
}
