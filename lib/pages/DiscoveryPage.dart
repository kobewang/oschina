import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DiscoveryPage extends StatelessWidget {
  static const String TAG_START = "startDivider";
  static const String TAG_END = "endDivider";
  static const String TAG_CENTER = "centerDivider";
  static const String TAG_BLANK = "BlankDivider";
  static const double IMAGE_ICON_WIDTH = 30.0;
  static const double ARROW_ICON_WIDTH = 16.0;
  List itemList = [
    {
      'type': 'divider',
      'title': '',
      'image':'',      
    },
    {
      'type': 'item',
      'title': '开源软件',
      'image':'images/ic_discover_softwares.png',      
    },
    {
      'type': 'shortDivider',
      'title': '',
      'image':'',      
    },
    {
      'type': 'item',
      'title': '码云推荐',
      'image':'images/ic_discover_git.png',      
    },
    {
      'type': 'shortDivider',
      'title': '',
      'image':'',      
    },
    {
      'type': 'item',
      'title': '代码片段',
      'image':'images/ic_discover_gist.png',      
    },
    {
      'type': 'divider',
      'title': '',
      'image':'',      
    },
    {
      'type': 'blank',
      'title': '',
      'image':'',      
    },
    {
      'type': 'divider',
      'title': '',
      'image':'',      
    },    
    {
      'type': 'item',
      'title': '扫一扫',
      'image':'images/ic_discover_scan.png',      
    },
    {
      'type': 'shortDivider',
      'title': '',
      'image':'',      
    },
    {
      'type': 'item',
      'title': '摇一摇',
      'image':'images/ic_discover_shake.png',      
    },
    {
      'type': 'divider',
      'title': '',
      'image':'',      
    },
    {
      'type': 'blank',
      'title': '',
      'image':'',      
    },
    {
      'type': 'item',
      'title': '封面人物',
      'image':'images/ic_discover_nearby.png',      
    },
    {
      'type': 'shortDivider',
      'title': '',
      'image':'',      
    },
    {
      'type': 'item',
      'title': '线下活动',
      'image':'images/ic_discover_pos.png',      
    },
    {
      'type': 'divider',
      'title': '',
      'image':'',      
    },
  ];    
  List listData = [];
  DiscoveryPage() {
    initData();
  }
  initData() {    
  }
  @override
  Widget build(BuildContext context) {
    return new Padding(
      padding:  const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
      child: new ListView.builder(
        itemCount: itemList.length,
        itemBuilder: (context,i) => renderRow(context,i),
      )
    );
  }
  renderRow(BuildContext context,int i) {
    var item = itemList[i];
    switch(item['type']){
      case "item":
      var listItemContent =  new Padding(
        padding:  const EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
        child: new Row(
          children: <Widget>[
            new  Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
              child: new Image.asset(item['image'],width:  IMAGE_ICON_WIDTH,height: IMAGE_ICON_WIDTH),
            ),
            new Expanded(
              child: new Text(item['title'],style:new TextStyle(fontSize: 16.0))
            ),
            new Image.asset('images/ic_arrow_right.png',width: ARROW_ICON_WIDTH,height: ARROW_ICON_WIDTH)
          ],
        ),
      );
      return new InkWell(
        onTap: () {
          handelListItemClick(context,item['title']);
        },
        child:  listItemContent,
      );
      break;
      case "divider":
        return new Divider(height: 1.0,color: Colors.black,);
      break;
      case "shortDivider":
        return new Padding(
          padding: const EdgeInsets.fromLTRB(50.0, 0.0, 0.0, 0.0),
          child: new Divider(height: 1.0,color: Colors.black),
        );
      break;
      case "blank":
        return new Container(height: 25.0);
      break;
    }
  }
  void handelListItemClick(BuildContext context,String title) {
    print(title);
    switch(title){
      case "":break;
    }  
  }
}