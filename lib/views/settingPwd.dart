import 'dart:convert';
import 'dart:io';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterdemo/common/Api.dart';
import 'package:flutterdemo/common/Toast.dart';
import 'package:flutterdemo/common/get_login_datas.dart';
import 'package:flutterdemo/common/http_manager.dart';
import 'package:flutterdemo/common/logs_interceptor.dart';
import 'package:flutterdemo/common/result_data.dart';
import 'package:flutterdemo/language/Localizations.dart';
import 'package:flutterdemo/routers/application.dart';
import 'package:flutterdemo/routers/routers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:device_info/device_info.dart';

class SettingPwd extends StatefulWidget {
  final phoneNumber;
  final verificationCode;

  const SettingPwd({Key key, this.phoneNumber,this.verificationCode})
      : super(key: key);
  @override
  _SettingPwdState createState() => _SettingPwdState();
}

class _SettingPwdState extends State<SettingPwd> {
  var userInfo;
  TextEditingController pwd=new TextEditingController();
  TextEditingController pwdTwo=new TextEditingController();
  FocusNode text1FocusNode = FocusNode();
  FocusNode text2FocusNode = FocusNode();
  FocusNode text3FocusNode = FocusNode();
  FocusNode text4FocusNode = FocusNode();
  FocusNode text5FocusNode = FocusNode();
  FocusNode text6FocusNode = FocusNode();
  TextEditingController code1=new TextEditingController();
  TextEditingController code2=new TextEditingController();
  TextEditingController code3=new TextEditingController();
  TextEditingController code4=new TextEditingController();
  TextEditingController code5=new TextEditingController();
  TextEditingController code6=new TextEditingController();
  TextEditingController code7=new TextEditingController();
  bool pwdShow=true;
  bool pwdTwoShow=true;
  bool dialogState=false;
  bool codeBtnState=false;
  bool loginBtnState=false;
  @override
  void initState() {
    super.initState();
    this.getCheckChannel();
  }
 @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    pwd.dispose();
    pwdTwo.dispose();
    text1FocusNode.dispose();
    text2FocusNode.dispose();
    text3FocusNode.dispose();
    text4FocusNode.dispose();
    text5FocusNode.dispose();
    text6FocusNode.dispose();
    code1.dispose();
    code2.dispose();
    code3.dispose();
    code4.dispose();
    code5.dispose();
    code6.dispose();
  }
  void getCheckChannel()async{
    Map<String, dynamic> params={};
    ResultData res=await HttpManager.getInstance().get(Api.checkChannel, params);
    if (res.isSuccess) {
      setState(() {
        this.dialogState=res.data['code']==0 ? true : false;
      });
        print(res.data);
    }else{
      ToastAlert.error(res.data['message']);
    }
  }

  showAlertDialogs(context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) =>
            CupertinoAlertDialog(
                title: new Text(L.of(context).$['passWord']['invitationCode']),
                content: Material(
                  color: Color(0x00000000),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          child: TextField(
                            controller: code1,
                            autofocus: true,
                            focusNode: text1FocusNode,
                            textAlign: TextAlign.center,
                            style:TextStyle(color: Color(0xFF5999F6),fontSize: 15),
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(1)
                            ],
                            onChanged: (value) {
                              if(value.toString().length>0){
                                text1FocusNode.unfocus();
                                FocusScope.of(context).requestFocus(text2FocusNode);
                              }
                            },
                          ),
                        ),
                        flex: 1,
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          child: TextField(
                            autofocus:true,
                            controller: code2,
                            textAlign: TextAlign.center,
                            focusNode: text2FocusNode,
                            style:TextStyle(color: Color(0xFF5999F6),fontSize: 15),
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(1)
                            ],
                            onChanged: (value) {
                              if(value.toString().length>0){
                                text2FocusNode.unfocus();
                                FocusScope.of(context).requestFocus(text3FocusNode);
                              }else{
                                text2FocusNode.unfocus();
                                FocusScope.of(context).requestFocus(text1FocusNode);
                              }
                            },
                          ),
                        ),
                        flex: 1,
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          child: TextField(
                            autofocus:true,
                            controller: code3,
                            textAlign: TextAlign.center,
                            focusNode: text3FocusNode,
                            style:TextStyle(color: Color(0xFF5999F6),fontSize: 15),
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(1)
                            ],
                            onChanged: (value) {
                              if(value.toString().length>0){
                                text3FocusNode.unfocus();
                                FocusScope.of(context).requestFocus(text4FocusNode);
                              }else{
                                text3FocusNode.unfocus();
                                FocusScope.of(context).requestFocus(text2FocusNode);
                              }
                            },
                          ),
                        ),
                        flex: 1,
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          child: TextField(
                            autofocus:true,
                            controller: code4,
                            textAlign: TextAlign.center,
                            focusNode: text4FocusNode,
                            style:TextStyle(color: Color(0xFF5999F6),fontSize: 15),
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(1)
                            ],
                            onChanged: (value) {
                              if(value.toString().length>0){
                                text4FocusNode.unfocus();
                                FocusScope.of(context).requestFocus(text5FocusNode);
                              }else{
                                text4FocusNode.unfocus();
                                FocusScope.of(context).requestFocus(text3FocusNode);
                              }
                            },
                          ),
                        ),
                        flex: 1,
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          child: TextField(
                            autofocus:true,
                            controller: code5,
                            textAlign: TextAlign.center,
                            focusNode: text5FocusNode,
                            style:TextStyle(color: Color(0xFF5999F6),fontSize: 15),
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(1)
                            ],
                            onChanged: (value) {
                              if(value.toString().length>0){
                                text5FocusNode.unfocus();
                                FocusScope.of(context).requestFocus(text6FocusNode);
                              }else{
                                text5FocusNode.unfocus();
                                FocusScope.of(context).requestFocus(text4FocusNode);
                              }
                            },
                          ),
                        ),
                        flex: 1,
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          child: TextField(
                            autofocus:true,
                            controller: code6,
                            textAlign: TextAlign.center,
                            focusNode: text6FocusNode,
                            style:TextStyle(color: Color(0xFF5999F6),fontSize: 15),
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(1)
                            ],
                            onChanged: (value) {
                              if(value.toString().length==0){
                                text6FocusNode.unfocus();
                                FocusScope.of(context).requestFocus(text5FocusNode);
                              }
                            },
                          ),
                        ),
                        flex: 1,
                      )
                    ],
                  ),
                ),
                actions: <Widget>[
                  new FlatButton(
                    child: new Text(L.of(context).$['passWord']['jumpOver']),
                    onPressed: () {
                      Navigator.of(context).pop();
                      Application.router.navigateTo(context,  Routes.home);
                    },
                  ),
                  new FlatButton(
                    child: new Text(L.of(context).$['passWord']['carryOut']),
                    textColor: Color(0xFF5999F6),
                    onPressed: codeBtnState ? null : () async{
                      var value1=code1.text.toString();
                      var value2=code2.text.toString();
                      var value3=code3.text.toString();
                      var value4=code4.text.toString();
                      var value5=code5.text.toString();
                      var value6=code6.text.toString();
                      if(value1==null || value2==null || value3==null || value4==null || value5==null || value6==null){
                        ToastAlert.error(L.of(context).$['passWord']['codeError']);
                      }
                      setState(() {
                        this.codeBtnState=true;
                      });
                      Map<String, dynamic> params={
                        "invitationCode":value1+value2+value3+value4+value5+value6,
                      };
                      ResultData res=await HttpManager.getInstance().put(Api.invitationCode, params);
                      setState(() {
                        this.codeBtnState=false;
                      });
                      if (res.isSuccess) {
                        Navigator.of(context).pop();
                        Application.router.navigateTo(context, Routes.home, replace: true, clearStack: true);
                      }else{
                        Application.router.navigateTo(context, Routes.home, replace: true, clearStack: true);
                        ToastAlert.error(res.data['message']);
                      }
                    },
                  )
                ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
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
                  controller: pwd,
                  obscureText: pwdShow,
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
                SizedBox(height: 17.5),
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
                  controller: pwdTwo,
                  obscureText: pwdTwoShow,
                  style:TextStyle(color: Color(0xFF5999F6),fontSize: 13.33),
                  decoration:InputDecoration(
                    border: new OutlineInputBorder(  //添加边框
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical:0,horizontal:10),
                    suffix: GestureDetector(
                        onTap: (){
                          setState(() {
                            pwdTwoShow=!pwdTwoShow;
                          });
                        },
                        child: Icon(
                          Icons.remove_red_eye,
                          size: 20,
                          color: !pwdTwoShow ? Color(0xFF5999F6) : Colors.grey,
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
                                var one=pwd.text.toString();
                                var two=pwdTwo.text.toString();
                                print(one.length.toString()+","+two.length.toString());
                                if(one.length<6 || two.length<6){
                                  ToastAlert.error(L.of(context).$['passWord']['prompt']);
                                  return;
                                }
                                if(!RegExp(r"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,20}$").hasMatch(one)){
                                  ToastAlert.error(L.of(context).$['passWord']['tip']);
                                  return;
                                }

                                print(one!=two);
                                print(one+","+two);
                                if(one!=two){
                                  ToastAlert.error(L.of(context).$['passWord']['pwdError']);
                                  return;
                                }
                                setState(() {
                                  this.loginBtnState=true;
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
                                //注册登录
                                Map<String, dynamic> params={
                                  "advertisingId":"1",
                                  "androidId":"1",
                                  "imei":"1",
                                  "ram":"1",
                                  "resolution":"1",
                                  "rom":"1",
                                  "virtual":virtual,
                                  "areaCode":"62",
                                  "phoneNumber":widget.phoneNumber.toString(),
                                  "verificationCode":widget.verificationCode.toString(),
                                  "password":hex.encode(md5.convert(Utf8Encoder().convert(one)).bytes)
                                };
                                ResultData res=await HttpManager.getInstance().post(Api.register, params);
                                if (res.isSuccess) {
                                    _success(res);
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
                )
              ],
            ),
          ),
        ],
      )
    );
  }

  void _success(ResultData res)async{
    setState(() {
      this.loginBtnState = false;
    });
      var obj=res.data["data"];
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("loginDatas", jsonEncode(obj));//loginDatas本地存储登录信息！！！
      await GetLoginDatas().then(//登录完成，将信息注入请求头
              (e){
            if(e!=null){
              setState(() {
                this.userInfo=e;
                LogsInterceptors.userId=e["id"].toString();
                LogsInterceptors.token=e["token"].toString();
              });
            }
          }
      );

    if(dialogState==true){
      this.showAlertDialogs(context);
    }else{
      Application.router.navigateTo(context, Routes.home, replace: true, clearStack: true);
    }
  }
}
