class PostB {
  int time;
  int replyCode;
  String result;
  int count;
  PostData data;

  PostB({this.time, this.replyCode, this.result, this.count, this.data});

  PostB.fromJson(Map<String, dynamic> json) {
    time = json['Time'];
    replyCode = json['ReplyCode'];
    result = json['Result'];
    count = json['Count'];
    data = json['Data'] != null ? new PostData.fromJson(json['Data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Time'] = this.time;
    data['ReplyCode'] = this.replyCode;
    data['Result'] = this.result;
    data['Count'] = this.count;
    if (this.data != null) {
      data['Data'] = this.data.toJson();
    }
    return data;
  }
}

class PostData {
  int id;
  String createdAt;
  String updatedAt;
  int tribeId;
  int creatorId;
  String mainImage;
  String title;
  String content;
  List<Tags> tags;
  List<Replys> replys;
  Null favorites;
  Null likes;
  int favoritesCount;
  int likesCount;
  int replyCount;
  String creatorName;
  String creatorFace;
  bool alreadyFavorite;
  bool alreadyLike;
  String tribeName;
  String className;

  PostData(
      {this.id,
        this.createdAt,
        this.updatedAt,
        this.tribeId,
        this.creatorId,
        this.mainImage,
        this.title,
        this.content,
        this.tags,
        this.replys,
        this.favorites,
        this.likes,
        this.favoritesCount,
        this.likesCount,
        this.replyCount,
        this.creatorName,
        this.creatorFace,
        this.alreadyFavorite,
        this.alreadyLike,
        this.tribeName,
        this.className});

  PostData.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    createdAt = json['CreatedAt'];
    updatedAt = json['UpdatedAt'];
    tribeId = json['TribeId'];
    creatorId = json['CreatorId'];
    mainImage = json['MainImage'];
    title = json['Title'];
    content = json['Content'];
    if (json['Tags'] != null) {
      tags = <Tags>[];
      json['Tags'].forEach((v) {
        tags.add(new Tags.fromJson(v));
      });
    }
    if (json['Replys'] != null) {
      replys = <Replys>[];
      json['Replys'].forEach((v) {
        replys.add(new Replys.fromJson(v));
      });
    }
    favorites = json['Favorites'];
    likes = json['Likes'];
    favoritesCount = json['FavoritesCount'];
    likesCount = json['LikesCount'];
    replyCount = json['ReplyCount'];
    creatorName = json['CreatorName'];
    creatorFace = json['CreatorFace'];
    alreadyFavorite = json['AlreadyFavorite'];
    alreadyLike = json['AlreadyLike'];
    tribeName = json['TribeName'];
    className = json['ClassName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['CreatedAt'] = this.createdAt;
    data['UpdatedAt'] = this.updatedAt;
    data['TribeId'] = this.tribeId;
    data['CreatorId'] = this.creatorId;
    data['MainImage'] = this.mainImage;
    data['Title'] = this.title;
    data['Content'] = this.content;
    if (this.tags != null) {
      data['Tags'] = this.tags.map((v) => v.toJson()).toList();
    }
    if (this.replys != null) {
      data['Replys'] = this.replys.map((v) => v.toJson()).toList();
    }
    data['Favorites'] = this.favorites;
    data['Likes'] = this.likes;
    data['FavoritesCount'] = this.favoritesCount;
    data['LikesCount'] = this.likesCount;
    data['ReplyCount'] = this.replyCount;
    data['CreatorName'] = this.creatorName;
    data['CreatorFace'] = this.creatorFace;
    data['AlreadyFavorite'] = this.alreadyFavorite;
    data['AlreadyLike'] = this.alreadyLike;
    data['TribeName'] = this.tribeName;
    data['ClassName'] = this.className;
    return data;
  }
}

class Tags {
  int id;
  String name;
  String color;

  Tags({this.id, this.name, this.color});

  Tags.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    name = json['Name'];
    color = json['Color'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['Name'] = this.name;
    data['Color'] = this.color;
    return data;
  }
}

class Replys {
  int id;
  String createdAt;
  String updatedAt;
  int creatorId;
  int postId;
  String content;
  int parentId;

  Replys(
      {this.id,
        this.createdAt,
        this.updatedAt,
        this.creatorId,
        this.postId,
        this.content,
        this.parentId});

  Replys.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    createdAt = json['CreatedAt'];
    updatedAt = json['UpdatedAt'];
    creatorId = json['CreatorId'];
    postId = json['PostId'];
    content = json['Content'];
    parentId = json['ParentId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['CreatedAt'] = this.createdAt;
    data['UpdatedAt'] = this.updatedAt;
    data['CreatorId'] = this.creatorId;
    data['PostId'] = this.postId;
    data['Content'] = this.content;
    data['ParentId'] = this.parentId;
    return data;
  }
}