import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import '../constants/Constants.dart';
import '../util/DataUtils.dart';
//登录页面 webview加载开源中国三方登录页面
class LoginPage extends StatefulWidget {
  @override
  LoginPageState createState()=> LoginPageState();
}
class LoginPageState extends State<LoginPage> {
  bool isLoading = true;
  bool isLoadingCallbackPage = false;
  FlutterWebviewPlugin fltWebViewPlugin = new FlutterWebviewPlugin();//插件提供对象，用于webview的各种操作
  StreamSubscription<String> _onUrlChanged; //URL变化监听器
  StreamSubscription<WebViewStateChanged> _onStateChanged; //webview加载状态变化监听器
  @override
  void initState() {
    super.initState();
    //监听webview加载时间，该监听器已不起作用，不回调
    _onStateChanged = fltWebViewPlugin.onStateChanged.listen((WebViewStateChanged state){
      //state.type枚举类型
      switch(state.type) {
        case WebViewState.shouldStart://准备加载        
        setState(() { isLoading = true;});
        break;
        case WebViewState.startLoad: //开始加载
        break;
        case WebViewState.finishLoad: //加载完成
        setState(() { isLoading = false;});
        if (isLoadingCallbackPage) {
          //当前回调页面，调用js获取数据
          parseResult();
        }
        break;        
      }
    });
    _onUrlChanged = fltWebViewPlugin.onUrlChanged.listen((url){
      //登录成功会跳到自定义回调页面，页面地址contants配置http://yubo725.top/osc/osc.php?code=xxx
      //该页面会接受code，然后根据code换取AccessToken,并将获取到的token以及其他信息，通过js的get()方法返回，get如下
      //var data = ''
      //function save(s) {
      //	data = s
      //}
      //function get() {
      //	return data   
      //}
      if (url != null && url.length > 0 && url.contains("osc/osc.php?code=")) {
        isLoadingCallbackPage = true;
      }
    });
  }
  //解析webview中的数据
  void parseResult() {
    fltWebViewPlugin.evalJavascript("get();").then((result){
      //result json字符串 ,包含token信息
      if (result != null && result.length > 0) {
        //拿到了js中的数据
        try {
          var map = json.decode(result);
          if (map is String) {
            map = json.decode(map);
          }
          if (map != null) {
            //登录成功，获取token，关闭当前页面
            DataUtils.saveLoginInfo(map);
            Navigator.pop(context,"refresh");
          }

        } catch (e) {
          print("parse login result error: $e");
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> titleContent = [];
    titleContent.add(new Text('登录开源中国',style:new TextStyle(color:Colors.white)));
    if (isLoading) {
      titleContent.add(new CupertinoActivityIndicator());//如果还在加载中，标题栏上显示进度条
    }
    titleContent.add(new Container(width: 50.0));
    //WebviewScafford是插件提供的组件，用于在页面显示一个webview并加载URL
    return new WebviewScaffold(
      //key: ,
      url: Constants.LOGIN_URL,
      appBar: new AppBar(
        title: new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: titleContent,
        ),
        iconTheme: new IconThemeData(color: Colors.white),
      ),
      withZoom: true,//允许网页缩放
      withLocalStorage: true, //允许LocalStorage
      withJavascript: true,//允许js
    );
  }
  @override
  void dispose() {
    //回收相关资源
    _onUrlChanged.cancel();
    _onStateChanged.cancel();
    fltWebViewPlugin.dispose();
    super.dispose();
  }
}
