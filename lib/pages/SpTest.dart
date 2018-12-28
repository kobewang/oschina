import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../util/DataUtils.dart';

class SpTest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {    
    return new Container(            
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
          new FlatButton(
            child: new Text('Login'), 
            onPressed: (){
              print('login click');
              DataUtils.saveIsLogin();
            },         
          ),
          new FlatButton(
            child: new Text('Logout'),
            onPressed: (){
              print('logout click');
              DataUtils.logout();
            },
          ),
          new FlatButton(
            child: new Text('Show'),
            onPressed: (){
              print('show click');
              DataUtils.isLogin().then((isLogin){
              if (isLogin) {
                print('isLogin:true****');
              } else {
                print('isLogin:false****');
              }
            });
            },
          )
        ],),
      );    
  }
}