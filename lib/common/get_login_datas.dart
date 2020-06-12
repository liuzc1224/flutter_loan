import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

Future<Map> GetLoginDatas()  {//获取用户本地登录缓存
  return Future<Map> (()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var loginDatas=await jsonDecode(prefs.getString("loginDatas"));
//    loginDatas['appVersion']="1.0.0";
//    loginDatas['language']="";
     print(loginDatas);
    // print(jsonDecode(loginDatas)["id"]);//获取数据方式
    return (loginDatas!=null) ? loginDatas :null ;//返回InternalLinkedHashMap<String, dynamic>型的数据
  });
}
// }
//数据格式类型
// {
//   id: 100645, 
//   createTime: 2020-02-20 02:32:26, 
//   modifyTime: null, 
//   phoneNumber: 081285290562,
//   password: null, 
//   userName: 081285290562,
//   status: 1, 
//   userGrade: null, 
//   headPortraitUrl: null, 
//   gender: null, 
//   age: null, 
//   birthday: null, 
//   idNumber: null, 
//   email: null, 
//   token: 78ce9d59-1f72-4152-888a-3e546e90a218, 
//   countryName: null, 
//   logoPath: null, 
//   currencyName: null, 
//   vest: 520, 
//   createTimeStr: null
// }