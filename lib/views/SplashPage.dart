import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutterdemo/routers/routers.dart';
import 'package:flutterdemo/routers/application.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashPage extends StatefulWidget {
  SplashPage({Key key}) : super(key: key);

  @override
  _SplashPage createState() => new _SplashPage();
}

class _SplashPage extends State<SplashPage> {
  bool isStartHomePage = false;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new GestureDetector(
      onTap: goToHomePage, //设置页面点击事件
      child: Image.asset(
        "images/img_start.png",
        fit: BoxFit.cover,
      ), //此处fit: BoxFit.cover用于拉伸图片,使图片铺满全屏
    );
  }

  //页面初始化状态的方法
  @override
  void initState() {
    super.initState();
    //开启倒计时
    countDown();
  }

  void countDown() {
    //设置倒计时三秒后执行跳转方法
    var duration = new Duration(seconds: 3);
    new Future.delayed(duration, goToHomePage);
  }

  void goToHomePage() async {
//    SharedPreferences prefs = await SharedPreferences.getInstance();
//    prefs.clear();
    //如果页面还未跳转过则跳转页面
    if (!isStartHomePage) {
      //跳转主页 且销毁当前页面
      Application.router
          .navigateTo(context, Routes.home, replace: true, clearStack: true);
//      Navigator.of(context).pushAndRemoveUntil(new MaterialPageRoute(builder: (context)=>new Home()), (Route<dynamic> rout)=>false);
      isStartHomePage = true;
    }
  }
}
