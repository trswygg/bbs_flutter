import 'package:bbs_flutter/module/post.dart';
import 'package:bbs_flutter/net/netutil.dart';
import 'package:bbs_flutter/util/time_format.dart';
import 'package:bbs_flutter/util/util.dart';
import 'package:bbs_flutter/widget/timeline_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

class PostCard extends StatelessWidget{
  final PostData data;

  PostCard({
    this.data
}){}

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    if(data!= null){
      return drawFromData(data);
    }
    return draw();
  }
  // var _io = Get.put(NetIo(),permanent:true);
  Widget drawFromData(PostData data) {
    return Card(
      color: Color(0xFFEFEFEF),
      child: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 5, 5),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.toNamed('/profile?id=${data.creatorId}');
                    },
                    child: CircleAvatar(
                      child: ClipOval(
                        child: Image.network(
                          data.creatorFace == ""
                              ? NetIo.defaultAvatar
                              : '${NetIo.imageBaseUrl}${data.creatorFace}',
                          width: 128,
                          height: 128,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${data.creatorName}",
                        style: TextStyle(fontSize: 20),
                      ),
                      Text(TimeFormat().format(data.createdAt))
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "uid: ${data.creatorId}",
                        ),
                        SizedBox(
                          height: 5,
                          width: 2,
                        ),
                        Text("tid: ${data.id}")
                      ],
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: InkWell(
                onTap: (){
                  Get.toNamed('/post?id=${data.id}');
                },
                child: Stack(
                  alignment: Alignment.topLeft,
                  children: [
                    ClipRRect(
                      //主图
                      borderRadius: BorderRadius.circular(8),
                      child: CachedNetworkImage(
                        width: 380,
                        imageUrl: data.mainImage == ""
                          ? "${NetIo.baseUrl}/images/bg.jpg"
                          : '${NetIo.baseUrl}/images/${data.mainImage}',
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: Util.buildFromTags(data.tags), //Tags
                        ),
                        Container(
                          height: 145,
                          width: 200,
                        ),
                        Container(
                          color: Color(0x55EEEEEE),
                          child: Text(
                            data.title.length > 11
                                ? "${data.title.substring(0, 11)} ..."
                                : "${data.title}",
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.w400),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                child: Row(
                  children: [
                    Text("来自："),
                    ElevatedButton(
                      style: ButtonStyle(),
                      onPressed: () {
                        if(data?.tribeId != null && data?.tribeId !=0){
                          Get.to(TimeLineView('tribe','${data.tribeId}'));
                        }
                      },
                      child: Text("部落 ${data.tribeName}"),
                    ),
                    Container(
                      width: 2,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        SmartDialog.showToast("未实现的方法");
                      },
                      child: Text("分类 ${data.className}"),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
                padding: const EdgeInsets.all(3),
              child : InteractiveLine(data: data,)
            )
          ],
        ),
      ),
    );
  }

  // draw() draw a null card
  static Widget draw() {
    return Container(
      width: 400,
      height: 350,
      child: Card(
        color: Colors.grey,
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  child: ClipOval(
                    child: Container(
                      // pictures[headSelect],
                      width: 128,
                      height: 128,
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "用户名",
                      style: TextStyle(fontSize: 20),
                    ),
                    Text("时间")
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(left: 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        "uid:",
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text("tid:")
                    ],
                  ),
                )
              ],
            ),
            Stack(
              alignment: Alignment.topLeft,
              children: [
                ClipRRect(

                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      height: 250,
                    )),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        RawChip(
                          label: Text("tag0"),
                        ),
                        RawChip(
                          label: Text("tag1"),
                        ),
                        RawChip(
                          label: Text("tag2"),
                        ),
                      ],
                    ),
                    Container(
                      height: 165,
                    ),
                    Container(
                      color: Color(0x5566ccFF),
                      child: Text(
                        "这里是标题",
                        style: TextStyle(
                            fontSize: 40, fontWeight: FontWeight.w500),
                      ),
                    )
                  ],
                )
              ],
            ),
            Row(
              children: [
                Text("来自："),
                ElevatedButton(
                  onPressed: () {},
                  child: Text("部落"),
                ),
                Container(
                  width: 2,
                ),
                ElevatedButton(
                  onPressed: () {  },
                  child: Text("分类"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

}

class InteractiveLine extends StatefulWidget {
  PostData data;
  @override
  InteractiveLine({
    this.data
});
  State<StatefulWidget> createState() {
    return InteractiveLineState(data: this.data);
  }
}

class InteractiveLineState extends State<InteractiveLine> {
  PostData data;
  var _io = Get.put(NetIo(),permanent:true);
  InteractiveLineState({
    this.data
});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        TextButton.icon( // like
            onPressed: (){
              if(!data.alreadyLike) {
                print("do like");
                _io.doLike(data.id).then((v) {
                  if (v) {
                    data.alreadyLike = true;
                    data.likesCount++;
                    setState(() {});
                  }
                });
              } else {
                print("do unlike");
                _io.doUnLike(data.id).then((v) {
                  if (v) {
                    data.alreadyLike = false;
                    data.likesCount--;
                    setState(() {});
                  }
                });
              }
            },
            icon: data.alreadyLike?Icon(Icons.favorite):Icon(Icons.favorite_border),
            label: Text('点赞 (${data.likesCount})')
        ),
        VerticalDivider(
          color: Colors.grey,
          width: 1,
        ),
        TextButton.icon(
            onPressed: (){
            },
            icon: Icon(Icons.message_rounded),
            label: Text('评论 (${data.replyCount})')
        ),
        VerticalDivider(
          color: Colors.grey,
          width: 1,
        ),
        TextButton.icon( //favor
            onPressed: (){
              if(!data.alreadyFavorite) {
                print("do favor");
                _io.doFavorite(data.id).then((v) {
                  if (v) {
                    data.alreadyFavorite = true;
                    data.favoritesCount++;
                    setState(() {});
                  }
                });
              } else {
                print("do unfavor");
                _io.doUnFavorite(data.id).then((v) {
                  if (v) {
                    data.alreadyFavorite = false;
                    data.favoritesCount--;
                    setState(() {});
                  }
                });
              }
            },
            icon: data.alreadyFavorite?Icon(Icons.star):Icon(Icons.star_border),
            label: Text('收藏 (${data.favoritesCount})')
        ),
      ],
    );
  }

}