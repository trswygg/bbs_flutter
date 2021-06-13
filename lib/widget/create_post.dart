import 'package:bbs_flutter/module/post.dart';
import 'package:bbs_flutter/module/tribe.dart';
import 'package:bbs_flutter/net/netutil.dart';
import 'package:bbs_flutter/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hex_color/flutter_hex_color.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class CreatePost extends StatefulWidget {
  const CreatePost({Key key}) : super(key: key);

  @override
  _CreatePostState createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  var _io = Get.put(NetIo(), permanent: true);
  final FocusNode _focusNode = new FocusNode();
  int selectedClass = 0;
  int selectedTribe = 0;
  String title, content, mainImage = "";
  TextEditingController cTitle, cContent, cMainImage;
  List<int> _tags;
  @override
  initState() {
    super.initState();
    title = "";
    content = "";
    mainImage = "";
    _tags = [];
    cTitle = new TextEditingController();
    cContent = new TextEditingController();
    cMainImage = new TextEditingController();
  }
  // TODO Tage use FilterChip


  _classSelector() {
    return DropdownButton(
      value: selectedClass,
      items: [
        DropdownMenuItem(
          child: Text('   '),
          value: 0,
        ),
        DropdownMenuItem(child: Text('杂谈'), value: 1),
        DropdownMenuItem(child: Text('时间线'), value: 2),
        DropdownMenuItem(child: Text('亚文化'), value: 3),
        DropdownMenuItem(child: Text('科技'), value: 4),
        DropdownMenuItem(child: Text('影视'), value: 5),
        DropdownMenuItem(child: Text('值班室'), value: 6),
      ],
      onChanged: (value) {
        setState(() {
          selectedClass = value;
        });
      },
    );
  }

  _tribeSelector() {
    Widget d = DropdownButton(
      disabledHint: Text('请选择分类'),
      items: [
        DropdownMenuItem(
          child: Text('杂谈'),
          value: 1,
        ),
      ],
    );
    if (selectedClass == 0) {
      return d;
    }
    return FutureBuilder(
      future: _io.doTribeList(selectedClass),
      builder: (BuildContext ctx, AsyncSnapshot<List<TribeBData>> tribes) {
        if (tribes.connectionState != ConnectionState.done) {
          return d;
        }
        if (tribes.hasData) {
          selectedTribe = tribes.requireData[0].id;
          return _drawTribeItems(tribes.requireData);
        }
        return Container(width: 400, height: 50, child: Text('loading...'));
      },
    );
  }

  _tagSelector() {
    return FutureBuilder(
      future: _io.doTagList(),
      builder: (BuildContext ctx, AsyncSnapshot<List<Tags>> tribes) {
        if (tribes.connectionState != ConnectionState.done) {
          return Container(width: 1,height: 1,);
        }
        if (tribes.hasData) {
          return Wrap(
              spacing: 5,
              children:_drawTags(tribes.requireData)
          );
        }
        return Container(width: 400, height: 50, child: Text('loading...'));
      },
    );
  }
  List<Widget> _drawTags(List<Tags> tags){
    List<Widget> result = <Widget>[];
    if (tags != null) {
      tags.forEach((value) {
        result.add(new FilterChip(
          backgroundColor: HexColor(value.color),
          label: Text(value.name),
          selected: _tags.contains(value.id),
            onSelected: (v) {
              setState(() {
                if(v){
                  _tags.add(value.id);
                }else{
                  _tags.removeWhere((f){
                    return f == value.id;
                  });
                }
              });
          }
        )
        );
      });
    }
    if(result.length == 0) {
      result.add(Container(width: 10,height: 10,));
    }
    return result;
  }

  Widget _drawTribeItems(List<TribeBData> items) {
    List<DropdownMenuItem<int>> menus = [];
    items.forEach((e) {
      print("$e");
      menus.add(_oneMenu('${e.name}(${e.postsCount})', e.id));
    });
    return DropdownButton(
      value: selectedTribe,
      items: menus,
      onChanged: (value) {
        setState(() {
          selectedTribe = value;
        });
      },
    );
  }

  DropdownMenuItem<int> _oneMenu(String label, id) {
    return DropdownMenuItem(child: Text(label), value: id);
  }

  // =================== BUILD ===================
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Get.back();
              }),
          title: Text("创建帖子"),
          actions: <Widget>[
            new IconButton( // 发布
                icon: new Icon(Icons.done),
                tooltip: '预览',
                onPressed: () {
                  setState(() {
                    title = cTitle.text;
                    content = cContent.text;
                    mainImage = cMainImage.text;
                  });
                }
            ),
            IconButton( // 发布
                icon: new Icon(Icons.send),
                tooltip: '预览',
                onPressed: () {
                  var _tagsString = _tags.join(',');
                  Fluttertoast.showToast(
                      msg: '发布 \n title:$title content:(${content.length}) \n mainImage:$mainImage tags:$_tagsString');
                  _io.doCreatePost(selectedTribe,title,content,_tagsString,mainImage).then((value) {
                    if (value == true) {
                      Get.back();
                    } else {
                      Fluttertoast.showToast(msg: "发送失败");
                    }
                  });
                }
            ),
          ],
          bottom: TabBar(
            tabs: <Widget>[
              Tab(text: "编辑"),
              Tab(text: "预览"),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            Container(
              width: 500,
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20, 5, 20, 2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _empty(),
                      _classSelector(),
                      _tribeSelector(),
                      _tagSelector(),
                      _divider(),
                      _textField("标题", "在这里输入标题", cTitle),
                      _textField("封面图", "在这里输入封面图文件名", cMainImage), // 封面图
                      _buildEditor()
                    ],
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: Markdown(
                data: content,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _textField(String label, hint, TextEditingController c) => TextField(
        autofocus: true,
        controller: c,
        decoration: InputDecoration(
            labelText: label,
            hintText: hint,
            prefixIcon: Icon(Icons.border_color)),
      );

  Widget _empty() => Container(
        width: 100,
        height: 50,
      );
  Widget _divider() => Divider(
        height: 50,
        indent: 10,
        color: BBSColors.cyan,
      );
  Widget _buildEditor() {
    return TextField(
      maxLines: null,
      minLines: 15,
      controller: cContent,
      decoration:InputDecoration(
          hintText:"请输入文章内容",
          border:OutlineInputBorder()
      ),
    );
  }
}
