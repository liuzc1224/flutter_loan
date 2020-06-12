import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secured_storage/flutter_secured_storage.dart';
import 'package:flutterdemo/common/Api.dart';
import 'package:flutterdemo/common/Toast.dart';
import 'package:flutterdemo/common/http_manager.dart';
import 'package:flutterdemo/common/logs_interceptor.dart';
import 'package:flutterdemo/common/result_data.dart';
import 'package:flutterdemo/common/to_h5_page.dart';
import 'package:flutterdemo/language/Localizations.dart';
import 'package:flutter/services.dart';
import 'package:flutterdemo/routers/application.dart';
import 'package:flutterdemo/routers/routers.dart';
import 'package:flutterplugin3/flutterplugin3.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
class _SecItem {
  _SecItem(this.key, this.value);

  final String key;
  final String value;
}
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}
class _LoginPageState extends State<LoginPage> {
  Timer _timer;
  int _countdownTime = 0;
  bool codeState=true;
  bool phoneOK=true;
  bool sendState=true;
  String smsCode;
  TextEditingController account=new TextEditingController();
  TextEditingController code=new TextEditingController();
  FocusNode codeNode = FocusNode();

  @override
  void dispose(){
    super.dispose();
    account.dispose();
    codeNode.dispose();
    code.dispose();
    if (_timer != null) {
      _timer.cancel();
    }
  }
  @override
  void initState() {
    super.initState();

   // eventChannel.receiveBroadcastStream().listen(_getData, onError: _getError);

    _readAll();
  }
  final _storage = FlutterSecuredStorage();
  List<_SecItem> _items = [];
  Future<Null> _readAll() async {
    final all = await _storage.readAll();
    setState(() {
      var arr =all.keys
          .map((key) => _SecItem(key, all[key]))
          .toList(growable: false);
      if(arr.length==0){
        _addNewItem();
      }else{
        print(arr[0].value);
        print(arr[0].key);
        return _items = all.keys
            .map((key) => _SecItem(key, all[key]))
            .toList(growable: false);
      }
    });
  }
  void _addNewItem() async {
    final String key = _randomValue();
    final String value = _randomValue();

    await _storage.write(key: key, value: value);
    _readAll();
  }
  String _randomValue() {
    final rand = Random();
    final codeUnits = List.generate(20, (index) {
      return rand.nextInt(26) + 65;
    });

    return String.fromCharCodes(codeUnits);
  }
  //倒计时
  void startCountdownTimer() {
    const oneSec = const Duration(seconds: 1);

    var callback = (timer) => {
      setState(() {
        if (_countdownTime < 1) {
          this.sendState=true;
          _timer.cancel();
        } else {
          _countdownTime = _countdownTime - 1;
        }
      })
    };
    _timer = Timer.periodic(oneSec, callback);
  }
  //登录
  void goLogin(phone)async{
//    await openLocation();
    Map<String, dynamic> params={
      "phoneNumber":phone,
      "areaCode":"62"
    };
    ResultData res=await HttpManager.getInstance().get(Api.user_check, params);
    print(res.data);
    if (res.isSuccess) {
      if(res.data['data']==null){
        if(this.codeState==false){
          var codeNum=code.text.toString();
          if(codeNum.length<4){
            setState(() {
              this.phoneOK=true;
            });
            ToastAlert.error(L.of(context).$['login']['codeError']);
          }else{
            Map<String, dynamic> paramsCode={
              "phoneNumber":phone,
              "areaCode":"62",
              "verificationCode":codeNum,
              "verificationType":1
            };
            ResultData resCode=await HttpManager.getInstance().get(Api.check_code, paramsCode);
              if (resCode.isSuccess) {
                setState(() {
                  this.phoneOK=true;
                });
                Application.router.navigateTo(
                    context,
                    '${Routes.settingPwd}?phoneNumber=$phone&verificationCode=$codeNum',
                    transition: TransitionType.inFromRight//过场效果
                );
              }else{
                setState(() {
                  this.phoneOK=true;
                });
                ToastAlert.error(resCode.data['message']);
              }
          }
        }else{
          setState(() {
            this.phoneOK=true;
            this.codeState=false;
            FocusScope.of(context).requestFocus(codeNode);
          });
        }

      }
    }else{
      if(res.data['code']==7){
        setState(() {
          this.phoneOK=true;
        });
        Application.router.navigateTo(context,  '${Routes.passWord}?phoneNumber=$phone');
      }
      setState(() {
        this.phoneOK=true;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      body: ListView(
        children: <Widget>[
          Container(
            child: new Column(
                children: <Widget>[
                  Container(
                    width:double.infinity,
                    height: 352.67,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("images/bg.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Container(
                      margin: EdgeInsets.only(top: 64.33),
                      child: Image.asset("images/logo.png",width: 88.33,),
                    ),
                    alignment: Alignment.topCenter,
                  ),
                  Container(
                    margin: EdgeInsets.only(top:10.33),
                    padding: EdgeInsets.symmetric(vertical: 0,horizontal: 53),
                    child: Column(
                      crossAxisAlignment : CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          L.of(context).$['login']['phone'],
                          style: TextStyle(color: Color(0xFF494951),fontSize: 13.33),
                          textAlign: TextAlign.start,
                        ),
                        Container(
                          margin: EdgeInsets.only(top:5.67,bottom: 10.47),
                          height: 42.2,
                          child: TextField(
                              controller: account,
                              style:TextStyle(color: Color(0xFF5999F6),fontSize: 13.33),
                              decoration:InputDecoration(
                                border: new OutlineInputBorder(  //添加边框
                                    borderRadius: BorderRadius.circular(6.0),
                                    borderSide: BorderSide.none
                                ),
                                contentPadding: const EdgeInsets.symmetric(vertical:0,horizontal:10),
                                prefixIcon: Image.asset("images/person.png",height: 16.67,), //输入框左边图标
                                prefixText:"+62 ",
                                prefixStyle:TextStyle(color: Color(0xFF494951)),
                                hintText:L.of(context).$['login']['prompt'],
                                hintStyle: TextStyle(color: Color(0xFFC5C5C5)),
                                filled: true,
                                fillColor: Color(0xFFF5F5F5),
                              ),
                              inputFormatters: [
                                WhitelistingTextInputFormatter(RegExp("[0-9]")),
                                LengthLimitingTextInputFormatter(13)
                              ],
                          ),
                        ),
                        Offstage(
                          offstage:codeState,
                          child: Column(
                            crossAxisAlignment : CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                L.of(context).$['login']['code'],
                                style: TextStyle(color: Color(0xFF494951),fontSize: 13.33),
                                textAlign: TextAlign.start,
                              ),
                              Container(
                                height: 42.2,
                                margin: EdgeInsets.only(top:5.67),
                                child: TextField(
                                  controller: code,
                                  focusNode: codeNode,
                                  style:TextStyle(color: Color(0xFF5999F6),fontSize: 13.33),
                                  decoration:InputDecoration(
                                    border: new OutlineInputBorder(  //添加边框
                                        borderRadius: BorderRadius.circular(6.0),
                                        borderSide: BorderSide.none
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(vertical:0,horizontal:10),
                                    hintText:L.of(context).$['login']['codeTip'],
                                    prefixIcon: Image.asset("images/pwd.png",height: 16.67,), //输入框左边图标
                                    hintStyle: TextStyle(color: Color(0xFFC5C5C5)),
                                    suffix:GestureDetector(//在最外层包裹InkWell组件
                                      onTap: ()async{
                                        if(sendState){
                                          setState(() {
                                            this.sendState=false;
                                          });
                                          if (_countdownTime == 0) {
                                            //Http请求发送验证码
                                            setState(() {
                                              _countdownTime = 60;
                                            });
                                            //开始倒计时
                                            startCountdownTimer();
                                          }
                                          Map<String, dynamic> params={
                                            "areaCode":"62",
                                            "phoneNumber":this.account.text.toString(),
                                            "verificationType":1
                                          };
                                          ResultData res=await HttpManager.getInstance().get(Api.send_verification_code, params);
                                          print(res.data);
                                          if (!res.isSuccess) {
                                            ToastAlert.error(res.data['message']);
                                          }
                                        }
                                      },
                                      child: Text( _countdownTime > 0 ? '${_countdownTime}s' : L.of(context).$['login']['sendCode'], style: TextStyle(fontSize: 12,color: Color(0xFF5999F6))),
                                    ),
                                    filled: true,
                                    fillColor: Color(0xFFF5F5F5),
                                  ),
                                  inputFormatters: [
                                    WhitelistingTextInputFormatter(RegExp("[0-9]")),
                                    LengthLimitingTextInputFormatter(4)
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                                child: Container(
                                  height: 42.33,
                                  margin: EdgeInsets.only(top: 24.8),
                                  child: RaisedButton(
                                      child: Text(L.of(context).$['login']['login']),
                                      color: Color(0xFF4F8AD9),
                                      textColor: Color(0xFFFFFFFF),
                                      elevation: 10,
                                      disabledTextColor:Colors.white,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(42.33)
                                      ),
                                      onPressed: phoneOK ? ()async{
                                 //       var yiTuFace = await Flutterplugin3.yiTuFace;
                                        var phone=account.text.toString();
                                        if(phone.length>0){
                                          if(RegExp("[0-9]{9,13}").hasMatch(phone)){
                                            setState(() {
                                              this.phoneOK=false;
                                            });
                                          }else{
                                            setState(() {
                                              this.phoneOK=true;
                                            });
                                          }
                                        }
                                        if(!this.phoneOK){
                                          this.goLogin(phone);
                                        }
//                                Application.router.navigateTo(context,  Routes.passWord);
                                      } : null
                                  ),
                                )
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: !codeState ? 15.5 : MediaQuery.of(context).size.height-555.31),
                  Container(
                    alignment: Alignment.bottomCenter,
                    child: GestureDetector(
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ToH5Page(url:H5.privacyAgreement),
                          ),
                        );
                      },
                      child: Text.rich(
                        TextSpan(
                          text: L.of(context).$['login']['tip'],
                          style: TextStyle(color: Color(0xFF333333),fontSize: 10.67),// default text style
                          children: <TextSpan>[
                            TextSpan(text: L.of(context).$['login']['text'],style: TextStyle(color: Color(0xFF5999F6))),
                          ],
                        ),
                      ),
                    )
                  ),
                ]
            ),
          ),
        ],
      )
    );
  }

  //打开定位
  void openLocation() async {
    Location location = new Location();
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      setState(() {
        this.phoneOK=true;
      });
      return;
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      setState(() {
        this.phoneOK=true;
      });
      return;
    }

    _locationData = await location.getLocation();
    print(_locationData);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("locationData", jsonEncode(_locationData));
//    print( _locationData.latitude);
//    print( _locationData.longitude);
//    if(_locationData.latitude!=null){
//      LogsInterceptors.latitude=_locationData.latitude;
//    }
//    if(_locationData.longitude!=null){
//      LogsInterceptors.longitude=_locationData.longitude;
//    }
  }
}