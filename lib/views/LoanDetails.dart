import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:wasm';

import 'package:device_info/device_info.dart';
import 'package:easy_contact_picker/easy_contact_picker.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterdemo/common/Api.dart';
import 'package:flutterdemo/common/Toast.dart';
import 'package:flutterdemo/common/address.dart';
import 'package:flutterdemo/common/http_manager.dart';
import 'package:flutterdemo/common/logs_interceptor.dart';
import 'package:flutterdemo/common/result_data.dart';
import 'package:flutterdemo/common/to_h5_page.dart';
import 'package:flutterdemo/language/Localizations.dart';
import 'package:flutterdemo/routers/application.dart';
import 'package:flutterdemo/routers/routers.dart';
import 'package:flutterdemo/views/TransitPage.dart';
import 'package:flutterplugin3/flutterplugin3.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

class LoanDetails extends StatefulWidget {
  final productId;
  final isFail;

  const LoanDetails({Key key, this.productId, this.isFail}) : super(key: key);

  @override
  _LoanDetailsState createState() => _LoanDetailsState();
}

class _LoanDetailsState extends State<LoanDetails> with WidgetsBindingObserver {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          L.of(context).$['LoanDetails']['title'],
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
          color: Color(0xffEEEEEE),
          child: ListView(
            children: <Widget>[
              Container(
                color: Colors.white,
                padding:
                    EdgeInsets.only(left: 15, right: 15, bottom: 5, top: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Column(
                            children: <Widget>[
                              Container(
                                alignment: Alignment.center,
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: loanAmount,
                                    hint: new Text(
                                      loanAmount.toString(),
                                      style: TextStyle(
                                          color: Color(0xFF999999),
                                          fontSize: 15),
                                    ),
                                    isDense: true,
                                    style: TextStyle(
                                        fontSize: 15, color: Color(0xFF333333)),
                                    isExpanded: false,
                                    onChanged: (String v) {
                                      setState(() {
                                        loanAmount = v;

                                        getRepayInfo();
                                      });
                                    },
                                    items: dropdownItems(amountList),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                L.of(context).$['mainHome']['anount'],
                                style: TextStyle(
                                    fontSize: 13, color: Color(0xff999999)),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              /* Text(
                                loanTime.toString(),
                                style: TextStyle(
                                    fontSize: 20, color: Color(0xff494951)),
                              ),*/
                              Container(
                                alignment: Alignment.center,
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: loanTime,
                                    hint: new Text(
                                      loanTime.toString(),
                                      style: TextStyle(
                                          color: Color(0xFF999999),
                                          fontSize: 15),
                                    ),
                                    isDense: true,
                                    style: TextStyle(
                                        fontSize: 15, color: Color(0xFF333333)),
                                    isExpanded: false,
                                    onChanged: (String newValue) {
                                      setState(() {
                                        loanTime = newValue;

                                        getRepayInfo();
                                      });
                                    },
                                    items: dropdownItems(timeList),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                L.of(context).$['mainHome']['time'],
                                style: TextStyle(
                                    fontSize: 13, color: Color(0xff999999)),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                        L.of(context).$['LoanDetails']['repayType'] +
                            repayTypeStr,
                        style:
                            TextStyle(fontSize: 13, color: Color(0xff999999))),
                  ],
                ),
              ),

              ///第二部分
              Container(
                margin: EdgeInsets.only(top: 15),
                color: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: <Widget>[
                    Container(
                      height: 42,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: Text(
                                L.of(context).$['LoanDetails']['info_a'],
                                style: TextStyle(
                                    fontSize: 15, color: Color(0xff999999))),
                          ),
                          Text(amountStr(dayRate) + "%",
                              style: TextStyle(
                                  fontSize: 15, color: Color(0xff494951))),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 0.5,
                      child: Container(color: Color(0xffeeeeee)),
                    ),
                    Container(
                      height: 42,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: Text(
                                L.of(context).$['LoanDetails']['info_b'],
                                style: TextStyle(
                                    fontSize: 15, color: Color(0xff999999))),
                          ),
                          Text(amountStr(shFee) + "%",
                              style: TextStyle(
                                  fontSize: 15, color: Color(0xff494951))),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 0.5,
                      child: Container(color: Color(0xffeeeeee)),
                    ),
                    Container(
                      height: 42,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: Text(
                                L.of(context).$['LoanDetails']['info_c'],
                                style: TextStyle(
                                    fontSize: 15, color: Color(0xff999999))),
                          ),
                          Text(amountStr(jsFee) + "%",
                              style: TextStyle(
                                  fontSize: 15, color: Color(0xff494951))),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 0.5,
                      child: Container(color: Color(0xffeeeeee)),
                    ),
                  ],
                ),
              ),

              ///第三部分
              Container(
                margin: EdgeInsets.only(top: 15),
                color: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: <Widget>[
                    Container(
                      height: 42,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: Text(
                                L.of(context).$['LoanDetails']['info_d'],
                                style: TextStyle(
                                    fontSize: 15, color: Color(0xff999999))),
                          ),
                          Text(amountStr(fkAmount),
                              style: TextStyle(
                                  fontSize: 15, color: Color(0xff494951))),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 0.5,
                      child: Container(color: Color(0xffeeeeee)),
                    ),
                    Container(
                      height: 42,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: Text(
                                L.of(context).$['LoanDetails']['info_e'],
                                style: TextStyle(
                                    fontSize: 15, color: Color(0xff999999))),
                          ),
                          Text(amountStr(repayAmount),
                              style: TextStyle(
                                  fontSize: 15, color: Color(0xff494951))),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 0.5,
                      child: Container(color: Color(0xffeeeeee)),
                    ),
                    Container(
                      height: 42,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: Text(
                                L.of(context).$['LoanDetails']['info_f'],
                                style: TextStyle(
                                    fontSize: 15, color: Color(0xff999999))),
                          ),
                          Container(
                            width: 120,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ToH5Page(
                                            url: H5.selectCoupon +
                                                "?id=" +
                                                couponId.toString(),
                                          )),
                                ).then((onValue) {
                                  print("----" + onValue);
                                  setState(() {
                                    var data = json.decode(onValue);
                                    if (data != null) {
                                      couponId = data['id'];
                                      getRepayInfo();
                                    }
                                  });
                                });
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Text(
                                    coupon,
                                    style: TextStyle(
                                        fontSize: 15, color: Color(0xff4F8AD9)),
                                  ),
                                  Icon(
                                    Icons.keyboard_arrow_right,
                                    size: 24,
                                    color: Color(0xff999999),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 0.5,
                      child: Container(color: Color(0xffeeeeee)),
                    ),

                    ///实际还款金额
                    Container(
                      height: 42,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: Text(
                                L.of(context).$['LoanDetails']['info_g'],
                                style: TextStyle(
                                    fontSize: 15, color: Color(0xff999999))),
                          ),
                          Row(
                            children: <Widget>[
                              Text(amountStr(payAmount),
                                  style: TextStyle(
                                      fontSize: 15, color: Color(0xff494951))),
                              showDetailsStr == true
                                  ? GestureDetector(
                                      onTap: () {},
                                      child: Text(
                                          L.of(context).$['LoanDetails']
                                              ['details'],
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Color(0xff4F8AD9))),
                                    )
                                  : Container()
                            ],
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 0.5,
                      child: Container(color: Color(0xffeeeeee)),
                    ),

                    ///取款账户
                    Container(
                      height: 42,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: Text(
                                L.of(context).$['LoanDetails']['info_h'],
                                style: TextStyle(
                                    fontSize: 15, color: Color(0xff999999))),
                          ),
                          Container(
                            width: 120,
                            child: GestureDetector(
                              onTap: () {
                                //选择银行卡
                                Application.router
                                    .navigateTo(context, Routes.accountSelect)
                                    .then((onValue) {
                                  if (onValue != null) {
                                    setState(() {
                                      bankId = onValue['id'];
                                      bankBean = onValue;
                                      String text = onValue['bankCardNum'];
                                      userName = onValue['userName'];
                                      bankNumber = "...." +
                                          text
                                              .toString()
                                              .substring(text.length - 4);
                                    });
                                  }
                                });
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Text(
                                    bankNumber,
                                    style: TextStyle(
                                        fontSize: 15, color: Color(0xff4F8AD9)),
                                  ),
                                  Icon(
                                    Icons.keyboard_arrow_right,
                                    size: 24,
                                    color: Color(0xff999999),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 0.5,
                      child: Container(color: Color(0xffeeeeee)),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        new Checkbox(
                          value: this.check,
                          activeColor: Colors.blue,
                          onChanged: (bool val) {
                            // val 是布尔值
                            this.setState(() {
                              this.check = !this.check;
                            });
                          },
                        ),
                        Text(L.of(context).$['LoanDetails']['protocol_a'],
                            style: TextStyle(
                                fontSize: 13, color: Color(0xff999999))),
                        GestureDetector(
                          onTap: () {
                            //借款合同
                            _openArgee();
                          },
                          child: Text(
                              L.of(context).$['LoanDetails']['protocol_b'],
                              style: TextStyle(
                                  fontSize: 13, color: Color(0xff4F8AD9))),
                        )
                      ],
                    )
                  ],
                ),
              ),

              Container(
                height: 40,
                width: double.infinity,
                margin: EdgeInsets.fromLTRB(20, 30, 20, 40),
                child: RaisedButton(
                    child: Text(L.of(context).$['LoanDetails']['btn_commit']),
                    color: Color(0xFF4F8AD9),
                    textColor: Color(0xFFFFFFFF),
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(42.33)),
                    onPressed: () {
                      print(bankId);
                      if (bankId == 0) {
                        ToastAlert.tip(
                            L.of(context).$['LoanDetails']['toast_bank']);
                        return;
                      }
                      if (!check) {
                        ToastAlert.tip(
                            L.of(context).$['LoanDetails']['toast_argee']);
                        return;
                      }
                      openLocation();
                      //  commitOrder();
                    }),
              )
            ],
          )),
    );
  }

  var check = false;
  var userName = "";
  var istrue = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // _getStatus();
    if (widget.isFail.toString().endsWith("1")) {
      //正常借款
      _getInfo();
    } else {
      //失败后重新借款

    }
  }

  void _getStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("----1111111" + prefs.getBool("isStatus").toString());

    if (prefs.getBool("isStatus") == false ||
        prefs.getBool("isStatus") == null) {
      prefs.setBool("isStatus", true);
    }
  }

  @override
  void dispose() {
    super.dispose();

    WidgetsBinding.instance.removeObserver(this);
  }

  var loanAmount = "", loanTime = ""; //借款金额、借款时间
  var dayRate = "", shFee = "", jsFee = ""; //日利率
  var fkAmount = "",
      repayAmount = "",
      coupon = "",
      payAmount = "",
      bankNumber = "";
  int couponId = 0;
  List amountList = <String>[];
  List timeList = <String>[];
  List typeList = <String>[
    'Pembayaran sekali dari dari biaya layanan pokok- pascabayar',
    'Pembayaran sekali dari biaya layanan pokok dan bunga',
    'Biaya layanan cicilan-pascabayar',
    'Biaya layanan pemotongan-cicilan'
  ];
  var day;
  bool showDetailsStr = false;
  var repayTypeStr = "";
  int repayType = 0;
  var bankBean;
  var productInfoBean;
  var repayInfoBean;

//{"userContactInputVOS":[{"contactGrade":1,"contactName":"5655","contactPhone":"13433323333","relation":1},{"contactGrade":2,"contactName":"11111","contactPhone":"13333333333","relation":2},{"contactGrade":3,"contactName":"ddd","contactPhone":"142424242424242","relation":6}]}
  ///获取产品信息
  void _getInfo() async {
    Map<String, dynamic> params = {};
    ResultData res = await HttpManager.getInstance()
        .get(Api.loanProductInfo + widget.productId, params);

    if (res.isSuccess) {
      setState(() {
        var bean = res.data['data'];
        productInfoBean = res.data['data'];
        loanAmount = bean['loanQuotaMix'].toString();
        loanTime = (bean['loanTermMix'] * bean['period']).toString();
        dayRate = (bean['loanDayRate'] * 100).toString();
        shFee = (bean['auditRate'] * 100).toString();
        jsFee = (bean['technologyRate'] * 100).toString();
        //还款方式
        repayType = bean['loanProductType'];
        repayTypeStr = typeList[repayType - 1];

        if (repayType == 1 || repayType == 2) {
          showDetailsStr = false;
        } else {
          //展示明细按钮文字
          showDetailsStr = true;
        }
        if (bankNumber.isEmpty) {
          bankNumber = L.of(context).$['LoanDetails']['noset'];
        }
        //时间和金额的选择填充
        timeList = <String>[];
        amountList = <String>[];
        day = bean['loanTermMix'];
        while (day <= bean['loanTermMax']) {
          timeList.add((day * bean['period']).toString());
          day += bean['loanTermIncrease'];
        }
        var min = bean['loanQuotaMix'];
        if (min < bean['loanQuotaMax']) {
          while (min <= bean['loanQuotaMax']) {
            amountList.add(min.toString());
            min += bean['loanQuotaIncrease'];
          }
        }

        getRepayInfo();
      });
      print(res.data);
    } else {
      ToastAlert.error(res.data['message']);
    }
  }

  void getRepayInfo() async {
    Map<String, dynamic> params = {
      "loanProductId": widget.productId,
      "amount": loanAmount,
      "days": loanTime,
    };
    if (couponId != 0) {
      params['couponId'] = couponId;
    }
    ResultData res = await HttpManager.getInstance().get(Api.repayInfo, params);

    if (res.isSuccess) {
      setState(() {
        var bean = res.data['data'];
        repayInfoBean = res.data['data'];
        fkAmount = bean['payMoney'].toString();
        repayAmount = bean['repayAmount'].toString();
        payAmount = bean['realRepayAmount'].toString();
        if (bean['freeAmount'] > 0) {
          coupon = "-" + bean['freeAmount'].toString();
        } else {
          coupon = "无";
        }
      });
      print(res.data);
    } else {
      ToastAlert.error(res.data['message']);
    }
  }

  var bankId = 0;

  //打开定位
  void openLocation() async {
    Location location = new Location();
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
    print(_locationData);
    if(_locationData.latitude!=null){
      LogsInterceptors.latitude=_locationData.latitude;
    }
    if(_locationData.longitude!=null){
      LogsInterceptors.longitude=_locationData.longitude;
    }
    _openFace();
  }

  //打开活体
  void _openFace() async {
    Map<String, dynamic> params = {};
    ResultData res =
        await HttpManager.getInstance().get(Api.openFaceType, params);
    if (res.isSuccess) {
      var mData = res.data['data'];
      if (mData != null && mData['livingActivate'] == true) {
        if (mData['livingType'] == 1) {
          print("打开活体");

          //打开advance
          try {
            var platformVersion = await Flutterplugin3.platformVersion;
            if (platformVersion != null) {
              _commitAdvance(platformVersion);
            }
          } on PlatformException {
            // platformVersion = 'Failed to get platform version.';
          }
        } else {
          //打开依图
                 var yiTuFace = await Flutterplugin3.yiTuFace;
if(yiTuFace!=null){
  _commitYitu(yiTuFace);
}
        }
      } else {
        //跳过活体
        _saveContact();
      }
      print(res.data);
    } else {
      ToastAlert.error(res.data['message']);
    }
  }

  void _commitAdvance(String data) async {
    String livenessId = "";
    String base64 = "";
    if (data != null) {
      livenessId = data.split(',')[0];
      base64 = data.split(',')[1];
    }
    Map<String, dynamic> params = {
      "adKey": Address.ADVANCE_ACCESS_KEY,
      "jsonData": "",
      "livenessId": livenessId,
      "livenessScore": "",
      "photoBase64": "data:image/jpeg;base64," + base64,
    };
    ResultData res =
        await HttpManager.getInstance().post(Api.commitAdvance, params);
    print(res.data);

    if (res.isSuccess) {
      setState(() {
        print("----活体信息上传成功--");
        _saveContact();
      });
    } else {
      ToastAlert.error(res.data['message']);
    }
  }

  void _commitYitu(String data) async {
    if (data == null) {
      return;
    }
    Map<String, dynamic> params = {
      "queryImagePackage": data,

    };
    ResultData res =
    await HttpManager.getInstance().post(Api.commitYitu, params);
    print(res.data);

    if (res.isSuccess) {
      setState(() {
        print("----活体信息上传成功--");
        _saveContact();
      });
    } else {
      ToastAlert.error(res.data['message']);
    }
  }


  final EasyContactPicker _contactPicker = new EasyContactPicker();

  void _saveContact() async {
    List bean = [];
    List<Contact> list = await _contactPicker.selectContacts();
    setState(() async {
      for (var i = 0; i < list.length; i++) {
        Map<String, dynamic> params11 = {
          "contactName": list[i].fullName,
          "contactPhone": list[i].phoneNumber,
        };
        bean.add(params11);
        print(list[i].phoneNumber.toString());
      }

      Map<String, dynamic> params = {"userContactInputVOS": bean};
      var now = new DateTime.now().millisecondsSinceEpoch;
      ResultData res =
          await HttpManager.getInstance().post(Api.contactInfo, params);
      if (res.isSuccess) {
        setState(() {
          print("----contact success--");
          // this.mData = res.data['data'];
          commitOrder();
        });
        print(res.data);
      } else {
        ToastAlert.error(res.data['message']);
      }
    });
  }

  //提交订单
  void commitOrder() async {
    var virtual;
    DeviceInfoPlugin deviceInfo = new DeviceInfoPlugin();
    if(Platform.isIOS){
      print('IOS设备：');
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      virtual=iosInfo.isPhysicalDevice;
    }else if(Platform.isAndroid){
      print('Android设备');
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      virtual=androidInfo.isPhysicalDevice;
    }
    Map<String, dynamic> params = {
      "bankAccountId": bankId,
      //  "amount": loanAmount,

      "createTime": "",
      "id": "0",
      "loanDays": loanTime,
      "loanMoney": loanAmount,
      "loanProductId": widget.productId,
      "loanPurpose": "",
      "modifyTime": "",
      "userPhone": "0123123123",
      "loanProductType": repayType,
      //设备信息
      "ram": "100",
      "rom": "100",
      "resolution": "100*100",
      "virtual": virtual,
      "imei": "100",
      "advertisingId": "100",
      "androidId": "100",
    };
    if (couponId != 0) {
      params['couponId'] = couponId;
    }

    ResultData res =
        await HttpManager.getInstance().post(Api.commitOrder, params);
    if (res.isSuccess) {
      ToastAlert.tip("提交成功");
      Application.router
          .navigateTo(context, Routes.home, replace: true, clearStack: true);

      print(res.data);
    } else {
      ToastAlert.error(res.data['message']);
    }
  }

  ///借款合同
  void _openArgee() async {
    Map<String, dynamic> params = {};
    ResultData res = await HttpManager.getInstance().get(Api.person, params);
    if (res.isSuccess) {
      var bean = res.data['data'];
      print(bean);

      Map<String, dynamic> map = {
        "userName": userName,
        "phoneNumber": bean['phoneNumber'],
        "idNo": bean['idNumber'],
        "bankNumber": bankNumber,
        "orderNo": "",
        "loanMoney": loanAmount,
        "loanDays": loanTime,
        "payMoney": fkAmount,
        "repayMoney": repayAmount,
        "realRepayMoney": payAmount,
        "repaymentMoneyTotal": repayAmount,
      };
      if (bankBean != null) {
        map['bankName'] = bankBean['bankName'];
      }
      if (couponId == 0) {
        map['couponMoney'] = 0;
      } else {
        map['couponMoney'] = repayInfoBean['freeAmount'];
      }
      if(productInfoBean!=null){
        map['gracePeriod'] = productInfoBean['gracePeriod'];
        map['graceDayRate'] = productInfoBean['gracePeriodDayRate'];
        map['overdueDayRate'] = productInfoBean['overdueDayRate'];
      }else{

      }

  //    ToH5PageState().loanInfo = map;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ToH5Page(
            url: H5.loanContract,
            data: map,
          ),
        ),
      );
    }
  }

  static const methodChannel = const MethodChannel('wg/native_get');

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);

    if (state != AppLifecycleState.resumed) {
      //  eventChannel.invokeMethod('changeNavStatus', 'didChangeAppLifecycleState:${state}-show');
    } else {
      //   _getInfo();
      // eventChannel.invokeMethod('changeNavStatus', 'didChangeAppLifecycleState:$state-hiden');
    }
  }
}

String amountStr(String str) {
  return str;
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
