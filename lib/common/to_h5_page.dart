import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_share_plugin/flutter_share_plugin.dart';
import 'package:flutterdemo/common/Api.dart';
import 'package:flutterdemo/common/Toast.dart';
import 'package:flutterdemo/common/get_login_datas.dart';
import 'package:flutterdemo/common/http_manager.dart';
import 'package:flutterdemo/common/result_data.dart';
import 'package:flutterdemo/language/Localizations.dart';
import 'package:flutterdemo/routers/application.dart';
import 'package:flutterdemo/routers/routers.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'address.dart';

class ToH5Page extends StatefulWidget {
  String url;
  var data;

  ToH5Page({this.url, this.data});

  @override
  ToH5PageState createState() => new ToH5PageState();
}

class ToH5PageState extends State<ToH5Page> {
//  FlutterWebviewPlugin flutterWebviewPlugin = FlutterWebviewPlugin();
  WebViewController flutterWebviewPlugin;
  bool hiddenState = true;
  var userInfo;

  @override
  void dispose() {
    super.dispose();
    closeWebView();
  }

//  ToH5PageState(this.url){
//    print("${H5Page.PAGE_URL}${url}");
//  }
  @override
  void initState() {
    super.initState();
    GetLoginDatas().then(//登录完成，将信息注入请求头
        (e) {
      setState(() {
        userInfo = e;
      });
    });
  }

  JavascriptChannel getUserLoginInfo(BuildContext context) => JavascriptChannel(
      name: 'getUserLoginInfo', // 与h5 端的一致 不然收不到消息  登錄信息
      onMessageReceived: (JavascriptMessage message) async {
        print(message.message);
        String callbackname = message.message;
        String data = json.encode(userInfo);
        String script = "$callbackname($data)";
        print(data.toString());
        flutterWebviewPlugin.evaluateJavascript(script);
      });

  JavascriptChannel agreementParameter(BuildContext context) =>
      JavascriptChannel(
          name: 'agreementParameter', // 与h5 端的一致 不然收不到消息   合同信息
          onMessageReceived: (JavascriptMessage message) async {
            print(message.message);
            if(widget.data.toString().isEmpty)return;
            String callbackname = message.message;
            String data = json.encode(widget.data);
            String script = "$callbackname($data)";
            print(data.toString());
            flutterWebviewPlugin.evaluateJavascript(script);
          });

  JavascriptChannel goBack(BuildContext context) => JavascriptChannel(
      name: 'goBack', // 与h5 端的一致 不然收不到消息   返回
      onMessageReceived: (JavascriptMessage message) async {
        print(message.message);
        Application.router.pop(context);
      });

  JavascriptChannel goHome(BuildContext context) => JavascriptChannel(
      name: 'goHome', // 与h5 端的一致 不然收不到消息   返回
      onMessageReceived: (JavascriptMessage message) async {
        print(message.message);
        Application.router.navigateTo(context, Routes.home);
      });

  JavascriptChannel openUrl(BuildContext context) => JavascriptChannel(
      name: 'openUrl', // 与h5 端的一致 不然收不到消息  打开页面
      onMessageReceived: (JavascriptMessage message) async {
        print(message.message);
        String url = message.message;
//        if (await canLaunch(url)) {
//          await launch(url);
//        } else {
//          throw 'Could not launch $url';
//        }
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ToH5Page(url:url),
          ),
        );
      });

  JavascriptChannel getGallery(BuildContext context) => JavascriptChannel(
      name: 'getGallery', // 与h5 端的一致 不然收不到消息
      onMessageReceived: (JavascriptMessage message) async {
        print(message.message);
        SystemChannels.textInput.invokeMethod('TextInput.hide');
        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return new Container(
              height: 150.0,
              color: const Color(0xFFEFF3F4),
              child: Column(
                children: <Widget>[
                  InkWell(
                    //在最外层包裹InkWell组件
                    onTap: () async {
                      var image = await ImagePicker.pickImage(
                          source: ImageSource.camera, imageQuality: 40);
                      List<int> imageBytes = await image.readAsBytes();
                      String callbackname = message.message;
                      String imageBase64 = base64Encode(imageBytes);
                      print(imageBase64);
                      var res = {"imageBase64": imageBase64};
                      var data = json.encode(res);
                      print(data);
                      String script = "$callbackname($data)";
                      Application.router.pop(context);
                      flutterWebviewPlugin.evaluateJavascript(script);
                    },
                    child: Container(
                      color: const Color(0xFFFFFFFF),
                      height: 49,
                      alignment: Alignment.center,
                      child: Text(L.of(context).$['take']),
                    ),
                  ),
                  SizedBox(
                      height: 1, child: Container(color: Color(0xFFF4F4F4))),
                  InkWell(
                    //在最外层包裹InkWell组件
                    onTap: () async {
                      String callbackname = message.message;
                      var image = await ImagePicker.pickImage(
                          source: ImageSource.gallery, imageQuality: 40);
                      List<int> imageBytes = await image.readAsBytes();
                      String imageBase64 = base64Encode(imageBytes);
                      print(imageBase64);
                      var res = {"imageBase64": imageBase64};
                      var data = json.encode(res);
                      String script = "$callbackname($data)";
                      Application.router.pop(context);
                      flutterWebviewPlugin.evaluateJavascript(script);
                    },
                    child: Container(
                      color: const Color(0xFFFFFFFF),
                      height: 50,
                      alignment: Alignment.center,
                      child: Text(L.of(context).$['photo']),
                    ),
                  ),
                  SizedBox(
                      height: 1, child: Container(color: Color(0xFFF4F4F4))),
                  InkWell(
                    //在最外层包裹InkWell组件
                    onTap: () async {
                      Application.router.pop(context);
                    },
                    child: Container(
                      color: const Color(0xFFFFFFFF),
                      height: 48,
                      alignment: Alignment.center,
                      child: Text(
                        L.of(context).$['cancel'],
                        style: TextStyle(color: Color(0xFF999999)),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ).then((val) {
          print(val);
        });
      });

  JavascriptChannel Call(BuildContext context) => JavascriptChannel(
      name: 'Call', // 与h5 端的一致 不然收不到消息
      onMessageReceived: (JavascriptMessage message) async {
        print(message.message);
        final Map<String, dynamic> _param = {};
        ResultData res =
            await HttpManager.getInstance().get(Api.getCall, _param);
        if (res.isSuccess) {
          if (res.data['data'] != null) {
            launch("tel:${res.data['data']}");
          }
        } else {
          print("error");
          ToastAlert.error(res.data['message']);
        }
      });

  JavascriptChannel goLogin(BuildContext context) => JavascriptChannel(
      name: 'goLogin', // 与h5 端的一致 不然收不到消息   前往登录
      onMessageReceived: (JavascriptMessage message) async {
        print(message.message);
        Application.router.navigateTo(context, Routes.login,
            replace: true, clearStack: true); //跳转登录主页
      });

  JavascriptChannel toFeedBack(BuildContext context) => JavascriptChannel(
      name: 'toFeedBack', // 与h5 端的一致 不然收不到消息   前往登录
      onMessageReceived: (JavascriptMessage message) async {
        print(message.message);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ToH5Page(url:H5.feedBack),
          ),
        );
      });

  JavascriptChannel getCoupon(BuildContext context) => JavascriptChannel(
      name: 'getCoupon', // 与h5 端的一致 不然收不到消息   获取优惠券
      onMessageReceived: (JavascriptMessage message) async {
        //  print("--1"+message.message);
        var data = message.message;
        Navigator.of(context).pop(data);
      });

  JavascriptChannel shareDialog(BuildContext context) => JavascriptChannel(
      name: 'shareDialog', // 与h5 端的一致 不然收不到消息
      onMessageReceived: (JavascriptMessage message) async {
        String text = H5.inviteRegistered+"/"+userInfo['id'].toString()+"/3/1";
        FlutterShare.shareText(text);
//        showModalBottomSheet(
//          context: context,
//          builder: (BuildContext context) {
//            return new sharePage(message.message);
//          },
//        ).then((val) {
//          print(val);
//        });
      });

  JavascriptChannel closeFocus(BuildContext context) => JavascriptChannel(
      name: 'closeFocus', // 与h5 端的一致 不然收不到消息
      onMessageReceived: (JavascriptMessage message) async {
        print(message.message);
        FocusScope.of(context).requestFocus(new FocusNode());
      });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: hiddenState
            ? new AppBar(
                backgroundColor: Colors.transparent,
                //把appbar的背景色改成透明
                elevation: 0,
                automaticallyImplyLeading: false,
                title: Center(
                  child: CircularProgressIndicator(),
                ),
                centerTitle: true,
              )
            : PreferredSize(child: AppBar(), preferredSize: Size.fromHeight(0)),
        body: WebView(
          initialUrl: widget.url,
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            flutterWebviewPlugin = webViewController;
//            flutterWebviewPlugin.clearCache();
          },
          debuggingEnabled: true,
          javascriptChannels: <JavascriptChannel>[
            getUserLoginInfo(context), // 与h5 通信
            agreementParameter(context), // 与h5 通信
            goBack(context), // 与h5 通信
            getGallery(context), // 与h5 通信
            Call(context), // 与h5 通信
            goLogin(context), // 与h5 通信
            openUrl(context), // 与h5 通信
            goHome(context), // 与h5 通信
            closeFocus(context), // 与h5 通信
            getCoupon(context), // 与h5 通信
            shareDialog(context), // 与h5 通信
            toFeedBack(context), // 与h5 通信
          ].toSet(),
          navigationDelegate: (NavigationRequest request) {
            print("即将打开 ${request.url}");
            print("即将打开 ${request}");
            if (!request.url.startsWith('http://47.98.62.0:9008/') && !request.url.startsWith('http://sandbox.duitku.com/')) {
              print('blocking navigation to $request}');
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
          onPageStarted: (String url) {
            print('Page started loading: $url');
          },
          onPageFinished: (String url) {
            print('Page finished loading: $url');
            setState(() {
              hiddenState = false;
            });
          },
          gestureNavigationEnabled: true,
        ));
  }
}
