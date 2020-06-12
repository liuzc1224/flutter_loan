import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterdemo/common/Api.dart';
import 'package:flutterdemo/common/Toast.dart';
import 'package:flutterdemo/common/http_manager.dart';
import 'package:flutterdemo/common/result_data.dart';
import 'package:flutterdemo/language/Localizations.dart';
import 'package:flutterdemo/routers/application.dart';
import 'package:flutterdemo/routers/routers.dart';

class UpdatePwd extends StatefulWidget {
  final phoneNumber;

  const UpdatePwd({Key key, this.phoneNumber})
      : super(key: key);
  @override
  _UpdatePwdState createState() => _UpdatePwdState();
}

class _UpdatePwdState extends State<UpdatePwd> {
  TextEditingController oldPwd=new TextEditingController();
  TextEditingController newPwd=new TextEditingController();
  TextEditingController newPwdTwo=new TextEditingController();
  bool oldPwdShow=true;
  bool newPwdShow=true;
  bool newPwdTwoShow=true;
  bool btnState=true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: new Text(L.of(context).$['passWord']['update'],style: TextStyle(color: Color(0xFFFFFFFF))),
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
                    text: L.of(context).$['passWord']['old'],
                    style: TextStyle(color: Color(0xFF494951),fontSize: 16),// default text style
                    children: <TextSpan>[
                      TextSpan(text: '*',style: TextStyle(color: Color(0xFFFF0101))),
                    ],
                  ),
                ),
                SizedBox(height: 15.5),
                TextField(
                    controller: oldPwd,
                    obscureText: oldPwdShow,
                    style:TextStyle(color: Color(0xFF5999F6),fontSize: 13.33),
                    decoration:InputDecoration(
                      border: new OutlineInputBorder(  //添加边框
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical:0,horizontal:10),
                      suffix: GestureDetector(
                          onTap: (){
                            setState(() {
                              oldPwdShow=!oldPwdShow;
                            });
                          },
                          child: Icon(
                            Icons.remove_red_eye,
                            size: 20,
                            color: !oldPwdShow ? Color(0xFF5999F6) : Colors.grey,
                          )
                      )
                    ),
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(20)
                    ],
                ),
                SizedBox(height: 10.5),
                Text(L.of(context).$['passWord']['tip'],style: TextStyle(color: Color(0xFFCCCCCC),fontSize: 13)),
                SizedBox(height: 13),
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
                    controller: newPwd,
                    obscureText: newPwdShow,
                    style:TextStyle(color: Color(0xFF5999F6),fontSize: 13.33),
                    decoration:InputDecoration(
                      border: new OutlineInputBorder(  //添加边框
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical:0,horizontal:10),
                      suffix: GestureDetector(
                          onTap: (){
                            setState(() {
                              newPwdShow=!newPwdShow;
                            });
                          },
                          child: Icon(
                            Icons.remove_red_eye,
                            size: 20,
                            color: !newPwdShow ? Color(0xFF5999F6) : Colors.grey,
                          )
                      )
                    ),
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(20)
                    ],
                ),
                SizedBox(height: 10.5),
                Text(L.of(context).$['passWord']['tip'],style: TextStyle(color: Color(0xFFCCCCCC),fontSize: 13)),
                SizedBox(height: 13),
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
                    controller: newPwdTwo,
                    obscureText: newPwdTwoShow,
                    style:TextStyle(color: Color(0xFF5999F6),fontSize: 13.33),
                    decoration:InputDecoration(
                      border: new OutlineInputBorder(  //添加边框
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical:0,horizontal:10),
                        suffix: GestureDetector(
                            onTap: (){
                              setState(() {
                                newPwdTwoShow=!newPwdTwoShow;
                              });
                            },
                            child: Icon(
                              Icons.remove_red_eye,
                              size: 20,
                              color: !newPwdTwoShow ? Color(0xFF5999F6) : Colors.grey,
                            )
                        )
                    ),
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(20)
                    ],
                ),
                SizedBox(height: 10.5),
                Text(L.of(context).$['passWord']['tip'],style: TextStyle(color: Color(0xFFCCCCCC),fontSize: 13)),
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
                SizedBox(height: 34.8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                        child: Container(
                          height: 42.33,
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
                                var old=oldPwd.text.toString();
                                var newPassWord=newPwd.text.toString();
                                var newPassWordTwo=newPwdTwo.text.toString();
                                if(old.length<1 || newPassWord.length<1 || newPassWordTwo.length<1){
                                  ToastAlert.error(L.of(context).$['passWord']['prompt']);
                                  return;
                                }
                                if(!RegExp(r"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,20}$").hasMatch(old)){
                                  ToastAlert.error(L.of(context).$['passWord']['tip']);
                                  return;
                                }
                                if(!RegExp(r"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,20}$").hasMatch(newPassWord)){
                                  ToastAlert.error(L.of(context).$['passWord']['tip']);
                                  return;
                                }
                                if(!RegExp(r"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,20}$").hasMatch(newPassWordTwo)){
                                  ToastAlert.error(L.of(context).$['passWord']['tip']);
                                  return;
                                }
                                if(newPassWord!=newPassWordTwo){
                                  ToastAlert.error(L.of(context).$['passWord']['pwdError']);
                                }
                                setState(() {
                                  this.btnState=false;
                                });
                                Map<String, dynamic> params={
                                  "area":" ",
                                  "areaCode":"62",
                                  "phoneNumber":widget.phoneNumber.toString(),
                                  "password":newPassWord,
                                  "oldPassword":old,
                                  "verificationCode":""
                                };
                                ResultData res=await HttpManager.getInstance().patch(Api.update_password, params);
                                setState(() {
                                  this.btnState=false;
                                });
                                if (res.isSuccess) {
                                  ToastAlert.success(L.of(context).$['passWord']['success']);
                                  Application.router.navigateTo(context, Routes.login, replace: true, clearStack: true);
                                }else{
                                   ToastAlert.error(res.data['message']);
                                }
                              } : null,
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
