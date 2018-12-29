import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import '../api/api.dart';
class PublishPage extends StatefulWidget {
  @override
  PublishPageState createState()=> PublishPageState();
}
class PublishPageState extends State<PublishPage> {
  List<File> fileList = new List();
  Future<File> _imageFile;
  String msg = "";
  TextEditingController _controller = new TextEditingController();
  bool isUploading = false;
  //接口发布信息
  addMessage(ctx) async {
    Scaffold.of(ctx).showSnackBar(new SnackBar(content: new Text('Hello Snack')));
    //下面调用接口发布逻辑
    try {
      String content = _controller.text;
      Map<String,String> params = new Map();
      params['msg'] = content;
      print(Api.THREAD_ADD);
      var request = http.MultipartRequest('POST', Uri.parse(Api.THREAD_ADD));
      request.fields.addAll(params);
      setState(() {
        isUploading = true;
      });
      var response = await request.send();
      //print('statusCode:$response.statusCode');
      response.stream.transform(utf8.decoder).listen((value){
        print('response:$value');        
        setState(() {
          isUploading = false;          
          msg = "发布成功";
        });
      });
      
    } catch(exception) {
      print(exception);
    }
  }

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
                  addMessage(ctx);
                }
              );
            },
          )
        ],
      ),
      //在这里接受选择的图片
      body: new FutureBuilder(
        future: _imageFile,
        builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
          if (snapshot.connectionState == ConnectionState.done && snapshot.data != null && _imageFile != null) {
            //选择了图片(拍照或图库选择), 添加到List
            fileList.add(snapshot.data);
            _imageFile =  null;
          }
          return getBody();//返回widget
        },
      ),
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
                onTap: (){ pickImage(ctx);},//点击添加图片              
                child: addCell,
              );
            } else {
              //被选中的图片
              content = new Center(child: new Image.file(fileList[index - 1],width: 80.0, height: 80.0, fit: BoxFit.cover));
            }
            return new Container(
              margin: const EdgeInsets.all(2.0),
              width: 80.0,
              height: 80.0,
              color: const Color(0xFFECECEC),
              child: content,
            );
            
          }),
        );
      },
    );
    var children = [
      new Text('提示：由于信息发布实名制，巴拉巴拉巴拉巴拉巴拉巴拉巴拉巴拉巴拉巴拉巴拉巴拉巴拉巴拉巴拉巴拉巴拉巴拉巴拉巴拉巴拉巴拉巴拉巴拉。。'),
      textFiled,
      new Container(
        margin: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
        height: 200.0,
        child: gridView,
      )      
    ];
    if (isUploading) {
      children.add(
        new Container(
          margin: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
          child: new Center(child: new CircularProgressIndicator()),
        )
      );
    } else {
      children.add(
        new Container(
          margin: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
          child: new Center(child: new Text(msg))
        )
      );
    }
    return new Container(
      padding: const EdgeInsets.all(5.0),
      child: new Column(
        children: children,
      )
    );
  }
  //相机拍照或从图库选择图片
  pickImage(ctx) {
    num size = fileList.length;
    if (size >= 9) {
      //超过9张提示不能添加更多
      Scaffold.of(ctx).showSnackBar(new SnackBar(
        content:  new Text('最多只能添加9张图片'),
      ));
      return;
    }
    showModalBottomSheet<void>(context:  context,builder: _bottomSheetBuilder);//底部选择弹窗
  }
  Widget _bottomSheetBuilder(BuildContext context) {
    return new Container(
      height: 182.0,
      child: new Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 30.0),
        child: new Column(
          children: <Widget>[
            _renderBottomMenuItem("相机拍照",ImageSource.camera),
            new Divider(height: 2.0),
            _renderBottomMenuItem("图库选择照片",ImageSource.gallery)
          ],
        ),
      ),
    );
  }
  _renderBottomMenuItem(title, ImageSource source) {
    var item = new Container(
      height: 60.0,
      child: new Center(
        child: new Text(title)
      ),
    );
    return new InkWell(
      child: item,
      onTap: (){
        Navigator.of(context).pop();
        setState(() {
        _imageFile = ImagePicker.pickImage(source: source);          
        });
      }
    );
  }
}