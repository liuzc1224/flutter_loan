import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterdemo/common/Api.dart';
import 'package:flutterdemo/common/Toast.dart';
import 'package:flutterdemo/common/http_manager.dart';
import 'package:flutterdemo/language/Localizations.dart';
import 'package:flutterdemo/routers/application.dart';
import 'package:flutterdemo/routers/routers.dart';
import 'dart:convert';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutterdemo/common/get_login_datas.dart';
import 'package:flutterdemo/common/logs_interceptor.dart';
import 'package:flutterdemo/common/result_data.dart';
import 'package:shared_preferences/shared_preferences.dart';
class PassWord extends StatefulWidget {
  final phoneNumber;

  const PassWord({Key key, this.phoneNumber})
      : super(key: key);
  @override
  _PassWordState createState() => _PassWordState();
}


class _PassWordState extends State<PassWord> {
  bool pwdShow=true;
  bool loginBtnState=false;
  TextEditingController pwd=new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: new AppBar(
        title: new Text(L.of(context).$['passWord']['title'],style: TextStyle(color: Color(0xFFFFFFFF))),
        elevation: 0,
        centerTitle: true,
        leading:
        IconButton(
          icon: Image.asset("images/icon_nav_arrow.png",color: Colors.white),
          onPressed: () {
            Application.router.pop(context);
          },
        ),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(15.5),
            child: Column(
              crossAxisAlignment : CrossAxisAlignment.start,
              children: <Widget>[
                Text.rich(
                  TextSpan(
                    text: L.of(context).$['passWord']['prompt'],
                    style: TextStyle(color: Color(0xFF494951),fontSize: 16),// default text style
                    children: <TextSpan>[
                      TextSpan(text: '*',style: TextStyle(color: Color(0xFFFF0101))),
                    ],
                  ),
                ),
                SizedBox(height: 15.5),
                TextField(
                    autofocus:true,
                    obscureText: pwdShow,
                    controller: pwd,
                    style:TextStyle(color: Color(0xFF5999F6),fontSize: 13.33),
                    decoration:InputDecoration(
                      border: new OutlineInputBorder(  //添加边框
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      contentPadding: EdgeInsets.all(9.0),
                      suffix: GestureDetector(
                          onTap: (){
                            setState(() {
                              pwdShow=!pwdShow;
                            });
                          },
                          child: Icon(
                            Icons.remove_red_eye,
                            size: 20,
                            color: !pwdShow ? Color(0xFF5999F6) : Colors.grey,
                          )
                      ),
                    ),
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(20)
                    ],
                ),
                SizedBox(height: 10.5),
                Text(L.of(context).$['passWord']['tip'],style: TextStyle(color: Color(0xFFCCCCCC),fontSize: 13)),
                SizedBox(height: 34.8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                        child: Container(
                          height: 42.33,
                          margin: EdgeInsets.only(top: 24.8),
                          child: RaisedButton(
                              child: Text(L.of(context).$['login']['login']),
                              color: Color(0xFF4F8AD9),
                              textColor: Color(0xFFFFFFFF),
                              elevation: 10,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(42.33)
                              ),
                              onPressed: loginBtnState ? null : ()async{
                                var password=pwd.text.toString();
                                if(password.length<6){
                                  ToastAlert.error(L.of(context).$['passWord']['error']);
                                  return;
                                }
                                setState(() {
                                  loginBtnState=true;
                                });
                                var virtual;
                                DeviceInfoPlugin deviceInfo = new DeviceInfoPlugin();
                                if(Platform.isIOS){
                                  print('IOS设备：');
                                  IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
                                  virtual=iosInfo.isPhysicalDevice;
                                }else if(Platform.isAndroid){
                                  print('Android设备');
                                  AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
                                  virtual=androidInfo.isPhysicalDevice;
                                }
                                Map<String, dynamic> params={
                                  "advertisingId":"1",
                                  "androidId":"1",
                                  "imei":"1",
                                  "ram":"1",
                                  "resolution":"1",
                                  "rom":"1",
                                  "virtual": virtual,
                                  "areaCode":"62",
                                  "phoneNumber":widget.phoneNumber.toString(),
                                  "password":hex.encode(md5.convert(Utf8Encoder().convert(password)).bytes)
                                };
                                ResultData res=await HttpManager.getInstance().post(Api.login, params);
                                if (res.isSuccess) {
                                  setState(() {
                                    this.loginBtnState=false;
                                  });
                                  var obj=res.data["data"];
                                  SharedPreferences prefs = await SharedPreferences.getInstance();
                                  prefs.setString("loginDatas", jsonEncode(obj));//loginDatas本地存储登录信息！！！
                                  Application.router.navigateTo(context, Routes.home, replace: true, clearStack: true);
                                }else{
                                  setState(() {
                                    this.loginBtnState=false;
                                  });
                                  ToastAlert.error(res.data['message']);
                                }
                              }
                          ),
                        )
                    )
                  ],
                ),
                SizedBox(height: 14),
                Container(
                  alignment: Alignment.bottomRight,
                  child: GestureDetector(
                    onTap: (){
                      Application.router.navigateTo(context, '${Routes.forgetPwd}?phoneNumber=${widget.phoneNumber}',transition: TransitionType.inFromRight);
                    },
                    child: Text(L.of(context).$['passWord']['forgetPwd'],style: TextStyle(decoration: TextDecoration.underline,color: Colors.blue,fontSize: 13)),
                  ),
                ),
              ],
            ),
          ),
        ],
      )
    );
  }

}
