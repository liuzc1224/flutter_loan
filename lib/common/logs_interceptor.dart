import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutterdemo/common/Toast.dart';
import 'package:flutterdemo/common/get_login_datas.dart';
import 'package:flutterdemo/common/response_interceptor.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LogsInterceptors extends InterceptorsWrapper {
  static var userId;
  static var token;
  static var Language;
  static var longitude;
  static var latitude;
  @override
  onRequest(RequestOptions options) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userInfo= prefs.getString("loginDatas")!=null ? await jsonDecode(prefs.getString("loginDatas")) : null;
    var locationData= prefs.getString("locationData")!=null ? await jsonDecode(prefs.getString("locationData")) : null;
    userId = userInfo!=null ? userInfo['id'] : null;
    token = userInfo!=null ? userInfo['token'] : null;
    Language = prefs.getString("Language") !=null ? await prefs.getString("Language") : null;
    longitude = locationData!=null ? locationData['longitude'] : null;
    latitude = locationData!=null ? locationData['latitude'] : null;
  Map<String, dynamic> headersMap;
  // print(options.path);
//    userId="3476";
//    token="701f5b67-54a4-4b5f-971f-5109d45c4e93";
    headersMap= {
      'Content-type': 'application/json;',
      'Accept-Language': Language==null ? 'in-ID' : Language,
      'g4-deviceId':'111',
      'g4-vest':"9",
      'g4-uid': userId==null ? "-100" : userId,
      'g4-osType':"1",
      'g4-systemVersion':'9',
      'g4-deviceType':'9',
      'g4-appVersion':'9',
      'g4-longitude': longitude==null ? "  " : longitude,//经度
      'g4-latitude': latitude==null ? "  " : latitude,//纬度
      'X-Auth-Token':'9',
      'X-ADVAI-KEY':'9',
      'g4-clientId':'-1',
      'g4-appsflyId':'11',
      'packageName':'demo',
      "Accept-Encoding": "identity",
//     " g4-token": "token",  //实际使用这个
    };
    if( token!=null ){
      headersMap['g4-token']=token;
    }
    options.headers=headersMap;
    print("请求baseUrl：${options.baseUrl}");
    print("请求url：${options.path}");
    print('请求头: ' + options.headers.toString());
    if (options.data != null) {
      print('请求参数: ' + options.data.toString());
    }
    return options;
  }

  @override
  onResponse(Response response)async {
    if (response != null) {
      var responseStr = response.toString();
    }

    return response; // continue
  }

  @override
  onError(DioError err) async{
    print('请求异常: ' + err.toString());
    print('请求异常信息: ' + err.response?.toString() ?? "");
    if(err.toString().contains("401")){
      print("555");
      ResponseInterceptors.navigatorKey.currentState.pushNamedAndRemoveUntil("/login",
          ModalRoute.withName("/"));
    }else{
      ToastAlert.error("请求错误");
    }
      return err;
  }
}
