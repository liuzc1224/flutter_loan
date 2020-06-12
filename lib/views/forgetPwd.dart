import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterdemo/common/Api.dart';
import 'package:flutterdemo/common/Toast.dart';
import 'package:flutterdemo/common/http_manager.dart';
import 'package:flutterdemo/common/result_data.dart';
import 'package:flutterdemo/language/Localizations.dart';
import 'package:flutterdemo/routers/application.dart';
import 'package:flutterdemo/routers/routers.dart';

class ForgetPwd extends StatefulWidget {
  final phoneNumber;

  const ForgetPwd({Key key, this.phoneNumber})
      : super(key: key);
  @override
  _ForgetPwdState createState() => _ForgetPwdState();
}

class _ForgetPwdState extends State<ForgetPwd> {
  FocusNode text1FocusNode = FocusNode();
  FocusNode text2FocusNode = FocusNode();
  FocusNode text3FocusNode = FocusNode();
  FocusNode text4FocusNode = FocusNode();
  TextEditingController code1=new TextEditingController();
  TextEditingController code2=new TextEditingController();
  TextEditingController code3=new TextEditingController();
  TextEditingController code4=new TextEditingController();
  Timer _timer;
  int _countdownTime = 0;
  bool btnState=true;
  bool sendState=true;
  bool pwdShow=true;
  bool pwdTwoShow=true;
  TextEditingController newPwd=new TextEditingController();
  TextEditingController newPwdTwo=new TextEditingController();

  @override
  void dispose(){
    super.dispose();
    newPwd.dispose();
    newPwdTwo.dispose();
    if (_timer != null) {
      _timer.cancel();
    }
  }
  //倒计时
  void startCountdownTimer() {
    const oneSec = const Duration(seconds: 1);

    var callback = (timer) => {
      setState(() {
        if (_countdownTime < 1) {
          this.sendState=true;
          _timer.cancel();
        } else {
          _countdownTime = _countdownTime - 1;
        }
      })
    };
    _timer = Timer.periodic(oneSec, callback);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: new Text(L.of(context).$['passWord']['forget'],style: TextStyle(color: Color(0xFFFFFFFF))),
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
                SizedBox(height: 9),
                Container(
                  alignment: Alignment.center,
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 9),
                      Text(L.of(context).$['passWord']['sendTip'],style: TextStyle(color: Color(0xFF494951),fontSize: 15),textAlign: TextAlign.center,),
                      SizedBox(height: 15),
                      GestureDetector(//在最外层包裹InkWell组件
                        onTap: ()async{
                          if(sendState){
                            setState(() {
                              this.sendState=false;
                            });
                            if (_countdownTime == 0) {
                              //Http请求发送验证码
                              setState(() {
                                _countdownTime = 60;
                              });
                              //开始倒计时
                              startCountdownTimer();
                            }
                            Map<String, dynamic> params={
                              "areaCode":"62",
                              "phoneNumber":widget.phoneNumber,
                              "verificationType":2
                            };
                            ResultData res=await HttpManager.getInstance().get(Api.send_verification_code, params);
                            print(res.data);
                            if (!res.isSuccess) {
                              ToastAlert.error(res.data['message']);
                            }
                          }
                        },
                        child: Text( _countdownTime > 0 ? '${_countdownTime}s' : L.of(context).$['login']['sendCode'], style: TextStyle(fontSize: 12,color: Color(0xFF5999F6))),
                      ),
                    ],
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        child: TextField(
                            autofocus:true,
                            focusNode: text1FocusNode,
                            controller: code1,
                            textAlign: TextAlign.center,
                            style:TextStyle(color: Color(0xFF5999F6),fontSize: 27),
                            inputFormatters: [
                              WhitelistingTextInputFormatter(RegExp("[0-9]")),
                              LengthLimitingTextInputFormatter(1)
                            ],
                            onChanged: (value) {
                              if(value.toString().length>0){
                                text1FocusNode.unfocus();
                                FocusScope.of(context).requestFocus(text2FocusNode);
                              }
                            }
                        ),
                      ),
                      flex: 1,
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        child: TextField(
                            autofocus:true,
                            textAlign: TextAlign.center,
                            focusNode: text2FocusNode,
                            controller: code2,
                            style:TextStyle(color: Color(0xFF5999F6),fontSize: 27),
                            inputFormatters: [
                              WhitelistingTextInputFormatter(RegExp("[0-9]")),
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
                            }
                        ),
                      ),
                      flex: 1,
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        child: TextField(
                            autofocus:true,
                            textAlign: TextAlign.center,
                            focusNode: text3FocusNode,
                            controller: code3,
                            style:TextStyle(color: Color(0xFF5999F6),fontSize: 27),
                            inputFormatters: [
                              WhitelistingTextInputFormatter(RegExp("[0-9]")),
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
                            }
                        ),
                      ),
                      flex: 1,
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        child: TextField(
                            autofocus:true,
                            textAlign: TextAlign.center,
                            focusNode: text4FocusNode,
                            controller: code4,
                            style:TextStyle(color: Color(0xFF5999F6),fontSize: 27),
                            inputFormatters: [
                              WhitelistingTextInputFormatter(RegExp("[0-9]")),
                              LengthLimitingTextInputFormatter(1)
                            ],
                            onChanged: (value) {
                              if(value.toString().length==0){
                                text4FocusNode.unfocus();
                                FocusScope.of(context).requestFocus(text3FocusNode);
                              }
                            }
                        ),
                      ),
                      flex: 1,
                    )
                  ],
                ),
                SizedBox(height: 25),
                Text.rich(
                  TextSpan(
                    text: L.of(context).$['passWord']['new'],
                    style: TextStyle(color: Color(0xFF494951),fontSize: 16),// default text style
                    children: <TextSpan>[
                      TextSpan(text: '*',style: TextStyle(color: Color(0xFFFF0101))),
                    ],
                  ),
                ),
                SizedBox(height: 15.5),
                TextField(
                    autofocus:true,
                    controller: newPwd,
                  obscureText: pwdShow,
                    style:TextStyle(color: Color(0xFF5999F6),fontSize: 13.33),
                    decoration:InputDecoration(
                      border: new OutlineInputBorder(  //添加边框
                        borderRadius: BorderRadius.circular(6.0),
                      ),
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
                      contentPadding: const EdgeInsets.symmetric(vertical:0,horizontal:10),
                    ),
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(20)
                    ],
                ),
                SizedBox(height: 10.5),
                Text(L.of(context).$['passWord']['tip'],style: TextStyle(color: Color(0xFFCCCCCC),fontSize: 13)),
                SizedBox(height: 14),
                Text.rich(
                  TextSpan(
                    text: L.of(context).$['passWord']['again'],
                    style: TextStyle(color: Color(0xFF494951),fontSize: 16),// default text style
                    children: <TextSpan>[
                      TextSpan(text: '*',style: TextStyle(color: Color(0xFFFF0101))),
                    ],
                  ),
                ),
                SizedBox(height: 15.5),
                TextField(
                    autofocus:true,
                    controller: newPwdTwo,
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
                SizedBox(height: 29),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                        child: Container(
                          height: 40,
                          margin: EdgeInsets.only(top: 24.8),
                          child: RaisedButton(
                              child: Text(L.of(context).$['passWord']['setting']),
                              color: Color(0xFF4F8AD9),
                              textColor: Color(0xFFFFFFFF),
                              elevation: 10,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(42.33)
                              ),
                              onPressed: btnState ? ()async{
                                var value1=code1.text.toString();
                                var value2=code2.text.toString();
                                var value3=code3.text.toString();
                                var value4=code4.text.toString();
                                var pwd=newPwd.text.toString();
                                var pwdTwo=newPwdTwo.text.toString();
                                if(value1==null || value2==null || value3==null || value4==null){
                                  ToastAlert.error(L.of(context).$['passWord']['codeError']);
                                }
                                if(pwd.length<1){
                                  ToastAlert.error(L.of(context).$['passWord']['title']);
                                  return;
                                }
                                if(!RegExp(r"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,20}$").hasMatch(pwd)){
                                  ToastAlert.error(L.of(context).$['passWord']['tip']);
                                  return;
                                }
                                if(pwd!=pwdTwo){
                                  ToastAlert.error(L.of(context).$['passWord']['pwdError']);
                                  return;
                                }
                                setState(() {
                                  this.btnState=false;
                                });
                                Map<String, dynamic> params={
                                  "phoneNumber":widget.phoneNumber,
                                  "area":" ",
                                  "areaCode":"62",
                                  "password":pwd,
                                  "invitationCode":value1+value2+value3+value4,
                                };
                                ResultData res=await HttpManager.getInstance().patch(Api.forget_password, params);
                                print(res.data);
                                setState(() {
                                  this.btnState=true;
                                });
                                if (res.isSuccess) {
                                  ToastAlert.success(L.of(context).$['passWord']['success']);
                                  Application.router.navigateTo(context, Routes.login, replace: true, clearStack: true);
                                }else{
//                                  Application.router.navigateTo(context, Routes.login, replace: true, clearStack: true);
                                  ToastAlert.error(res.data['message']);
                                }
                              }: null,
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
}
