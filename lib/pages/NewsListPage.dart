import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../widgets/SlideView.dart';
import '../util/NetUtils.dart';
import '../api/api.dart';
import '../constants/Constants.dart';

class NewsListPage extends StatefulWidget {
  @override
  NewsListPageState createState()=> new NewsListPageState();
}

class NewsListPageState extends State<NewsListPage> {
  TextStyle titleTextStyle = new TextStyle(fontSize: 15.0);//列表资讯标题
  TextStyle subtitleStyle = new TextStyle(color: const Color(0xFFB5BDC0),fontSize: 12.0);
  ScrollController _controller = new ScrollController();
  var slideData = [];//轮播图数据
  var listData = []; //listView列表数据
  var listTotalSize = 0;//列表总数
  var curPage = 1;
  NewsListPageState() {
    _controller.addListener(() {
     var maxScroll = _controller.position.maxScrollExtent; //列表最大滚动距离
     var pixels = _controller.position.pixels; //当前列表向下滚动的距离
     if (maxScroll == pixels && listData.length < listTotalSize) {
       //两个值相等表示滚动到底，但数据还没有加载完，则加载下一页
       curPage++;
       getNewsList(true); //获取下一页
     }
    });
  }

  @override
  void initState() {
    super.initState();
    getNewsList(false);
  }
  @override
  Widget build(BuildContext context) {
    if (listData == null) {
      return new Center(child: new CircularProgressIndicator());//加载中
    } else {
      Widget listView = new  ListView.builder(
        itemCount: listData.length * 2,
        itemBuilder: (context, i) => renderRow(i),
        controller: _controller,//监听滚动
      );
      return new RefreshIndicator(child: listView,onRefresh: _pullToRefresh);//增加下拉刷新
    }      
  }

  //下拉刷新
  Future<Null> _pullToRefresh() async {
    curPage = 1;
    getNewsList(false);
    return null;
  }

  //加载数据
  getNewsList(bool isLoadingMore) {
    String url = Api.NEWS_LIST+"?pageIndex=${curPage}&pageSize=10";
    NetUtils.get(url).then((data) {
      if (data != null) {
        var map = json.decode(data);
        if (map['code'] == 0) {
          var msg = map['msg'];
          listTotalSize = msg['news']['total'];
          var _listData = msg['news']['data'];
          var _slideData = msg['slide'];
          setState(() {
            if(!isLoadingMore) { //首次加载直接赋值
              listData = _listData;
              slideData = _slideData;              
            } else {
              //翻页加载则追加数据
              listData.addAll(_listData);
              if(listData.length >= listTotalSize) { //获取所有，则显示我也是有底线的
                listData.add(Constants.END_LINE_TAG);
              }
              /*
              List list1 = new List();
              list1.addAll(listData);
              list1.addAll(_listData);              
              if(list1.length >= listTotalSize) { //获取所有，则显示我也是有底线的
                list1.add(Constants.END_LINE_TAG);
              }
              listData = list1;
              */
            }
          });
        }
      }
    });
  }

   //渲染列表Item
  Widget renderRow(i) {
    if (i ==0) {
      return new Container(
        height: 180.0,
        child: new SlideView(slideData),
      );
    }
    i-=1;
    if(i.isOdd) {
      return new Divider(height: 1.0);
    }
    i = i ~/2;
    //得到列表item的数据
    var itemData = listData[i];
    var titleRow = new Row(
      children: <Widget>[new  Expanded(child: new Text(itemData['title'],style: titleTextStyle,),)], //标题充满一整行,所以用expanded包裹
    );
    var timeRow = new Row(
      children: <Widget>[
        new Container(
          width: 20.0,
          height: 20.0,
          decoration: new BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFFECECEC),
            image: new DecorationImage(image: new NetworkImage(itemData['authorImg']), fit:BoxFit.cover ),
            border: new Border.all(color: const Color(0xFFECECEC),width: 2.0)
          ),
        ),
        new Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
          child: new Text(itemData['timeStr'],style: subtitleStyle),
        ),
        new Expanded(
          flex: 1,
          child: new Row(
            //为了让评论数在最右侧，需要外面的Expanded和MainAxisAligment.end
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              new Text("${itemData['commCount']}",style: subtitleStyle),
              new Image.asset('./images/ic_comment.png',width: 16.0,height: 16.0,)
            ],
          ),
        )
      ],
    );
    var thumbImgUrl = itemData['thumb'];    
    var thumbImg = new Container(
      margin: const EdgeInsets.all(10.0),
      width: 60.0,
      height: 60.0,
      decoration: new BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFFECECEC),
        image: new DecorationImage(
          image: thumbImgUrl!=null && thumbImgUrl.length > 0?new NetworkImage(thumbImgUrl): ExactAssetImage('./images/ic_img_default.jpg'),
          fit: BoxFit.cover
        ),
        border: new Border.all(color: const Color(0xFFECECEC),width: 2.0)
      ),
    );
    //这里的row代表ListItem的一行
    var row = new Row(
      children: <Widget>[
        //左边是标题，时间，评论数
        new Expanded(
          flex: 1,
          child: new Padding(
            padding:  const EdgeInsets.all(10.0),
            child: new Column(
              children: <Widget>[
                titleRow,
                new Padding(padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),child: timeRow,)
              ],
            ),
          ),
        ),
        //右边是资讯图片
        new Padding(
          padding:  const EdgeInsets.all(6.0),
          child: new Container(
            width: 100.0,
            height: 80.0,
            color: const Color(0xFFECECEC),
            child: new Center(child: thumbImg),
          ),
        )
      ],
    );
    return new InkWell(
      child: row,
      onTap:(){}
    );
  }
}
/*
  
  
  NewsListPage() {
    for (var i = 0;i < 3; i++) {
      Map map= new Map();
      map['title']='Python 之父透露退位隐情，与核心开发团队产生隔阂';
      map['detailUrl']='https://www.oschina.net/news/98455/guido-van-rossum-resigns';
      map['imgUrl']='https://static.oschina.net/uploads/img/201807/30113144_1SRR.png';
      slideData.add(map);
    }
    for (var i = 0; i < 30; i++) {
      Map map =  new Map();
      map['title']='J2Cache 2.3.23 发布，支持 memcached 二级缓存';
      map['authorImg']='https://static.oschina.net/uploads/user/0/12_50.jpg?t=1421200584000';
      map['timeStr']='2018-12-26';
      map['thumb']='https://static.oschina.net/uploads/logo/j2cache_N3NcX.png';
      map['commCount']=5;
      listData.add(map);

    }
  }
  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
      itemCount: listData.length*2-1,
      itemBuilder: (context,i) => renderRow(i),
    );
  }
  @override
 
}
*/