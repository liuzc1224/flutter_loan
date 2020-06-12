import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterdemo/common/Api.dart';
import 'package:flutterdemo/common/Toast.dart';
import 'package:flutterdemo/common/http_manager.dart';
import 'package:flutterdemo/common/logs_interceptor.dart';
import 'package:flutterdemo/common/result_data.dart';
import 'package:flutterdemo/language/Localizations.dart';
import 'package:flutterdemo/routers/application.dart';
import 'package:flutterdemo/routers/routers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthPerson extends StatefulWidget {
  @override
  _AuthPersonState createState() => _AuthPersonState();
}

List eduList = <String>[
  'DIPLOMA_I',
  'DIPLOMA_II',
  'DIPLOMA_III',
  'SLTA',
  'S1',
  'SLTP',
  'S2',
  'SD',
  'S3'
]; //从1开始
List marList = <String>['LAJANG', 'MENIKAH', 'CERAI', 'LAINNYA'];
List childList = <String>[
  'NIHL',
  'SATU',
  'DUA',
  'TIGA',
  'EMPAT',
  'DI_ATAS_EMPAT'
]; //从0开始
List liveTypeList = <String>[
  'provinsi hunian',
  'kota hunian',
  'kecamatan hunian',
  'kelurahan hunian'
]; //从1开始
List shenList = <String>[
  'Aceh',
  'Bali',
  'Bangka Belitung',
  'Banten',
  'Bengkulu',
  'Jawa Tengah',
  'Kalimanatan Tengah',
  'Sulawesi Tengah',
  'Jawa Timur',
  'Kalimantan Timur',
  'Nusa Tenggara Timur',
  'Gorontalo',
  'DKI Jakarta',
  'Jambi',
  'Lampung',
  'Maluku',
  'Kalimantan Utara',
  'Maluku Utara',
  'Sulawesi Utara',
  'Sumatera Utara',
  'Papua',
  'Riau',
  'Kepulauan Riau',
  'Sulawesi Utara',
  'Kalimantan Selatan',
  'Sulawesi Selatan',
  'Sematera Selatan',
  'Jawa Barat',
  'Kalimantan Barat',
  'Nusa Tenggara Barat',
  'Pekan Baru',
  'Sulawesi Barat',
  'Sumatera Barat'
]; //从1开始

class _AuthPersonState extends State<AuthPerson> {
  String eduNum, marNum, childNum, liveTypeNum, shenNum, genderNum;
  var liveTimeNum;
  List liveTimeList = <String>[
    'TIGA_BULAN',
    'ENAM_BULAN',
    'SATU_TAHUN',
    'DUA_TAHUN',
    'DI_ATAS_DUA_TAHUN'
  ]; //从1开始
  List genderList = <String>['wanita', 'pria']; //从0开始

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          L.of(context).$['authPerson']['title'],
        ),
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
                L.of(context).$['authPerson']['hint_top'],
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
                  Text.rich(
                    TextSpan(
                      text: L.of(context).$['authPerson']['hint_mather'],
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

                  ///母亲全名
                  TextField(
                    controller: cMotherName,
                    style: TextStyle(fontSize: 15, color: Color(0xff494951)),
                    decoration: InputDecoration(
                        hintText: L.of(context).$['authPerson']['hint_allName'],
                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
//            borderSide: BorderSide(color: Colors.red, width: 3.0, style: BorderStyle.solid)//没什么卵效果
                        )),
                  ),
                  SizedBox(height: 9.0),
                  Text.rich(
                    TextSpan(
                      text: L.of(context).$['authPerson']['hint_sex'],
                      style: TextStyle(color: Color(0xFF333333), fontSize: 15),
                      // default text style
                      children: <TextSpan>[
                        TextSpan(
                            text: "*",
                            style: TextStyle(color: Color(0xFFFF0000))),
                      ],
                    ),
                  ),


                  ///性别
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
                          value: genderNum,
                          hint: new Text(
                            "请选择",
                            style: TextStyle(
                                color: Color(0xFF999999), fontSize: 15),
                          ),
                          isDense: false,
                          style:
                              TextStyle(fontSize: 15, color: Color(0xFF333333)),
                          isExpanded: true,
                          onChanged: (String newValue) {
                            setState(() {
                              genderNum = newValue;
                            });
                          },
                          items: dropdownItems(genderList),
                        ),
                      )),

                  ///教育程度
                  Text.rich(
                    TextSpan(
                      text: L.of(context).$['authPerson']['hint_edu'],
                      style: TextStyle(color: Color(0xFF333333), fontSize: 15),
                      // default text style
                      children: <TextSpan>[
                        TextSpan(
                            text: "*",
                            style: TextStyle(color: Color(0xFFFF0000))),
                      ],
                    ),
                  ),

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
                        child: DropdownButton(
                          value: eduNum,
                          hint: new Text(
                            "请选择",
                            style: TextStyle(
                                color: Color(0xFF999999), fontSize: 15),
                          ),
                          isDense: false,
                          style:
                              TextStyle(fontSize: 15, color: Color(0xFF333333)),
                          isExpanded: true,
                          onChanged: (value) {
                            setState(() {
                              eduNum = value;
                            });
                          },
                          items: dropdownItems(eduList),
                        ),
                      )),

                  ///婚姻状况
                  Text.rich(
                    TextSpan(
                      text: L.of(context).$['authPerson']['hint_marital'],
                      style: TextStyle(color: Color(0xFF333333), fontSize: 15),
                      // default text style
                      children: <TextSpan>[
                        TextSpan(
                            text: "*",
                            style: TextStyle(color: Color(0xFFFF0000))),
                      ],
                    ),
                  ),

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
                          value: marNum,
                          hint: new Text(
                            "请选择",
                            style: TextStyle(
                                color: Color(0xFF999999), fontSize: 15),
                          ),
                          isDense: false,
                          style:
                              TextStyle(fontSize: 15, color: Color(0xFF333333)),
                          isExpanded: true,
                          onChanged: (String newValue) {
                            setState(() {
                              marNum = newValue;
                            });
                          },
                          items: dropdownItems(marList),
                        ),
                      )),

                  ///孩子数量
                  Text.rich(
                    TextSpan(
                      text: L.of(context).$['authPerson']['hint_child'],
                      style: TextStyle(color: Color(0xFF333333), fontSize: 15),
                      // default text style
                      children: <TextSpan>[
                        TextSpan(
                            text: "*",
                            style: TextStyle(color: Color(0xFFFF0000))),
                      ],
                    ),
                  ),

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
                          value: childNum,
                          hint: new Text(
                            "请选择",
                            style: TextStyle(
                                color: Color(0xFF999999), fontSize: 15),
                          ),
                          isDense: false,
                          style:
                              TextStyle(fontSize: 15, color: Color(0xFF333333)),
                          isExpanded: true,
                          onChanged: (String newValue) {
                            setState(() {
                              childNum = newValue;
                            });
                          },
                          items: dropdownItems(childList),
                        ),
                      )),

                  ///居住类型
                  Text.rich(
                    TextSpan(
                      text: L.of(context).$['authPerson']['hint_liveType'],
                      style: TextStyle(color: Color(0xFF333333), fontSize: 15),
                      // default text style
                      children: <TextSpan>[
                        TextSpan(
                            text: "*",
                            style: TextStyle(color: Color(0xFFFF0000))),
                      ],
                    ),
                  ),

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
                          value: liveTypeNum,
                          hint: new Text(
                            "请选择",
                            style: TextStyle(
                                color: Color(0xFF999999), fontSize: 15),
                          ),
                          isDense: false,
                          style:
                              TextStyle(fontSize: 15, color: Color(0xFF333333)),
                          isExpanded: true,
                          onChanged: (String newValue) {
                            setState(() {
                              liveTypeNum = newValue;
                            });
                          },
                          items: dropdownItems(liveTypeList),
                        ),
                      )),

                  Text.rich(
                    TextSpan(
                      text: L.of(context).$['authPerson']['hint_addre'],
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

                  ///居住地详细地址
                  TextField(
                    controller: cAddress,
                    style: TextStyle(fontSize: 15, color: Color(0xff494951)),
                    decoration: InputDecoration(
                        hintText: L.of(context).$['authPerson']
                            ['hint_addreDetiels'],
                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
//            borderSide: BorderSide(color: Colors.red, width: 3.0, style: BorderStyle.solid)//没什么卵效果
                        )),
                  ),
                  SizedBox(height: 9.0),

                  ///区
                  TextField(
                    controller: cCity,
                    style: TextStyle(fontSize: 15, color: Color(0xff494951)),
                    decoration: InputDecoration(
                        hintText: L.of(context).$['authPerson']['hint_qu'],
                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
//            borderSide: BorderSide(color: Colors.red, width: 3.0, style: BorderStyle.solid)//没什么卵效果
                        )),
                  ),

                  ///摄政
                  SizedBox(height: 9.0),
                  TextField(
                    controller: cSheZheng,
                    style: TextStyle(fontSize: 15, color: Color(0xff494951)),
                    decoration: InputDecoration(
                        hintText: L.of(context).$['authPerson']['hint_shezhen'],
                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
//            borderSide: BorderSide(color: Colors.red, width: 3.0, style: BorderStyle.solid)//没什么卵效果
                        )),
                  ),

                  ///市
                  SizedBox(height: 9.0),
                  TextField(
                    controller: cBlock,
                    style: TextStyle(fontSize: 15, color: Color(0xff494951)),
                    decoration: InputDecoration(
                        hintText: L.of(context).$['authPerson']['hint_city'],
                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
//            borderSide: BorderSide(color: Colors.red, width: 3.0, style: BorderStyle.solid)//没什么卵效果
                        )),
                  ),
                  //省

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
                          value: shenNum,
                          hint: new Text(
                            L.of(context).$['authPerson']['hint_shen'],
                            style: TextStyle(
                                color: Color(0xFF999999), fontSize: 15),
                          ),
                          isDense: false,
                          style:
                              TextStyle(fontSize: 15, color: Color(0xFF333333)),
                          isExpanded: true,
                          onChanged: (String newValue) {
                            setState(() {
                              shenNum = newValue;
                            });
                          },
                          items: dropdownItems(shenList),
                        ),
                      )),
                  /**
                   * 居住时长
                   */
                  Text(
                    L.of(context).$['authPerson']['hint_liveTime'],
                    style: TextStyle(fontSize: 15, color: Color(0xff494951)),
                  ),
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
                          value: liveTimeNum,
                          hint: new Text(
                            L.of(context).$['inSelect'],
                            style: TextStyle(
                                color: Color(0xFF999999), fontSize: 15),
                          ),
                          isDense: false,
                          style:
                              TextStyle(fontSize: 15, color: Color(0xFF333333)),
                          isExpanded: true,
                          onChanged: (String newValue) {
                            setState(() {
                              liveTimeNum = newValue;
                            });
                          },
                          items: dropdownItems(liveTimeList),
                        ),
                      )),
                  /**
                   * whatsapp
                   */
                  Text.rich(
                    TextSpan(
                      text: L.of(context).$['authPerson']['hint_whatsapp'],
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

                  TextField(
                    controller: cWhatsApp,
                    style: TextStyle(fontSize: 15, color: Color(0xff494951)),
                    decoration: InputDecoration(
                        hintText: L.of(context).$['input'],
                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
//            borderSide: BorderSide(color: Colors.red, width: 3.0, style: BorderStyle.solid)//没什么卵效果
                        )),
                  ),
                  /**
                   * 邮箱
                   */
                  SizedBox(height: 9.0),

                  Text.rich(
                    TextSpan(
                      text: L.of(context).$['authPerson']['hint_emil'],
                      style: TextStyle(color: Color(0xFF333333), fontSize: 15),
                      // default text style
                      children: <TextSpan>[
                        TextSpan(
                          //  text: "*",
                            style: TextStyle(color: Color(0xFFFF0000))),
                      ],
                    ),
                  ),
                  SizedBox(height: 9.0),

                  TextField(
                    controller: cEmail,
                    style: TextStyle(fontSize: 15, color: Color(0xff494951)),
                    decoration: InputDecoration(
                        hintText: L.of(context).$['input'],
                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
//            borderSide: BorderSide(color: Colors.red, width: 3.0, style: BorderStyle.solid)//没什么卵效果
                        )),
                  ),
                  Container(
                    height: 40,
                    width: double.infinity,
                    margin: EdgeInsets.fromLTRB(20, 30, 20, 150),
                    child: RaisedButton(
                        child: Text(L.of(context).$['btn_next']),
                        color: Color(0xFF4F8AD9),
                        textColor: Color(0xFFFFFFFF),
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(42.33)),
                        onPressed: () {
                          commitData();
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
    createTime = new DateTime.now().millisecondsSinceEpoch; // 获取时间
  }

  var createTime;
  var mData;

  void getData() async {
    Map<String, dynamic> params = {};
    ResultData res = await HttpManager.getInstance().get(Api.person, params);
    if (res.isSuccess) {
      setState(() {
        this.mData = res.data['data'];
        if (mData['motherName'] == null) return;
        cMotherName.text = mData['motherName'];
        genderNum = genderList[int.parse(mData['gender'])];
        cAddress.text = mData['street'];
        cBlock.text = mData['block']; //区
        cSheZheng.text = mData['regent']; //摄政
        cCity.text = mData['city']; //市
        cWhatsApp.text = mData['whatsapp'];
        cEmail.text = mData['email'];
        eduNum = eduList[mData['educationBackground'] - 1];
        marNum = marList[mData['maritalStatus'] - 1];
        childNum = childList[mData['childNumber']];

        liveTimeNum = liveTimeList[mData['residentialDuration'] - 1];
        liveTypeNum = liveTypeList[int.parse(mData['residentialType']) - 1];
        shenNum = shenList[int.parse(mData['provinceCode']) - 1];
      });
      print(res.data);
    } else {
      ToastAlert.error(res.data['message']);
    }
  }

  TextEditingController cMotherName = new TextEditingController();
  TextEditingController cAddress = new TextEditingController();
  TextEditingController cBlock = new TextEditingController(); //区
  TextEditingController cSheZheng = new TextEditingController();
  TextEditingController cCity = new TextEditingController();
  TextEditingController cWhatsApp = new TextEditingController();
  TextEditingController cEmail = new TextEditingController();

  void commitData() async {
    String motherName = cMotherName.text.toString();
    String Address = cAddress.text.toString();
    String Block = cBlock.text.toString();
    String SheZheng = cSheZheng.text.toString();
    String City = cCity.text.toString();
    String WhatsApp = cWhatsApp.text.toString();
    String Email = cEmail.text.toString();

    if (motherName.isEmpty) {
      ToastAlert.tip(L.of(context).$['authPerson']['toast_a']);
      return;
    }
    if (genderNum == null) {
      ToastAlert.tip(L.of(context).$['authPerson']['toast_o']);
      return;
    }
    if (eduNum == null) {
      ToastAlert.tip(L.of(context).$['authPerson']['toast_b']);
      return;
    }
    if (marNum == null) {
      ToastAlert.tip(L.of(context).$['authPerson']['toast_c']);
      return;
    }
    if (childNum == null) {
      ToastAlert.tip(L.of(context).$['authPerson']['toast_d']);
      return;
    }
    if (liveTypeNum == null) {
      ToastAlert.tip(L.of(context).$['authPerson']['toast_e']);
      return;
    }
    if (Address.isEmpty) {
      ToastAlert.tip(L.of(context).$['authPerson']['toast_f']);
      return;
    }
    if (Block.isEmpty) {
      ToastAlert.tip(L.of(context).$['authPerson']['toast_g']);
      return;
    }
    if (SheZheng.isEmpty) {
      ToastAlert.tip(L.of(context).$['authPerson']['toast_h']);
      return;
    }
    if (City.isEmpty) {
      ToastAlert.tip(L.of(context).$['authPerson']['toast_i']);
      return;
    }
    if (shenNum == null) {
      ToastAlert.tip(L.of(context).$['authPerson']['toast_j']);
      return;
    }
    if (liveTimeNum == null) {
      ToastAlert.tip(L.of(context).$['authPerson']['toast_k']);
      return;
    }
    if (WhatsApp.isEmpty) {
      ToastAlert.tip(L.of(context).$['authPerson']['toast_p']);
      return;
    }

//    if (Email.isEmpty) {
//      ToastAlert.tip(L.of(context).$['authPerson']['toast_q']);
//      return;
//    }

    Map<String, dynamic> params = {
      "block": Block,
      "childNumber": childList.indexOf(childNum),
      "city": City,
      "educationBackground": eduList.indexOf(eduNum) + 1,
      "email": Email,
      "idNumber": "",
      "maritalStatus": marList.indexOf(marNum) + 1,
      "motherName": motherName,
      "province": shenList.indexOf(shenNum) + 1,
      "provinceCode": shenList.indexOf(shenNum) + 1,
      "regent": SheZheng,
      "residentialDuration": liveTimeList.indexOf(liveTimeNum) + 1,
      "residentialType": liveTypeList.indexOf(liveTypeNum) + 1,
      "street": Address,
      "usernameShort": "",
      "whatsapp": WhatsApp,
      "gender": genderList.indexOf(genderNum),
    };
    var now = new DateTime.now().millisecondsSinceEpoch;

    ResultData res = await HttpManager.getInstance().put(Api.person, params);
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

  void _saveTime(var time) async {
    print(time);
    Map<String, dynamic> params = {
      "consumeTime": time,
      "eventName": "person",
      "userId": LogsInterceptors.userId
    };
    print(LogsInterceptors.userId);
    ResultData res = await HttpManager.getInstance().post(Api.saveTime, params);
    if (res.isSuccess) {
      print(res.data);
      mData = res.data['data'];
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setInt("authPerson", 1);
      Application.router.navigateTo(context, Routes.authWork,
          replace: true, clearStack: false);
    } else {
      ToastAlert.error(res.data['message']);
    }
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
