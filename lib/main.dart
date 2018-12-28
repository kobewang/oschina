import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import './pages/NewsListPage.dart';
import './pages/DiscoveryPage.dart';
import './pages/TweetsListPage.dart';
import './pages/MyInfoPage.dart';
import './widgets/MyDrawer.dart';
import './pages/SpTest.dart';
import './pages/PublishPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {  
  @override
  MyAppState createState()=> MyAppState();
}
class MyAppState extends State<MyApp> {
  int _tabIndex = 0;//页面当前选中的Tab的索引
  var tabImages;
  var appBarTitles = ['资讯','动弹','发现','我的'];
  final tabTextStyleNormal = new TextStyle(color:  const Color(0xff969696));//未选中字体颜色
  final tabTextStyleSelected = new TextStyle(color: const Color(0xff63ca6c));//选中字体
  var _body;
  Image getTabImage(path) {
    return new Image.asset(path,width:20.0,height:20.0);
  }
  //数据初始化
    void initData() {
      if(tabImages == null) {
        tabImages = [
          [getTabImage('images/ic_nav_news_normal.png'),getTabImage('images/ic_nav_news_actived.png')],
          [getTabImage('images/ic_nav_tweet_normal.png'),getTabImage('images/ic_nav_tweet_actived.png')],
          [getTabImage('images/ic_nav_discover_normal.png'),getTabImage('images/ic_nav_discover_actived.png')],
          [getTabImage('images/ic_nav_my_normal.png'),getTabImage('images/ic_nav_my_pressed.png')],          
        ];
      }
     _body = new IndexedStack(    
      children: <Widget>[
        new NewsListPage(),
        //new TweetsListPage(),
        new PublishPage(),
        //new DiscoveryPage(),
        new SpTest(),
        new MyInfoPage()
      ],
      index: _tabIndex,
      );
    }
    
    Image getTabIcon(int curIndex) {
      if(curIndex == _tabIndex) return tabImages[curIndex][1];
      return tabImages[curIndex][0];
    }
    TextStyle getTabTextStyle(int curIndex) {
      if(curIndex == _tabIndex) return tabTextStyleSelected;
      return tabTextStyleNormal; 
    }
    Text getTabTitle(int curIndex) {
      return new Text(appBarTitles[curIndex],style: getTabTextStyle(curIndex));
    }

    List<BottomNavigationBarItem> getBottomNavItems() {
      List<BottomNavigationBarItem> list= new List();
      for(int i=0; i<4; i++) {
        list.add(new BottomNavigationBarItem(icon: getTabIcon(i),title: getTabTitle(i)));
      }
      return list;
    }
  @override
  Widget build(BuildContext context) {    
    initData();     
    return new MaterialApp(
      theme: new ThemeData(primaryColor: const Color(0xFF63CA6C)),//设置页面的主题色
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text('My OSC',style: new TextStyle(color: Colors.white)), //设置APPBAR的标题
          iconTheme: new IconThemeData(color: Colors.white)//设置APPBAR上图标的样式          
         ),
         body: _body, 
         bottomNavigationBar: new  CupertinoTabBar(
           items: getBottomNavItems(),
           currentIndex: _tabIndex,
           onTap: (index) {setState(() {_tabIndex=index;});},// 底部TabItem的点击事件处理，点击时改变当前选择的Tab的索引值，则页面会自动刷新
         ),// bottomNavigationBar属性为页面底部添加导航的Tab，CupertinoTabBar是Flutter提供的一个iOS风格的底部导航栏组件
         drawer: new MyDrawer(),
      ),
    );
  }
}

