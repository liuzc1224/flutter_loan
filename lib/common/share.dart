import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share_me/flutter_share_me.dart';
import 'package:flutter/services.dart';
import 'package:flutterdemo/common/Api.dart';
import 'package:flutterdemo/common/Toast.dart';
import 'dart:convert';
import 'dart:io';

import 'package:flutterdemo/common/get_login_datas.dart';
import 'package:flutterdemo/language/Localizations.dart';
import 'package:flutterdemo/routers/application.dart';
class sharePage extends StatefulWidget {
  String type;
  sharePage(this.type, {Key key})
      :super(key: key);

  @override
  sharePageState createState() => sharePageState();
}
class sharePageState extends State<sharePage> {
  String userId;
  @override
  void initState() {
    super.initState();
    GetLoginDatas().then(//登录完成，将信息注入请求头
      (e){
        if(e!=null){
          print(e.toString());
          setState(() {
            userId=e['id'].toString();
          });
        }
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    String sourceEven=H5.inviteRegistered+"/";
//    if(widget.type=="1"){
//      sourceEven="/gameShare/";
//    }
//    if(widget.type=="2" || widget.type=="3"){
//      sourceEven="/bagikan/";
//    }
//    if(widget.type=="4"){
//      sourceEven="/loan-details-share/";
//    }
    return
      new Container(
        height: 147.5,
        color: const Color(0xFFEFF3F4),
        child: Column(
          children: <Widget>[
            Container(
              height: 95.5,
              width: double.infinity,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: GestureDetector(
                        onTap: () async{
                          //参数一：用户ID
                          //参数二：分享渠道【1:Copy Link复制链接——2:Facebook脸书——3:Twitter推特——4:Linkedin领英——5:WhatsApp瓦次艾普】
                          //参数三：从哪分享【1:小游戏——2:抽奖——3:邀请好友——4:贷款详情页】
                          var response = await FlutterShareMe().shareToFacebook(
                          url:sourceEven+userId+"/2/"+widget.type,  msg: "");
                          print(response);
                          if (response == 'success') {
                            print('navigate success');
                          }else{
                            ToastAlert.error(L.of(context).$['shareError']);
                          }
                        },//写入方法名称就可以了，但是是无参的
                        child: Column(
                          children: <Widget>[
                            Image(
                              image: new AssetImage("images/fb.png"),
                              width: 60,
                              height: 60,
                            ),
                            Container(
                              child: Text("Facebook",style: TextStyle(fontSize: 15,color: Color(0xFF222222)),textAlign: TextAlign.center,),
                            )
                          ],
                        )
                    ),
                    flex: 1,
                  ),
                  Expanded(
                    child: GestureDetector(
                        onTap: () async{
                          //参数一：用户ID
                          //参数二：分享渠道【1:Copy Link复制链接——2:Facebook脸书——3:Twitter推特——4:Linkedin领英——5:WhatsApp瓦次艾普】
                          //参数三：从哪分享【1:小游戏——2:抽奖——3:邀请好友——4:贷款详情页】
                          var response = await FlutterShareMe().shareToTwitter(
                              url:sourceEven+userId+"/3/"+widget.type,  msg: "");
                          print(response);
                          if (response == 'success') {
                            print('navigate success');
                          }else{
                            ToastAlert.error(L.of(context).$['shareError']);
                          }
                        },//写入方法名称就可以了，但是是无参的
                        child: Column(
                          children: <Widget>[
                            Image(
                              image: new AssetImage("images/twitter.png"),
                              width: 60,
                              height: 60,
                            ),
                            Container(
                              child: Text("Twitter",style: TextStyle(fontSize: 15,color: Color(0xFF222222)),textAlign: TextAlign.center,),
                            )
                          ],
                        )
                    ),
                    flex: 1,
                  ),
                  Expanded(
                    child:GestureDetector(
                        onTap: () async{
                          File file = new File("images/about_logo.png");
                          List<int> imageBytes = await file.readAsBytes();
                          String data = base64Encode(await file.readAsBytes());
                          var response = await FlutterShareMe().shareToWhatsApp(
                              base64Image:data,  msg: sourceEven+userId+"/5/"+widget.type);
                          print(response);
                          if (response == 'success') {
                            print('navigate success');
                          }else{
                            ToastAlert.error(L.of(context).$['shareError']);
                          }
                        },//写入方法名称就可以了，但是是无参的
                        child: Column(
                          children: <Widget>[
                            Image(
                              image: new AssetImage("images/whatsapp.png"),
                              width: 60,
                              height: 60,
                            ),
                            Container(
                              child: Text("Whatsapp",style: TextStyle(fontSize: 15,color: Color(0xFF222222)),textAlign: TextAlign.center,),
                            )
                          ],
                        )
                    ),
                    flex: 1,
                  ),
                  Expanded(
                    child: GestureDetector(
                        onTap: () async{
                          Clipboard.setData(ClipboardData(text: sourceEven+userId+"/1/"+widget.type));
                          ToastAlert.tip(L.of(context).$['copySuccess']);
                          Application.router.pop(context);
                        },//写入方法名称就可以了，但是是无参的
                        child: Column(
                          children: <Widget>[
                            Image(
                              image: new AssetImage("images/link.png"),
                              width: 60,
                              height: 60,
                            ),
                            Container(
                              child: Text("Copiar link",style: TextStyle(fontSize: 15,color: Color(0xFF222222)),textAlign: TextAlign.center,),
                            )
                          ],
                        )
                    ),
                    flex: 1,
                  ),
                ],
              ),
            ),
            GestureDetector(
                onTap: (){
                  Application.router.pop(context);
                },//写入方法名称就可以了，但是是无参的
                child: Container(
                    height: 52,
                    alignment: Alignment.center,
                    color: Color(0xFFEAEAEA),
                    child:Text(L.of(context).$['cancel'])
                )
            ),
          ],
        ),
      );
  }
}
