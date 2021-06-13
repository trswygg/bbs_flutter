import 'package:bbs_flutter/module/images.dart';
import 'package:bbs_flutter/util/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'image_card.dart';

class Live extends StatelessWidget {
  const Live({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("live"),
      ),
      body: Container(
        color: BBSColors.gray[1],
        padding: EdgeInsets.fromLTRB(6, 50, 6, 6),
        child: ListView(
          children: [
            GestureDetector(
              onTap: () {
                launch('http://bilibili.github.io/flv.js/demo/');
              },
              child: Container(
                width: 200,
                child: Center(
                    child: ImageCard(ImagesBData(
                  id: 1,
                  creatorId: 1,
                  creatorName: 'trswygg',
                  creatorFace: 'face.jpg',
                  imageName: 'http://127.0.0.1/live/movie.flv',
                ))),
              ),
            )
          ],
        ),
      ),
    );
  }
}
