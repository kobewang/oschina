import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class PublishPage extends StatefulWidget {
  @override
  PublishPageState createState()=> PublishPageState();
}
class PublishPageState extends State<PublishPage> {
  List<File> fileList = new List();
  TextEditingController _controller = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("发布信息", style:new TextStyle(color: Colors.white)),
        iconTheme: new IconThemeData(color: Colors.white),
        actions: <Widget>[
          new Builder(
            builder: (ctx) {
              return new FlatButton(
                color: Colors.blue,
                highlightColor: Colors.blue[700],
                colorBrightness: Brightness.dark,
                splashColor: Colors.grey,
                child: Text('发布'),
                onPressed: () {
                  print('published');
                }
              );
            },
          )
        ],
      ),
      body: getBody(),
    );
  }
  Widget getBody() {
    var textFiled = new TextField(
      decoration: new InputDecoration(
        hintText: '说点什么吧。。',
        hintStyle: new TextStyle(color: const Color(0xFF808080)),
        border: new OutlineInputBorder(borderRadius: const BorderRadius.all(const Radius.circular(10.0)))
      ),
      maxLines: 6,
      maxLength: 150,
      controller: _controller,
    );
    //gridView用来显示选择的图片
    var gridView = new Builder(
      builder: (ctx) {
        return new GridView.count(
          crossAxisCount: 4,//分4列显示
          children: new List.generate(fileList.length+1, (index){
            //这个方法用于生成GridView中的一个item
            var content;
            if (index == 0) {
              //添加图片按钮
              var addCell = new Center(child: new  Image.asset('./images/ic_add_pics.png',width: 80.0,height: 80.0));
              content = new GestureDetector(
                onTap: (){ },//点击添加图片              
                child: addCell,
              );
            } else {
              //被选中的图片
              content = new Center(child: new Image.file(fileList[index - 1],width: 80.0, height: 80.0, fit: BoxFit.cover));
            }
            
          }),
        );
      },
    );
    var children = [
      new Text('提示：由于信息发布实名制，巴拉巴拉巴拉巴拉巴拉巴拉巴拉巴拉巴拉巴拉巴拉巴拉巴拉巴拉巴拉巴拉巴拉巴拉巴拉巴拉巴拉巴拉巴拉巴拉。。'),
      textFiled      
    ];
    return new Container(
      padding: const EdgeInsets.all(5.0),
      child: new Column(
        children: children,
      )
    );
  }
}