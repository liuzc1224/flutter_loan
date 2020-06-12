import 'dart:convert';
import 'package:badges/badges.dart';
import 'package:dio/dio.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutterdemo/common/Api.dart';
import 'package:flutterdemo/common/Toast.dart';
import 'package:flutterdemo/common/get_login_datas.dart';
import 'package:flutterdemo/common/http_manager.dart';
import 'package:flutterdemo/common/result_data.dart';
import 'package:flutterdemo/common/to_h5_page.dart';
import 'package:flutterdemo/language/Localizations.dart';
import 'package:flutterdemo/routers/application.dart';
import 'package:flutterdemo/routers/routers.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Mine extends StatefulWidget {
  @override
  _MineState createState() => _MineState();
}

class _MineState extends State<Mine> {
  bool msgState=false;
  bool uploadState=false;
  var userInfo;
  var newUserHeadImg;
  String phone;
  String headPortrait;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.getUserInfo();
    this.getMsgData();
  }
  void getUserInfo(){
    GetLoginDatas().then(
      (e){
        setState(() {
          this.userInfo=e;
          this.phone=e['phoneNumber'];
          this.headPortrait=e['headPortrait'];
        });
        print(userInfo);
      }
    );
  }
  void getMsgData() async {
    final Map<String, dynamic> _param  = {};
    ResultData res =
    await HttpManager.getInstance().get(Api.message_unread, _param);
    if (res.isSuccess) {
      setState(() {
        if(res.data['data'] !=null && res.data['data']>0){
          msgState=true;
        }else{
          msgState=false;
        }
//        this.msgState = true;
        print(res.data['data']);
      });
    }else {
      ToastAlert.error(res.data['message']);
      print("error");
    }
  }

  void uploadANDchange () async {//上传头像并更新头像
    String path = this.newUserHeadImg.path;
    FormData param = FormData.fromMap({
      "headPortraitFile" : await MultipartFile.fromFile(
          path
      )
    });
    Application.router.pop(context);
    ResultData res = await HttpManager.getInstance().formData(Api.headPortrait,param);
    print(res.data);
    if (res.isSuccess) {
      Map<String, dynamic> params={};
      Application.router.pop(context);
      ResultData resData = await HttpManager.getInstance().formData(Api.getDetail,params);
      if (resData.isSuccess) {
          setState(() async {
            this.uploadState = false;
            var obj=resData.data["data"];
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setString("loginDatas", jsonEncode(obj));//loginDatas本地存储登录信息！！！
            this.getUserInfo();
          });
      }else {
        this.uploadState = false;
        print("error");
        ToastAlert.error(res.data['message']);
      }
    }else {
      print("error");
      this.uploadState = false;
      ToastAlert.error(res.data['message']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(L.of(context).$['userInfo']['title'],style: TextStyle(color: Color(0xFF494951)),),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: <Widget>[
          IconButton(
              icon: msgState ? Badge(
                badgeContent: Text(''),
                child: Image.asset("images/icon_nav_xiaoxi.png",width: 24,color: Color(0xFF494951)),
              ) : Image.asset("images/icon_nav_xiaoxi.png",width: 24,color: Color(0xFF494951)),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ToH5Page(url:H5.msgCenter),
                  ),
                );
              }
          )
        ],
      ),
      body: ListView(
        children: <Widget>[
          Container(
            width: double.infinity,
            height: 172.95,
            alignment: Alignment.topCenter,
            padding: EdgeInsets.only(top: 15.5),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("images/userBg.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              children: <Widget>[
                uploadState ? ClipOval(child: Container(
                  color: Color(0xFF999999),
                  height: 84,
                  width: 84,
                  child: Container(
                    width: 20,
                    height: 20,
                    child: Center(
                      child:CircularProgressIndicator(
                        strokeWidth:4.0,
                        backgroundColor:Color(0xFFEEEEEE),
//                        valueColor:AlwaysStoppedAnimation(const Color(0xFFEEEEEE)),
                      ),
                    ),
                  )

                ))
                    : InkWell(
                  onTap: ()async{
                    showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return new Container(
                          height: 150.0,
                          color: const Color(0xFFEFF3F4),
                          child: Column(
                            children: <Widget>[
                              InkWell( //在最外层包裹InkWell组件
                                onTap: () async {
                                  var image =
                                  await ImagePicker.pickImage(source: ImageSource.camera,imageQuality:40);
                                  setState(() {
                                    this.newUserHeadImg = image;
                                    this.uploadState = true;
                                    this.uploadANDchange();//上传头像并更新头像
                                  });
                                },
                                child: Container(
                                  color: const Color(0xFFFFFFFF),
                                  height: 49,
                                  alignment: Alignment.center,
                                  child: Text(L
                                      .of(context)
                                      .$['take']),
                                ),
                              ),
                              SizedBox(height: 1,
                                  child: Container(color: Color(0xFFF4F4F4))),
                              InkWell( //在最外层包裹InkWell组件
                                onTap: () async {
                                  var image =
                                  await ImagePicker.pickImage(source: ImageSource.gallery,imageQuality:40);
                                  setState(() {
                                    this.newUserHeadImg = image;
                                    this.uploadState = true;
                                    this.uploadANDchange();//上传头像并更新头像
                                  });
                                },
                                child: Container(
                                  color: const Color(0xFFFFFFFF),
                                  height: 50,
                                  alignment: Alignment.center,
                                  child: Text(L
                                      .of(context)
                                      .$['photo']),
                                ),
                              ),
                              SizedBox(height: 1,
                                  child: Container(color: Color(0xFFF4F4F4))),
                              InkWell( //在最外层包裹InkWell组件
                                onTap: () async {
                                  Application.router.pop(context);
                                },
                                child: Container(
                                  color: const Color(0xFFFFFFFF),
                                  height: 48,
                                  alignment: Alignment.center,
                                  child: Text(L
                                      .of(context)
                                      .$['cancel'],style: TextStyle(color: Color(0xFF999999)),),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ).then((val) {
                      print(val);
                    });
                  },
                  child: ClipOval(child: headPortrait!=null ? Image.network(headPortrait, fit: BoxFit.cover) :  Image.asset("images/head.png",width: 84,)),
                ),
                SizedBox(height: 18,),
                Text(phone!=null ? phone.substring(0,3)+"****"+phone.substring(phone.length-4,phone.length) : "",style: TextStyle(color: Colors.white,fontSize: 18),),
              ],
            ),
          ),
          ListTile(
            title:Text(L.of(context).$['userInfo']['order'],style: TextStyle(color: Color(0xFF494951),fontSize: 16),),
            leading:Image.asset("images/icon_lsdd.png",width:24,),
            enabled:true,
            onTap:()async{//历史订单！！！！！！！！！！
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ToH5Page(url:H5.historicalOrder),
                ),
              );
            },
          ),
          SizedBox(height:1,child:Container(color: Color(0xFFEEEEEE)),),
          ListTile(
            title:Text(L.of(context).$['userInfo']['coupon'],style: TextStyle(color: Color(0xFF494951),fontSize: 16),),
            leading:Image.asset("images/icon_wdyhq.png",width:24,),
            enabled:true,
            onTap:(){//我的优惠券！！！！！！！！！！
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ToH5Page(url:H5.coupon),
                ),
              );
            },
          ),
          SizedBox(height:1,child:Container(color: Color(0xFFEEEEEE)),),
          ListTile(
            title:Text(L.of(context).$['userInfo']['inviteFriends'],style: TextStyle(color: Color(0xFF494951),fontSize: 16),),
            leading:Image.asset("images/icon_yqhy.png",width:24,),
            enabled:true,
            onTap:(){//邀请好友！！！！！！！！！！
              Application.router.navigateTo(context, Routes.inviteFriends,transition: TransitionType.inFromRight);
            },
          ),
          SizedBox(height:1,child:Container(color: Color(0xFFEEEEEE)),),
          ListTile(
            title:Text(L.of(context).$['userInfo']['helpCenter'],style: TextStyle(color: Color(0xFF494951),fontSize: 16),),
            leading:Image.asset("images/icon_bzzx.png",width:24,),
            enabled:true,
            onTap:(){//帮助中心！！！！！！！！！！
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ToH5Page(url:H5.helpCenter),
                ),
              );
            },
          ),
          SizedBox(height:1,child:Container(color: Color(0xFFEEEEEE)),),
          ListTile(
            title:Text(L.of(context).$['userInfo']['setUp'],style: TextStyle(color: Color(0xFF494951),fontSize: 16),),
            leading:Image.asset("images/icon_sz.png",width:24,),
            enabled:true,
            onTap:(){//设置！！！！！！！！！！
              Application.router.navigateTo(context, Routes.setting);
            },
          ),
          SizedBox(height:1,child:Container(color: Color(0xFFEEEEEE)),),
        ],
      ),
    );
  }
}