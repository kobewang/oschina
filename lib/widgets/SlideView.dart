import 'package:flutter/material.dart';
class SlideView extends StatefulWidget {
  var data;
  //data表示轮播数据
  SlideView(data){
    this.data=data;    
  }
  @override
  State<StatefulWidget> createState() {
    return new SlideViewState(data);
  }
}
class SlideViewState extends State<SlideView> with SingleTickerProviderStateMixin {
  TabController tabController;
  List slideData;
  SlideViewState(data) {
    slideData = data;
  }
  @override
  void initState() {
    super.initState();    
    tabController = new TabController(length: slideData == null ? 0 : slideData.length, vsync: this);
  }
  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context){
    List<Widget> items= [];
    if (slideData != null && slideData.length > 0) {
      for (var i = 0; i < slideData.length; i++ ) {
        var item = slideData[i];
        var imgUrl = item['imgUrl'];
        var title = item['title'];
        var detailUrl = item['detailUrl'];
        items.add(new GestureDetector(
          onTap: () {},//点击跳转到详情
          child: new  Stack( //stack组件将标题放到图片上
            children: <Widget>[
              new Image.network(imgUrl),
              new Container(
                width: MediaQuery.of(context).size.width,//标题容器宽度和屏幕宽度一致
                color: const Color(0x50000000),//背景黑色，加入透明度
                child: new Padding(padding: const EdgeInsets.all(6.0),child: new Text(title, style:new TextStyle(color: Colors.white,fontSize: 15.0))),
              )
            ],
          ),
        ));
      }
    }
    return new  TabBarView(
      controller: tabController,
      children: items,
    );
  }
}