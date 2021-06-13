
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EmptyContent extends StatelessWidget {
  String text;
  IconData icon;
  EmptyContent(String text,IconData icon){
    this.text = text;
    this.icon = icon;
  }
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(icon: Icon(this.icon), iconSize: 100,onPressed: null),
                Text(this.text,style: TextStyle(fontSize: 20,fontWeight: FontWeight.w800),)
              ],
            ),
          )
      ),
    );
  }
}