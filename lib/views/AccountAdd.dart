import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterdemo/common/Api.dart';
import 'package:flutterdemo/common/Toast.dart';
import 'package:flutterdemo/common/http_manager.dart';
import 'package:flutterdemo/common/result_data.dart';
import 'package:flutterdemo/language/Localizations.dart';
import 'package:flutterdemo/routers/application.dart';
import 'package:flutterdemo/routers/routers.dart';

class AccountAdd extends StatefulWidget {
  @override
  _AccountAddState createState() => _AccountAddState();
}

class _AccountAddState extends State<AccountAdd> {
  var bankData;
  TextEditingController bankCardNum=new TextEditingController();
  TextEditingController userName=new TextEditingController();
  bool btnState = false;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    bankCardNum.dispose();
    userName.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Text(L.of(context).$['account']['addTitle'],style: TextStyle(color: Color(0xFFFFFFFF))),
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
            height: 40,
            color: Color(0xFFFFEED6),
            alignment: Alignment.center,
            child: Text(L.of(context).$['account']['tip'],style: TextStyle(color: Color(0xFF999999),fontSize: 13)),
          ),
          Container(
            padding: EdgeInsets.all(15.5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text.rich(
                  TextSpan(
                    text: L.of(context).$['account']['bankName'],
                    style: TextStyle(color: Color(0xFF494951),fontSize: 16),// default text style
                    children: <TextSpan>[
                      TextSpan(text: '*',style: TextStyle(color: Color(0xFFFF0101))),
                    ],
                  ),
                ),
                SizedBox(height: 15.5),
                GestureDetector(
                  onTap: (){
                    Application.router.navigateTo(context, Routes.bankPage).then((result){
                      if(result !=null){
                        this.bankData= result;
                        print(result);
                        print(bankData['bankName']);
                      }
                    });
                  },
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: new Border.all(
                          color: Color(0xFF999999), width: 1.1),
                        borderRadius: new BorderRadius.circular(5),
                    ),
                    height: 45,
                    padding: EdgeInsets.only(left: 9),
                    alignment: Alignment.centerLeft,
                    child: bankData!=null ? Text(bankData['bankName'],style: TextStyle(color: Color(0xFF4F8AD9),fontSize: 16),)
                        : Text(L.of(context).$['inSelect'],style: TextStyle(color: Color(0xFF999999),fontSize: 16),),
                  )
                ),
                SizedBox(height: 15),
                Text.rich(
                  TextSpan(
                    text: L.of(context).$['account']['card'],
                    style: TextStyle(color: Color(0xFF494951),fontSize: 16),// default text style
                    children: <TextSpan>[
                      TextSpan(text: '*',style: TextStyle(color: Color(0xFFFF0101))),
                    ],
                  ),
                ),
                SizedBox(height: 15.5),
                TextField(
                  controller: bankCardNum,
                  style:TextStyle(color: Color(0xFF5999F6),fontSize: 13.33),
                  decoration:InputDecoration(
                    hintText:L.of(context).$['input'],
                    hintStyle: TextStyle(color: Color(0xFF999999),fontSize: 16),
                    border: new OutlineInputBorder(  //添加边框
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                    contentPadding: EdgeInsets.all(9.0),
                  ),
                  inputFormatters: [
                    WhitelistingTextInputFormatter(RegExp("[0-9]")),
                    LengthLimitingTextInputFormatter(30)
                  ],
                ),
                SizedBox(height: 15),
                Text.rich(
                  TextSpan(
                    text: L.of(context).$['account']['name'],
                    style: TextStyle(color: Color(0xFF494951),fontSize: 16),// default text style
                    children: <TextSpan>[
                      TextSpan(text: '*',style: TextStyle(color: Color(0xFFFF0101))),
                    ],
                  ),
                ),
                SizedBox(height: 15.5),
                TextField(
                  controller: userName,
                  style:TextStyle(color: Color(0xFF5999F6),fontSize: 13.33),
                  decoration:InputDecoration(
                    hintText:L.of(context).$['input'],
                    hintStyle: TextStyle(color: Color(0xFF999999),fontSize: 16),
                    border: new OutlineInputBorder(  //添加边框
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                    contentPadding: EdgeInsets.all(9.0),
                  ),
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(20)
                  ],
                ),
                Container(
                  width: double.infinity,
                  height: 40,
                  margin: EdgeInsets.only(top: 30.5),
                  child: RaisedButton(
                      child: Text(L.of(context).$['account']['save']),
                      color: Color(0xFF4F8AD9),
                      textColor: Color(0xFFFFFFFF),
                      elevation: 10,
                      disabledTextColor:Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40)
                      ),
                      onPressed: btnState ? null : ()async{
                         var bankCardNumStr=bankCardNum.text.toString();
                         var userNameStr=userName.text.toString();
                        if(bankData==null){
                          ToastAlert.error(L.of(context).$['account']['bankNameTip']);
                          return;
                        }
                        if(bankCardNumStr==null){
                          ToastAlert.error(L.of(context).$['account']['cardTip']);
                          return;
                        }
                        if(userNameStr==null){
                          ToastAlert.error(L.of(context).$['account']['nameTip']);
                          return;
                        }
                        Map<String, dynamic> params={
                          "bankCardNum":bankCardNumStr,
                          "bankCode":bankData['bankCode'],
                          "bankIdOptional":bankData['bankIdOptional'],
                          "bankName":bankData['bankName'],
                          "institutionNumber":bankData['bankCode'],
                          "payPlatform":bankData['payPlatform'],
                          "userName":userNameStr
                        };
                        ResultData res=await HttpManager.getInstance().post(Api.bankAdd, params);
                        print(res.data);
                        if (res.isSuccess) {
                          Navigator.of(context).pop(res.data);
                        }else{
                          ToastAlert.error(res.data['message']);
                        }
//                                Application.router.navigateTo(context,  Routes.passWord);
                      }
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
