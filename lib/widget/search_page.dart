import 'package:bbs_flutter/module/query.dart';
import 'package:bbs_flutter/net/netutil.dart';
import 'package:bbs_flutter/util/colors.dart';
import 'package:bbs_flutter/util/time_format.dart';
import 'package:bbs_flutter/widget/search_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  NetIo _netIo = Get.put(NetIo(),permanent:true);
  TextEditingController _searchTextC = new TextEditingController();
  String dropdownValue = '标题';

  String searchText = '';
  List<QueryBData> data = [];

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: SearchAppBar(
        controller: _searchTextC,
        suffix: dropDownB(),
        onSearch: doSearch,
          onClear:doClean,
      ),
      body: Container(
        width: 500,
        child: textList(),
      ),
    );
  }
  // `\n` 不会触发
  void doSearch(v) {
    print('doSearch($v) type:$dropdownValue');
    searchText = v;
    // title content
    if(dropdownValue == '标题'){
    _netIo.doQuery('title', searchText).then((value){
      data.addAll(value);
      setState(() {});
    });
    } else if(dropdownValue == '正文') {
      _netIo.doQuery('content', searchText).then((value){
        data.addAll(value);
        setState(() {});
      });
    }
  }
  // clean search bar
  void doClean() {
    searchText = '';
    data = [];
    setState(() {});
  }
  Widget textList() {
    Widget divider=Divider(color: BBSColors.gray[5]);
    if(data.length == 0 && searchText=='') {
      return Text('请输入内容');
    } else if(data.length == 0) {
      return Text('暂无');
    }
    return ListView.separated(
      itemCount: data.length,
      itemBuilder: (BuildContext context, int i) {
        var time = TimeFormat().format(data[i].createdAt);
        return ListTile(
          onTap: () {
            Get.toNamed('/post?id=${data[i].id}');
          },
            title: Text("${data[i].title}"),
          // tribeId createdAt creatorId createdAt
          subtitle: Text("创建时间: $time, tid: ${data[i].tribeId}"),
        );
      },
      //分割器构造器
      separatorBuilder: (BuildContext context, int index) {
        return divider;
      },
    );
  }

  Widget dropDownB() => DropdownButton<String>(
  value: dropdownValue,
  onChanged: (String newValue) {
  setState(() {
  dropdownValue = newValue;
  });
  },
  items: <String>['标题', '正文']
      .map<DropdownMenuItem<String>>((String value) {
  return DropdownMenuItem<String>(
  value: value,
  child: Text(value, style: TextStyle(color: BBSColors.gray[5])),
  );
  }).toList(),
  );
}
