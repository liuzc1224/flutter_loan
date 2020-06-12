import 'package:easy_contact_picker/easy_contact_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutterdemo/common/Api.dart';
import 'package:flutterdemo/common/Toast.dart';
import 'package:flutterdemo/common/http_manager.dart';
import 'package:flutterdemo/common/logs_interceptor.dart';
import 'package:flutterdemo/common/result_data.dart';
import 'package:flutterdemo/language/Localizations.dart';
import 'package:flutterdemo/routers/application.dart';
import 'package:flutterdemo/routers/routers.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthContact extends StatefulWidget {
  @override
  _AuthContactState createState() => _AuthContactState();
}

class _AuthContactState extends State<AuthContact> with WidgetsBindingObserver {
  var relationNum1, relationNum2, relationNum3;
  List relationList = <String>[
    'ayah',
    'ibu',
    'pasangan',
    'anak-anak',
    'kolega',
    'teman',
    'kerabat'
  ]; //从1开始
  List relationList2 = <String>[
    'ayah',
    'ibu',
    'pasangan',
    'anak-anak',
    'kolega',
    'teman',
    'kerabat'
  ]; //从1开始
  List relationList3 = <String>[
    'ayah',
    'ibu',
    'pasangan',
    'anak-anak',
    'kolega',
    'teman',
    'kerabat'
  ]; //从1开始
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _getData();
    createTime = new DateTime.now().millisecondsSinceEpoch; // 获取时间
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        cPhone1.text = _contact.phoneNumber.toString();
        break;
      case AppLifecycleState.paused:
        break;
      default:
        break;
    }
  }

  var createTime;

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(L.of(context).$['authContact']['title']),
      ),
      body: Container(
        width: double.infinity,
        child: ListView(
          children: <Widget>[
            Container(
              width: double.infinity,
              height: 40,
              color: Color(0xffFFEED6),
              alignment: Alignment.center,
              child: Text(
                L.of(context).$['authContact']['hint_top'],
                style: TextStyle(
                    fontSize: 13,
                    color: Color(0xff999999),
                    backgroundColor: Color(0xffFFEED6)),
              ),
            ),
            SizedBox(height: 9.0),
            Container(
              width: double.infinity,
              alignment: Alignment.topLeft,
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  /**
                   * 联系人1
                   */
                  SizedBox(height: 9.0),
                  Text.rich(
                    TextSpan(
                      text: L.of(context).$['authContact']['hint_c1'],
                      style: TextStyle(color: Color(0xFF333333), fontSize: 15),
                      // default text style
                      children: <TextSpan>[
                        TextSpan(
                            text: "*",
                            style: TextStyle(color: Color(0xFFFF0000))),
                      ],
                    ),
                  ),
                  SizedBox(height: 9.0),
                  Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      padding: EdgeInsets.only(left: 10, right: 20),
                      width: double.infinity,
                      alignment: Alignment.centerLeft,
                      //设置圆角边框
                      decoration: new BoxDecoration(
                        border: new Border.all(
                            color: Color(0xff494951), width: 0.5),
                        borderRadius: new BorderRadius.circular(5),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: relationNum1,
                          hint: new Text(
                            L.of(context).$['authContact']['hint_relation'],
                            style: TextStyle(
                                color: Color(0xFF999999), fontSize: 15),
                          ),
                          isDense: false,
                          style:
                              TextStyle(fontSize: 15, color: Color(0xFF333333)),
                          isExpanded: true,
                          onChanged: (String newValue) {
                            setState(() {
                              relationNum1 = newValue;
                            });
                          },
                          items: dropdownItems(relationList),
                        ),
                      )),
                  //姓名
                  TextField(
                    controller: cName1,
                    style: TextStyle(fontSize: 15, color: Color(0xff494951)),
                    decoration: InputDecoration(
                        hintText: L.of(context).$['authContact']['hint_name'],
                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
//            borderSide: BorderSide(color: Colors.red, width: 3.0, style: BorderStyle.solid)//没什么卵效果
                        )),
                  ),
                  SizedBox(height: 9.0),
                  //电话
                  TextField(
                    controller: cPhone1,
                    style: TextStyle(fontSize: 15, color: Color(0xff494951)),
                    keyboardType: TextInputType.number,
                    readOnly: true,
                    decoration: InputDecoration(
                        suffix: GestureDetector(
                          onTap: () {
                            _getContactData(1);
                          },
                          child: Image.asset(
                            "images/img_lxr.png",
                            height: 18,
                            width: 18,
                            color: Colors.blue,
                          ),
                        ),
                        hintText: L.of(context).$['authContact']['hint_phone'],
                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
//            borderSide: BorderSide(color: Colors.red, width: 3.0, style: BorderStyle.solid)//没什么卵效果
                        )),
                  ),

                  /**
                   * 联系人2
                   */
                  SizedBox(height: 9.0),
                  Text.rich(
                    TextSpan(
                      text: L.of(context).$['authContact']['hint_c2'],
                      style: TextStyle(color: Color(0xFF333333), fontSize: 15),
                      // default text style
                      children: <TextSpan>[
                        TextSpan(
                            text: "*",
                            style: TextStyle(color: Color(0xFFFF0000))),
                      ],
                    ),
                  ),
                  SizedBox(height: 9.0),
                  Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      padding: EdgeInsets.only(left: 10, right: 20),
                      width: double.infinity,
                      alignment: Alignment.centerLeft,
                      //设置圆角边框
                      decoration: new BoxDecoration(
                        border: new Border.all(
                            color: Color(0xff494951), width: 0.5),
                        borderRadius: new BorderRadius.circular(5),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: relationNum2,
                          hint: new Text(
                            L.of(context).$['authContact']['hint_relation'],
                            style: TextStyle(
                                color: Color(0xFF999999), fontSize: 15),
                          ),
                          isDense: false,
                          style:
                              TextStyle(fontSize: 15, color: Color(0xFF333333)),
                          isExpanded: true,
                          onChanged: (String newValue) {
                            setState(() {
                              relationNum2 = newValue;
                            });
                          },
                          items: dropdownItems(relationList2),
                        ),
                      )),
                  //姓名
                  TextField(
                    controller: cName2,
                    style: TextStyle(fontSize: 15, color: Color(0xff494951)),
                    decoration: InputDecoration(
                        hintText: L.of(context).$['authContact']['hint_name'],
                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
//            borderSide: BorderSide(color: Colors.red, width: 3.0, style: BorderStyle.solid)//没什么卵效果
                        )),
                  ),
                  SizedBox(height: 9.0),
                  //电话
                  TextField(
                    controller: cPhone2,
                    style: TextStyle(fontSize: 15, color: Color(0xff494951)),
                    keyboardType: TextInputType.number,
                    readOnly: true,
                    decoration: InputDecoration(
                        suffix: GestureDetector(
                          onTap: () {
                            _getContactData(2);
                          },
                          child: Image.asset(
                            "images/img_lxr.png",
                            height: 18,
                            width: 18,
                            color: Colors.blue,
                          ),
                        ),
                        hintText: L.of(context).$['authContact']['hint_phone'],
                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
//            borderSide: BorderSide(color: Colors.red, width: 3.0, style: BorderStyle.solid)//没什么卵效果
                        )),
                  ),
                  /**
                   * 联系人2
                   */
                  SizedBox(height: 9.0),
                  Text.rich(
                    TextSpan(
                      text: L.of(context).$['authContact']['hint_c3'],
                      style: TextStyle(color: Color(0xFF333333), fontSize: 15),
                      // default text style
                      children: <TextSpan>[
                        TextSpan(
                            text: "*",
                            style: TextStyle(color: Color(0xFFFF0000))),
                      ],
                    ),
                  ),
                  SizedBox(height: 9.0),
                  Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      padding: EdgeInsets.only(left: 10, right: 20),
                      width: double.infinity,
                      alignment: Alignment.centerLeft,
                      //设置圆角边框
                      decoration: new BoxDecoration(
                        border: new Border.all(
                            color: Color(0xff494951), width: 0.5),
                        borderRadius: new BorderRadius.circular(5),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: relationNum3,
                          hint: new Text(
                            L.of(context).$['authContact']['hint_relation'],
                            style: TextStyle(
                                color: Color(0xFF999999), fontSize: 15),
                          ),
                          isDense: false,
                          style:
                              TextStyle(fontSize: 15, color: Color(0xFF333333)),
                          isExpanded: true,
                          onChanged: (String newValue) {
                            setState(() {
                              relationNum3 = newValue;
                            });
                          },
                          items: dropdownItems(relationList3),
                        ),
                      )),
                  //姓名
                  TextField(
                    controller: cName3,
                    style: TextStyle(fontSize: 15, color: Color(0xff494951)),
                    decoration: InputDecoration(
                        hintText: L.of(context).$['authContact']['hint_name'],
                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
//            borderSide: BorderSide(color: Colors.red, width: 3.0, style: BorderStyle.solid)//没什么卵效果
                        )),
                  ),
                  SizedBox(height: 9.0),
                  //电话
                  TextField(
                    controller: cPhone3,
                    style: TextStyle(fontSize: 15, color: Color(0xff494951)),
                    keyboardType: TextInputType.number,
                    readOnly: true,
                    decoration: InputDecoration(
                        suffix: GestureDetector(
                          onTap: () {
                            _getContactData(3);
                          },
                          child: Image.asset(
                            "images/img_lxr.png",
                            height: 18,
                            width: 18,
                            color: Colors.blue,
                          ),
                        ),
                        hintText: L.of(context).$['authContact']['hint_phone'],
                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
//            borderSide: BorderSide(color: Colors.red, width: 3.0, style: BorderStyle.solid)//没什么卵效果
                        )),
                  ),

                  /**
                   * 下一步按钮
                   */
                  Container(
                    height: 40,
                    width: double.infinity,
                    margin: EdgeInsets.fromLTRB(20, 30, 20, 150),
                    child: RaisedButton(
                        child:
                            Text(L.of(context).$['authContact']['btn_finish']),
                        color: Color(0xFF4F8AD9),
                        textColor: Color(0xFFFFFFFF),
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(42.33)),
                        onPressed: () {
                          _commitData();
                          //  _getContactData();
                        }),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  TextEditingController cName1 = new TextEditingController();
  TextEditingController cName2 = new TextEditingController();
  TextEditingController cName3 = new TextEditingController();
  TextEditingController cPhone1 = new TextEditingController();
  TextEditingController cPhone2 = new TextEditingController();
  TextEditingController cPhone3 = new TextEditingController();
  List mData = [];

  void _commitData() async {
    String name1 = cName1.text.toString();
    String name2 = cName2.text.toString();
    String name3 = cName3.text.toString();
    String phone1 = cPhone1.text.toString();
    String phone2 = cPhone2.text.toString();
    String phone3 = cPhone3.text.toString();

    if (relationNum1 == null || relationNum2 == null || relationNum3 == null) {
      ToastAlert.tip(L.of(context).$['authContact']['toast_relation']);
      return;
    }
    if (name1.isEmpty || name3.isEmpty || name2.isEmpty) {
      ToastAlert.tip(L.of(context).$['authContact']['toast_name']);
      return;
    }
    if (phone1.isEmpty || phone2.isEmpty || phone3.isEmpty) {
      ToastAlert.tip(L.of(context).$['authContact']['toast_phone']);
      return;
    }
    List bean = [];
    Map<String, dynamic> params11 = {
      "contactName": name1,
      "contactPhone": phone1,
      "relation": relationList.indexOf(relationNum1) + 1,
      "contactGrade": 1
    };
    Map<String, dynamic> params22 = {
      "contactName": name2,
      "contactPhone": phone2,
      "relation": relationList2.indexOf(relationNum2) + 1,
      "contactGrade": 2
    };
    Map<String, dynamic> params33 = {
      "contactName": name3,
      "contactPhone": phone3,
      "relation": relationList3.indexOf(relationNum3) + 1,
      "contactGrade": 3
    };

    bean.add(params11);
    bean.add(params22);
    bean.add(params33);
    Map<String, dynamic> params = {"userContactInputVOS": bean};
    var now = new DateTime.now().millisecondsSinceEpoch;
    ResultData res =
        await HttpManager.getInstance().post(Api.contactInfo, params);
    if (res.isSuccess) {
      setState(() {
        this.mData = res.data['data'];
        _saveTime((now - createTime) / 1000);
      });
      print(res.data);
    } else {
      ToastAlert.error(res.data['message']);
    }
  }

  void _getData() async {
    Map<String, dynamic> params = {};
    ResultData res =
        await HttpManager.getInstance().get(Api.contactInfo, params);
    if (res.isSuccess) {
      setState(() {
        this.mData = res.data['data'];
        if (mData.length == 0) {
          return;
        }
        cName1.text = mData[0]['contactName'];
        cPhone1.text = mData[0]['contactPhone'];
        relationNum1 = relationList[mData[0]['relation'] - 1];

        cName2.text = mData[1]['contactName'];
        cPhone2.text = mData[1]['contactPhone'];
        relationNum2 = relationList2[mData[1]['relation'] - 1];

        cName3.text = mData[2]['contactName'];
        cPhone3.text = mData[2]['contactPhone'];
        relationNum3 = relationList3[mData[2]['relation'] - 1];
      });
    } else {
      ToastAlert.error(res.data['message']);
    }
    print(res.data);
  }

  void _saveTime(var time) async {
    print(time);
    Map<String, dynamic> params = {
      "consumeTime": time,
      "eventName": "contact",
      "userId": LogsInterceptors.userId
    };
    print(LogsInterceptors.userId);
    ResultData res = await HttpManager.getInstance().post(Api.saveTime, params);
    if (res.isSuccess) {
      //  print(res.data);
      // mData = res.data['data'];
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setInt("authContact", 1);
/*      Application.router.navigateTo(context, Routes.authHome,
          replace: true, clearStack: false);*/
      Application.router.pop(context);
    } else {
      ToastAlert.error(res.data['message']);
    }
  }

//选择通讯录
  Contact _contact = new Contact(fullName: "", phoneNumber: "");
  final EasyContactPicker _contactPicker = new EasyContactPicker();

  _getContactData(int type) async {
    Contact contact = await _contactPicker.selectContactWithNative();
    setState(() {
      String phone1 = cPhone1.text.toString();
      String phone2 = cPhone2.text.toString();
      String phone3 = cPhone3.text.toString();
      if (contact.phoneNumber==phone1||
          contact.phoneNumber==phone2 ||
          contact.phoneNumber==phone3) {
        ToastAlert.tip(L.of(context).$['authContact']['toast_noSame']);
        return;
      }

      if (type == 1) {
        cPhone1.text = contact.phoneNumber.toString();
      } else if (type == 2) {
        cPhone2.text = contact.phoneNumber.toString();
      } else if (type == 3) {
        cPhone3.text = contact.phoneNumber.toString();
      }
      print(contact.phoneNumber.toString());
    });
  }
}

dropdownItems(List<String> strList) {
  List<DropdownMenuItem<String>> list = new List();
  list = strList.map<DropdownMenuItem<String>>((String value) {
    return DropdownMenuItem<String>(
      value: value,
      child: Text(value),
    );
  }).toList();
  return list;
}
