import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../pages/DiscoveryPage.dart';
import '../pages/SpTest.dart';
import '../pages/PublishPage.dart';
class MyDrawer extends StatelessWidget {
  static const double IMAGE_ICON_WIDTH = 30.0;
  static const double ARROW_ICON_HEIGHT = 16.0;
  var rightArrowIcon = new Image.asset('images/ic_arrow_right.png',width:ARROW_ICON_HEIGHT,height:ARROW_ICON_HEIGHT);
  List menuTitles = ['发布动弹','动弹小黑屋','关于','设置'];    //菜单文本
  List menuIcons=[
    './images/leftmenu/ic_fabu.png',
    './images/leftmenu/ic_xiaoheiwu.png',
    './images/leftmenu/ic_about.png',
    './images/leftmenu/ic_settings.png'
  ];//菜单图标
  TextStyle menuStyle = new TextStyle( fontSize: 15.0);
  @override
  Widget build(BuildContext context) {
    return new ConstrainedBox(
      constraints: new BoxConstraints.expand(width: 304.0),//指定了侧滑菜单的宽度
      child: new Material(
        elevation: 16.0,//Drawer后面的阴影的大小，默认值就是16
        child: new Container(
          decoration: new BoxDecoration(color:new Color(0xFFFFFFFF)),
          child: new ListView.builder(
            itemCount: menuTitles.length*2+1,//大图+间隔
            itemBuilder: renderRow,
          )
        )        
      )
    );//实现Drawer类的源码
  }
  Widget getIconImage(String path) {
    return new Padding(
      padding: new EdgeInsets.fromLTRB(2.0, 0.0, 6.0, 0.0),
      child: new Image.asset(path,width:28.0,height:28.0),
    );
  }
  Widget renderRow(BuildContext context, int index) {
    if (index==0) {
      return new Container(
        width: 304.0,
        height: 304.0,
        margin: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
        child: new Image.asset('images/cover_img.jpg',width:304.0,height:304.0),
      );
    }
      if (index.isOdd) {
        return new Divider();
      } //奇数
      index-=1;
      index = index ~/2;//除2取整
      //菜单item组件
      var listItemContent = new Padding(
        padding: new EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
        child: new Row(
          children: <Widget>[
            getIconImage(menuIcons[index]),//图标
            new Expanded(child: new Text(menuTitles[index],style: menuStyle)),
            rightArrowIcon
          ],
        ),
      );
      return new InkWell(
        child: listItemContent,
        onTap: (){
          switch(index) {
            case 0:Navigator.of(context).push(new MaterialPageRoute(builder: (ctx){ return new PublishPage(); })); break;
            case 1:Navigator.of(context).push(new MaterialPageRoute(builder: (ctx){ return new SpTest(); })); break;
            case 2:Navigator.of(context).push(new MaterialPageRoute(builder: (ctx){ return new DiscoveryPage(); })); break;
            case 3:Navigator.of(context).push(new MaterialPageRoute(builder: (ctx){ return new DiscoveryPage(); })); break;
          }
        },
      );
    
  }
}