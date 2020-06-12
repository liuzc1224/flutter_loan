import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterdemo/common/Api.dart';
import 'package:flutterdemo/common/Toast.dart';
import 'package:flutterdemo/common/http_manager.dart';
import 'package:flutterdemo/common/logs_interceptor.dart';
import 'package:flutterdemo/common/result_data.dart';
import 'package:flutterdemo/language/Localizations.dart';
import 'package:flutterdemo/language/in.dart';
import 'package:flutterdemo/routers/application.dart';
import 'package:flutterdemo/routers/routers.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthIdentity extends StatefulWidget {
  @override
  _AuthIdentityState createState() => _AuthIdentityState();
}

class _AuthIdentityState extends State<AuthIdentity> {
  bool isImage = false;
  TextEditingController cName = new TextEditingController();
  TextEditingController cNumber = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(L.of(context).$['authIdentity']['title']),
      ),
      body: Container(
        margin: EdgeInsets.all(12),
        width: double.infinity,
        child: ListView(
          children: <Widget>[
            Text.rich(
              TextSpan(
                text: L.of(context).$['authIdentity']['hintUpload'],
                style: TextStyle(color: Color(0xFF333333), fontSize: 15),
                // default text style
                children: <TextSpan>[
                  TextSpan(
                      text: "*", style: TextStyle(color: Color(0xFFFF0000))),
                ],
              ),
            ),
            SizedBox(height: 9.0),
            GestureDetector(
              onTap: () async {
                FocusScope.of(context).requestFocus(FocusNode());

                var img =
                    await ImagePicker.pickImage(source: ImageSource.camera,imageQuality:40);
               // var img1=  testCompressAndGetFile(img, img.path);

                setState(() {
                  imgUrl="";
                  platformLogoFile = img;

                  /// s();
                });
              },
              child: imgUrl!=null
                  ? Image.network(imgUrl,
                  width: double.infinity, fit: BoxFit.cover, height: 168)
                  : platformLogoFile != null
                  ? Image.file(platformLogoFile,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  height: 168)
                  : Image.asset(
                "images/img_identity.png",
                fit: BoxFit.fill,
                width: double.infinity,
                height: 168,
              ),
            ),
//              child: imgUrl.isNotEmpty
//                  ? Image.network(imgUrl,
//                      width: double.infinity, fit: BoxFit.cover, height: 168)
//                  : platformLogoFile != null
//                      ? Image.file(platformLogoFile,
//                          width: double.infinity,
//                          fit: BoxFit.cover,
//                          height: 168)
//                      : Image.asset(
//                          "images/img_identity.png",
//                          fit: BoxFit.fill,
//                          width: double.infinity,
//                          height: 168,
//                        ),
//            ),
            SizedBox(height: 9.0),
            Text(
              L.of(context).$['authIdentity']['hint1'],
              style: TextStyle(color: Color(0xff999999), fontSize: 13),
            ),
            SizedBox(height: 9.0),
            Text.rich(
              TextSpan(
                text: L.of(context).$['authIdentity']['name'],
                style: TextStyle(color: Color(0xFF333333), fontSize: 15),
                // default text style
                children: <TextSpan>[
                  TextSpan(
                      text: "*", style: TextStyle(color: Color(0xFFFF0000))),
                ],
              ),
            ),
            SizedBox(height: 9.0),
            TextField(
              controller: cName,
              style: TextStyle(fontSize: 15, color: Color(0xff494951)),
              decoration: InputDecoration(
                  hintText: L.of(context).$["input"],
                  contentPadding: EdgeInsets.all(10.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
//            borderSide: BorderSide(color: Colors.red, width: 3.0, style: BorderStyle.solid)//没什么卵效果
                  )),
            ),
            SizedBox(height: 9.0),
            Text.rich(
              TextSpan(
                text: L.of(context).$['authIdentity']['nuber'],
                style: TextStyle(color: Color(0xFF333333), fontSize: 15),
                // default text style
                children: <TextSpan>[
                  TextSpan(
                      text: "*", style: TextStyle(color: Color(0xFFFF0000))),
                ],
              ),
            ),
            SizedBox(height: 9.0),
            TextField(
              maxLength: 16,
              inputFormatters: [
                WhitelistingTextInputFormatter(RegExp("[0-9]")),
                LengthLimitingTextInputFormatter(16)
              ],
              controller: cNumber,
              //  keyboardType: TextInputType.number,
              style: TextStyle(fontSize: 15, color: Color(0xff494951)),
              decoration: InputDecoration(
                  hintText: L.of(context).$["input"],
                  contentPadding: EdgeInsets.all(10.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
//            borderSide: BorderSide(color: Colors.red, width: 3.0, style: BorderStyle.solid)//没什么卵效果
                  )),
            ),
            Text(
              L.of(context).$['authIdentity']['hint2'],
              style: TextStyle(color: Color(0xff999999), fontSize: 13),
            ),
            Container(
              height: 40,
              width: double.infinity,
              margin: EdgeInsets.fromLTRB(20, 30, 20, 20),
              child: RaisedButton(
                  child: Text(L.of(context).$['btn_next']),
                  color: Color(0xFF4F8AD9),
                  textColor: Color(0xFFFFFFFF),
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(42.33)),
                  onPressed: () {
                    s();
                    /* */
                  }),
            )
          ],
        ),
      ),
    );
  }



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getData();

    createTime = new DateTime.now().millisecondsSinceEpoch; // 获取时间
  }

  var createTime;
  var mData;

  String imgUrl = "";

  void _getData() async {
    Map<String, dynamic> params = {"state": true};
    ResultData res = await HttpManager.getInstance().get(Api.identity, params);
    print(mData.toString());
    if (res.isSuccess) {
      mData = res.data['data'];
      if (mData['idNumber'] == null) {
        return;
      }
      cName.text = mData['username'];
      cNumber.text = mData['idNumber'];
      if(mData['front'].toString().isNotEmpty){
        imgUrl = mData['front'];
        isHave=true;
      }
      setState(() {});
    } else {
      ToastAlert.error(res.data['message']);
    }
  }

  File platformLogoFile;
   bool isHave;

  void _commitData() async {
    String name=cName.text.toString();
    String idNo=cNumber.text.toString();
    if(name.isEmpty){
      ToastAlert.tip(L.of(context).$['authIdentity']['toastName']);
      return;
    }
    if(idNo.isEmpty){
      ToastAlert.tip(L.of(context).$['authIdentity']['toastNumber']);
      return;
    }
    if(idNo.length!=16){
      ToastAlert.tip(L.of(context).$['authIdentity']['toastError']);
      return;
    }

    if (imgUrl == null&&isHave==false) {
      ToastAlert.tip(L.of(context).$['authWork']['toast_f']);
      return;
    }

    FormData _param = FormData.fromMap({
      "username": cName.text.toString(),
      "idNumber": cNumber.text.toString(),
      "front": platformLogoFile != null
          ? await MultipartFile.fromFile(platformLogoFile.path)
          : null
    });

    var now = new DateTime.now().millisecondsSinceEpoch;
    ResultData res =
        await HttpManager.getInstance().formData(Api.identity, _param);
    print(res.data);

    if (res.isSuccess) {
      print(res.data);
      _saveTime((now - createTime) / 1000);
    } else {
      ToastAlert.error(res.data['message']);
    }
  }

  void _saveTime(var time) async {
    print(time);
    Map<String, dynamic> params = {
      "consumeTime": time,
      "eventName": "identity",
      "userId": LogsInterceptors.userId
    };
    print(LogsInterceptors.userId);
    ResultData res = await HttpManager.getInstance().post(Api.saveTime, params);
    if (res.isSuccess) {
      print(res.data);
      mData = res.data['data'];
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setInt("authIdentity", 1);
      Application.router.navigateTo(context, Routes.authPerson,
          replace: true, clearStack: false);
    } else {
      ToastAlert.error(res.data['message']);
    }
  }

  void s() async {
//     ImageProperties properties = await FlutterNativeImage.getImageProperties(platformLogoFile.path);
//     File compressedFile = await FlutterNativeImage.compressImage(platformLogoFile.path, quality: 80,
//        targetWidth: 600,
//        targetHeight: (properties.height * 600 / properties.width).round());
//
//     print(compressedFile);
    _commitData();
  }
}
