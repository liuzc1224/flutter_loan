import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutterdemo/common/Api.dart';
import 'package:flutterdemo/common/Toast.dart';
import 'package:flutterdemo/common/address.dart';
import 'package:flutterdemo/common/http_manager.dart';
import 'package:flutterdemo/common/logs_interceptor.dart';
import 'package:flutterdemo/common/result_data.dart';
import 'package:flutterdemo/language/Localizations.dart';
import 'package:flutterdemo/routers/application.dart';
import 'package:flutterdemo/routers/routers.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthWork extends StatefulWidget {
  @override
  _AuthWorkState createState() => _AuthWorkState();
}

class _AuthWorkState extends State<AuthWork> {
  var workTypeNum, incomeNum, shenNum;
  List workTypeList = <String>[
    'eksekutif',
    'distributor',
    'akunting',
    'wiraswasta',
    'pelayan',
    'insinyur',
    'koki',
    'guru',
    'marketing',
    'pegawai pemerintahan',
    'transportasi darat',
    'pengamanan',
    'administrasi',
    'buruh',
    'transportasi',
    'arsitek',
    'tenaga medis',
    'teknologi informasi',
    'petani',
    'konsultan',
    'pekerja seni',
    'pialang',
    'nelayan',
    'ibu rumah tangga',
    'pekerja informal',
    'peternak',
    'pengacara',
    'pejabat negara',
    'desainer',
    'pensiunan',
    'pengrajin',
    'polisi',
    'peneliti',
    'transportasi',
    'militer',
    'pelajar',
    'dokter',
    'lainnya'
  ]; //从1开始

  List incomeList = <String>[
    'di bawah 2000000',
    'Antara 2000000 dan 4000000',
    'Antara 4000000 dan 8000000',
    'di atas 8000000'
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
  bool isCheck = false;
  var createTime;

  @override
  void initState() {
    super.initState();
    _getData();
    _isWorkShow();
    createTime = new DateTime.now().millisecondsSinceEpoch; // 获取时间
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(L.of(context).$['authWork']['title']),
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
                L.of(context).$['authWork']['hint_top'],
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
                   * 工作类型
                   */
                  Text.rich(
                    TextSpan(
                      text: L.of(context).$['authWork']['hint_type'],
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
                          value: workTypeNum,
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
                              workTypeNum = newValue;
                            });
                          },
                          items: dropdownItems(workTypeList),
                        ),
                      )),

                  SizedBox(height: 9.0),
                  /**
                   * 月收入
                   */
                  Text.rich(
                    TextSpan(
                      text: L.of(context).$['authWork']['hint_income'],
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
                          value: incomeNum,
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
                              incomeNum = newValue;
                            });
                          },
                          items: dropdownItems(incomeList),
                        ),
                      )),

                  /**
                   * 公司名称
                   */
                  Text.rich(
                    TextSpan(
                      text: L.of(context).$['authWork']['hint_name'],
                      style: TextStyle(color: Color(0xFF333333), fontSize: 15),
                      // default text style
                      children: <TextSpan>[
                        TextSpan(
                            text: "*",
                            style: TextStyle(color: Color(0xFFFF0000))),
                      ],
                    ),
                  ),

                  TextField(
                    controller: companyName,
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
                   * 公司地址
                   */
                  Text.rich(
                    TextSpan(
                      text: L.of(context).$['authWork']['hint_address'],
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

                  //区
                  TextField(
                    controller: cBlock,
                    style: TextStyle(fontSize: 15, color: Color(0xff494951)),
                    decoration: InputDecoration(
                        hintText: L.of(context).$['authPerson']['hint_qu'],
                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
//            borderSide: BorderSide(color: Colors.red, width: 3.0, style: BorderStyle.solid)//没什么卵效果
                        )),
                  ),
                  //摄政
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
                  //市
                  SizedBox(height: 9.0),
                  TextField(
                    controller: cCity,
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
                   * 公司电话
                   */
                  Text.rich(
                    TextSpan(
                      text: L.of(context).$['authWork']['hint_phone'],
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
                    controller: companyPhone,
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
                   * 工作证明
                   */
                  SizedBox(height: 9.0),

                  Text.rich(
                    TextSpan(
                      text: L.of(context).$['authWork']['hint_img'],
                      style: TextStyle(color: Color(0xFF333333), fontSize: 15),
                      // default text style

                      children: <TextSpan>[
                        isShow==1?
                        TextSpan(
                            text: "*",
                            style: TextStyle(color: Color(0xFFFF0000))):new TextSpan()
                      ],
                    ),
                  ),
                  SizedBox(height: 9.0),

                  GestureDetector(
                    onTap: () async {
                      var img = await ImagePicker.pickImage(
                          source: ImageSource.camera, imageQuality: 40);
                      FocusScope.of(context).requestFocus(FocusNode());
                      setState(() {
                        imgUrl = "";
                        platformLogoFile = img;

                      });
                    },
                    child: imgUrl!=null
                        ? Image.network(imgUrl,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            height: 160)
                        : platformLogoFile != null
                            ? Image.file(
                                platformLogoFile,
                                height: 160,
                                fit: BoxFit.fill,
                                width: double.infinity,
                              )
                            : Image.asset(
                                "images/ic_gzzm.png",
                                fit: BoxFit.fill,
                                width: double.infinity,
                                height: 160,
                              ),
                  ),
                  SizedBox(height: 9.0),
                  Text(
                    L.of(context).$['authWork']['hint_'],
                    style: TextStyle(fontSize: 13, color: Color(0xFF999999)),
                  ),

                  /**
                   * 下一步按钮
                   */
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
                          _commitData();
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

  File platformLogoFile;
  var mData;
  TextEditingController cAddress = new TextEditingController();
  TextEditingController cBlock = new TextEditingController(); //区
  TextEditingController cSheZheng = new TextEditingController();
  TextEditingController cCity = new TextEditingController();
  TextEditingController companyName = new TextEditingController();
  TextEditingController companyPhone = new TextEditingController();

  void _commitData() async {
    String mName = companyName.text.toString();
    String mPhone = companyPhone.text.toString();
    String Address = cAddress.text.toString();
    String Block = cBlock.text.toString();
    String SheZheng = cSheZheng.text.toString();
    String City = cCity.text.toString();
    if (workTypeNum == null) {
      ToastAlert.tip(L.of(context).$['authWork']['toast_a']);
      return;
    }

    if (incomeNum == null) {
      ToastAlert.tip(L.of(context).$['authWork']['toast_b']);
      return;
    }
    if (mName.isEmpty) {
      ToastAlert.tip(L.of(context).$['authWork']['toast_c']);
      return;
    }

    if (Address.isEmpty) {
      ToastAlert.tip(L.of(context).$['authPerson']['toast_d']);
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
    if (mPhone.isEmpty) {
      ToastAlert.tip(L.of(context).$['authWork']['toast_e']);
      return;
    }
    if(isShow==1){
      if (platformLogoFile == null&&imgUrl==null) {
        ToastAlert.tip(L.of(context).$['authWork']['toast_f']);
        return;
      }
    }

    FormData _param = FormData.fromMap({
      "companyName": mName,
      "province": shenList.indexOf(shenNum) + 1,
      "provinceCode": shenList.indexOf(shenNum) + 1,
      "city": City,
      "regent": SheZheng,
      "block": Block,
      "street": Address,
      "telphone": mPhone,
      "socialIdentityCode": workTypeList.indexOf(workTypeNum) + 1,
      "monthlyIncome": incomeList.indexOf(incomeNum) + 1,
      "incomeProof": platformLogoFile != null
          ? await MultipartFile.fromFile(platformLogoFile.path)
          : null
    });
    var now = new DateTime.now().millisecondsSinceEpoch;

    ResultData res =
        await HttpManager.getInstance().formData(Api.workInfo, _param);
    if (res.isSuccess) {
      setState(() {
        _saveTime((now - createTime) / 1000);
      });
    } else {
      ToastAlert.error(res.data['message']);
    }
    print(res.data);
  }

  String imgUrl = "";
  bool isHave;

  void _getData() async {
    Map<String, dynamic> params = {};
    ResultData res = await HttpManager.getInstance().get(Api.workInfo, params);
    if (res.isSuccess) {
      setState(() {
        this.mData = res.data['data'];
        if (mData == null || mData['companyName'] == null) {
          return;
        }

        if (mData['socialIdentityCode'] > 0) {
          workTypeNum = workTypeList[mData['socialIdentityCode'] - 1];
        }
        if (mData['monthlyIncome'] > 0) {
          incomeNum = incomeList[mData['monthlyIncome'] - 1];
        }
        companyName.text = mData['companyName'];
        cAddress.text = mData['street'];
        cBlock.text = mData['block']; //区
        cSheZheng.text = mData['regent']; //摄政
        cCity.text = mData['city']; //市
        shenNum = shenList[mData['provinceCode'] - 1]; //省
        companyPhone.text = mData['telphone'];
        if (mData['incomeProof'].toString()!=null) {
          imgUrl = mData['incomeProof'];
          isHave = true;
        }
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
      "eventName": "work",
      "userId": LogsInterceptors.userId
    };
    print(LogsInterceptors.userId);
    ResultData res = await HttpManager.getInstance().post(Api.saveTime, params);
    if (res.isSuccess) {
      print(res.data);
    //  mData = res.data['data'];
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setInt("authWork", 1);
      Application.router.navigateTo(context, Routes.authContact,
          replace: true, clearStack: false);
    } else {
      ToastAlert.error(res.data['message']);
    }
  }
  int isShow=1;
  //判断工作证明是否必填
  void _isWorkShow() async {
    Map<String, dynamic> params = {

    };
    print(LogsInterceptors.userId);
    ResultData res = await HttpManager.getInstance().get(Api.workImageShow, params);
    if (res.isSuccess) {
      print(res.data);
    List  mData = res.data['data'];
   for(int i=0;i<mData.length;i++){
     if(mData[i]['businessId']==1){//判断是否工作证明必填
       isShow=mData[i]['status'];
     }
   }
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
