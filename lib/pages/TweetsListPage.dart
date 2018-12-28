import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../util/DataUtils.dart';
class TweetsListPage extends StatelessWidget {
  List normalTweetsList = [];
  List hotTweetsList = [];
  double screeenWidth; //屏幕宽度
  TextStyle authorTextStye;//作者文本样式
  TextStyle subtitleStyle;//时间文本样式
  TweetsListPage() {
    authorTextStye = new TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold);
    subtitleStyle = new TextStyle(fontSize: 12.0, color:const Color(0xFFB5BDC0));
    for(int i = 0; i < 20; i++) {
      Map map = new Map();
        // 动弹发布时间
      map['pubDate'] = '2018-7-30';
      // 动弹文字内容
      map['body'] = '早上七点十分起床，四十出门，花二十多分钟到公司，必须在八点半之前打卡；下午一点上班到六点，然后加班两个小时；八点左右离开公司，呼呼登自行车到健身房锻炼一个多小时。到家已经十点多，然后准备第二天的午饭，接着收拾厨房，然后洗澡，吹头发，等能坐下来吹头发时已经快十二点了。感觉很累。';
      // 动弹作者昵称
      map['author'] = '红薯';
      // 动弹评论数
      map['commentCount'] = 10;
      // 动弹作者头像URL
      map['portrait'] = 'https://static.oschina.net/uploads/user/0/12_50.jpg?t=1421200584000';
      // 动弹中的图片，多张图片用英文逗号隔开
      map['imgSmall'] = 'https://b-ssl.duitang.com/uploads/item/201508/27/20150827135810_hGjQ8.thumb.700_0.jpeg,https://b-ssl.duitang.com/uploads/item/201508/27/20150827135810_hGjQ8.thumb.700_0.jpeg,https://b-ssl.duitang.com/uploads/item/201508/27/20150827135810_hGjQ8.thumb.700_0.jpeg,https://b-ssl.duitang.com/uploads/item/201508/27/20150827135810_hGjQ8.thumb.700_0.jpeg';
      hotTweetsList.add(map);
      normalTweetsList.add(map);
    }
    print('************************succ initial********************************');
  }
  @override
  Widget build(BuildContext context) {
    DataUtils.logout();
    screeenWidth = MediaQuery.of(context).size.width;//获取屏幕高度
    return new DefaultTabController(
      length: 2,
      child: new Scaffold(
        appBar: new TabBar(
          tabs: <Widget>[
            new Tab(text: '动弹列表'),
            new Tab(text: '热门动弹'),
          ],
        ),
        body: new TabBarView(
          children: <Widget>[getNormalListView(),getHotListView()],
        ),
      ),
    ) ;     
  }
  //动弹列表
  Widget getNormalListView(){
    return new ListView.builder(
      itemCount: normalTweetsList.length*2-1,
      itemBuilder: (context,i) => renderNormalRow(i),
    );
  }
  //热门动弹
  Widget getHotListView(){
    return new ListView.builder(
      itemCount: hotTweetsList.length*2-1,
      itemBuilder: (context,i) => renderNormalRow(i),
    );
  }
  //渲染普通列表
  renderNormalRow(i) {
    if(i.isOdd){
      return new Divider(height: 1.0);
    } else {
      return getRowWidget(normalTweetsList[i]);    
    }
  }
  //渲染热门列表
  getRowWidget(listItem) {    
    //第一行 头像，昵称，评论
    var authorRow = new Row(children: <Widget>[
      //头像
      new Container(
        width: 35.0,
        height: 35.0,
        decoration: new BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.transparent,
          image: new DecorationImage(
            image: new NetworkImage(listItem['portrait']),
            fit: BoxFit.cover //填充父布局
          ),
          border: new Border.all(color: Colors.white,width: 2.0) //头像边框
        ),
      ),
      //昵称
      new Padding(
        padding: const EdgeInsets.fromLTRB(6.0, 0.0, 0.0, 0.0),
        child: new Text(listItem['author'],style: new TextStyle(fontSize: 16.0)),
      ),
      //评论，最右边
      new Expanded(
        child:  new Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            new Text('${listItem['commentCount']}',style: subtitleStyle,),
            new Image.asset('./images/ic_comment.png',width:16.0,height:16.0)
          ],
        )
      )
    ]);
    //第二行 正文
    var _body = listItem['body'];
    var contentRow = new Row(
      children: <Widget>[
        new Expanded(child: new Text(_body),)
      ],
    );
    var columns = <Widget>[
      new Padding(padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 2.0),child: authorRow),
      new Padding(padding: const EdgeInsets.fromLTRB(52.0, 0.0, 10, 0.0),child: contentRow,)      
    ];
    var imgSmall = listItem['imgSmall'];
    
    if (imgSmall != null && imgSmall.length > 0 ) {
 
      List<String> imgUrlList =imgSmall.split(',');
      List<Widget> imgList = [];
      List<List<Widget>> rows = [];
      num len = imgUrlList.length;
      // 通过for循环生成每张图片
      for (var row = 0; row <getRow(len); row++) { //生成行数
        List<Widget> rowArr = [];
        for(var col = 0; col < 3; col++) { //固定3列
          num index = row*3 +col; //索引
          double cellWidth = (screeenWidth - 100) /3;
          if( index < len) {
            rowArr.add(new Padding(
              padding: const EdgeInsets.all(2.0),
              child: new Image.network(imgUrlList[index],width: cellWidth,height: cellWidth,),              
            ));
          }
        }
        rows.add(rowArr);
      }
      for (var row in rows) {
        imgList.add(new Row(children: row));
      }
      columns.add(new Padding(
        padding: const EdgeInsets.fromLTRB(52.0, 5.0, 10.0, 0.0),
        child: new Column(children: imgList)
      ));
           
    }
    //第三行 时间
    var timeRow = new Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        new Text(listItem['pubDate'],style: subtitleStyle)
      ],
    );
    columns.add(new Padding( padding: const EdgeInsets.fromLTRB(0.0, 10.0, 10.0, 6.0),child: timeRow,));
    return new InkWell(
      child:  new Column(
        children: columns,
      ),
      onTap: () {
        //跳转详情
      },
    );
  }
  //获取九宫图图片行数 leng
  int getRow(int length) {
    int a = length % 3; //取余
    int b = length ~/ 3; //取整
    if (a!=0) {
      return b+1;
    }
    return b;
  }
}