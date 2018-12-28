import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import './LoginPage.dart';
import '../util/DataUtils.dart';
class MyInfoPage extends StatelessWidget {
  List itemList=[
    {
      'type':'login',
      'title':'',
      'image':''
    },
    {
      'type':'divider',
      'title':'',
      'image':''
    },
    {
      'type':'item',
      'title':'我的消息',
      'image':'images/ic_my_message.png'
    },
    {
      'type':'divider',
      'title':'',
      'image':''
    },
    {
      'type':'item',
      'title':'阅读记录',
      'image':'images/ic_my_blog.png'
    },
    {
      'type':'divider',
      'title':'',
      'image':''
    },
    {
      'type':'item',
      'title':'我的博客',
      'image':'images/ic_my_blog.png'
    },
    {
      'type':'divider',
      'title':'',
      'image':''
    },
    {
      'type':'item',
      'title':'我的问答',
      'image':'images/ic_my_question.png'
    },
    {
      'type':'divider',
      'title':'',
      'image':''
    },
    {
      'type':'item',
      'title':'我的活动',
      'image':'images/ic_discover_pos.png'
    },
    {
      'type':'divider',
      'title':'',
      'image':''
    },
    {
      'type':'item',
      'title':'我的团队',
      'image':'images/ic_my_team.png'
    },
    {
      'type':'divider',
      'title':'',
      'image':''
    },
    {
      'type':'item',
      'title':'邀请好友',
      'image':'images/ic_my_recommend.png'
    },
    {
      'type':'divider',
      'title':'',
      'image':''
    }
  ];
  @override
  Widget build(BuildContext context) {
    DataUtils.isLogin().then((isLogin){
      if (isLogin) {
        print('isLogin:true****');
      } else {
        print('isLogin:false****');
      }
    });
    var listView = new ListView.builder(
      itemCount: itemList.length,
      itemBuilder:(context,i) => rederRow(context,i),
    );
    return listView;
  }
  rederRow(context,i) {
    var item = itemList[i];
    switch(item['type']) {
      case 'item':
        var listItemContent = new Padding(
          padding: EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
          child: new Row(
            children: <Widget>[
              new Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
                child: new Image.asset(item['image'],width: 30.0,height: 30.0),                
              ),
              new Expanded(
                child: new Text(item['title'],style: new TextStyle(fontSize: 16.0)),
              ),
              new Image.asset('images/ic_arrow_right.png',height: 16.0, width:16.0)
            ],
          ),
        );
        return new InkWell(
          child: listItemContent,
          onTap: (){
            _handleItemClick(item['title']);
          },
        );
      break;
      case 'divider':
        return new Divider(height: 1.0);
      break;
      case 'login':
        var avatarContainer = new Container(
          color: const Color(0xFF63CA6C),
          height: 200.0,
          child: new Center(
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Image.asset('images/ic_avatar_default.png',width:60),
                new Text('请登录',style: new TextStyle(color: Colors.white,fontSize: 16.0))
              ],
            ),
          ),
        );
        return new GestureDetector(
          onTap: () {
            //print('请登录');
            Navigator.push(context, new MaterialPageRoute(
              builder: (context) => new LoginPage()
            ));
          },
          child: avatarContainer,
        );
      break;
    }    
  }
  void _handleItemClick(String title) {
    print(title);
  }
}