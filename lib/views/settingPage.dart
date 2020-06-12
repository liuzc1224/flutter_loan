import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutterdemo/common/Api.dart';
import 'package:flutterdemo/common/get_login_datas.dart';
import 'package:flutterdemo/common/http_manager.dart';
import 'package:flutterdemo/common/result_data.dart';
import 'package:flutterdemo/language/Localizations.dart';
import 'package:flutterdemo/routers/application.dart';
import 'package:flutterdemo/routers/routers.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}


class _SettingPageState extends State<SettingPage> {
  var phone;
  String version="V0.1.0";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    GetLoginDatas().then(
            (e){
              print(e);
          setState(() {
            this.phone=e['phoneNumber'];
            this.version="V"+e['appVersion'];
          });
        }
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Text(L.of(context).$['setting']['title'],style: TextStyle(color: Color(0xFFFFFFFF))),
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
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 14.5),
        child: ListView(
          children: <Widget>[
            ListTile(
              title:Container(
                child: Row(
                  children: <Widget>[
                    Text(L.of(context).$['setting']['about'],style: TextStyle(color: Color(0xFF494951),fontSize: 16),),
                    Expanded(
                      child: Text(version,style: TextStyle(color: Color(0xFF999999),fontSize: 15),textAlign: TextAlign.right,)
                    )
                  ],
                ),
              ),
              enabled:true,
              trailing:Image.asset("images/icon_list_arrow.png",color: Color(0xFF999999)),
              onTap:(){
                Application.router.navigateTo(context, '${Routes.aboutUs}?version=${this.version}',transition: TransitionType.inFromRight);
              },
            ),
            SizedBox(height:1,child:Container(color: Color(0xFFF4F4F4)),),
            ListTile(
              title:Text(L.of(context).$['setting']['updatePwd'],style: TextStyle(color: Color(0xFF494951),fontSize: 16),),
              enabled:true,
              onTap:(){
                Application.router.navigateTo(context, '${Routes.updatePwd}?phoneNumber=${this.phone}',transition: TransitionType.inFromRight);
              },
            ),
            SizedBox(height:1,child:Container(color: Color(0xFFF4F4F4)),),
            ListTile(
              title:Text(L.of(context).$['setting']['out'],style: TextStyle(color: Color(0xFF494951),fontSize: 16),),
              enabled:true,
              onTap:()async{//退出
                Map<String, dynamic> params={};
                ResultData res=await HttpManager.getInstance().delete(Api.logout, params);
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setString("loginDatas", null);
                Application.router.navigateTo(context, Routes.login, replace: true, clearStack: true);
              },
            ),
            SizedBox(height:1,child:Container(color: Color(0xFFF4F4F4)),),
          ],
        ),
      ),
    );
  }
}
