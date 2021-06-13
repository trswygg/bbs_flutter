// import 'dart:html';
import 'package:bbs_flutter/module/images.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ImageCard extends StatelessWidget {
   String img;
   String title;
   String author;
   String authorUrl;
   String type;
   double worksAspectRatio;
   static const _baseURL = "http://127.0.0.1/images/";
  ImageCard(ImagesBData data){
    this.img = _baseURL + data.imageName;
    this.title = data.imageName;
    this.author = data.creatorName;
    this.authorUrl = data.creatorFace;
    this.type = "";
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            color: Colors.deepOrange,
            child: CachedNetworkImage(
                imageUrl: '$img'
            ),
          ),
          Container(
            padding:
            EdgeInsets.symmetric(horizontal: 20),
            margin: EdgeInsets.symmetric(vertical: 10),
            child: Text(
              '$title',
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Container(
            padding: EdgeInsets.only(
                left: 20,
                bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                CircleAvatar(
                  backgroundImage: NetworkImage('$authorUrl'),
                  radius: 30,
                  // maxRadius: 40.0,
                ),
                Container(
                  margin: EdgeInsets.only(left:20),
                  width: 250,
                  child: Text(
                    '$author',
                    style: TextStyle(
                      fontSize: 25,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 80),
                  child: Text(
                    '${type == 'EXISE' ? '练习' : '其他'}',
                    style: TextStyle(
                      fontSize: 25,
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
