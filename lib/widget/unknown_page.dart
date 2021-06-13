import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'empty_content.dart';

class UnknownPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('错误路由'),
      ),
      body:  EmptyContent('页面找不到了',Icons.warning_amber_outlined),
    );
  }
}
