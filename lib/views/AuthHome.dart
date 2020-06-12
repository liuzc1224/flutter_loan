import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterdemo/common/Toast.dart';
import 'package:flutterdemo/language/Localizations.dart';
import 'package:flutterdemo/routers/application.dart';
import 'package:flutterdemo/routers/routers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthHome extends StatefulWidget {
  final productId;

  const AuthHome({Key key, this.productId}) : super(key: key);

  @override
  _AuthHomeState createState() => _AuthHomeState();
}

class _AuthHomeState extends State<AuthHome>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: Text("完善个人信息"),
        ),
        body: Container(
            child: Column(
          children: <Widget>[
            Image.asset(
              "images/img_auth_banner.png",
              fit: BoxFit.cover,
              width: double.infinity,
              height: 108,
            ),
            GestureDetector(
              onTap: () {
                print("dianji");
                Application.router.navigateTo(context, Routes.authIdentity,
                    replace: false, clearStack: false);
              },
              child: Container(
                width: double.infinity,
                height: 58,
                margin: EdgeInsets.fromLTRB(15, 15, 15, 5),
                decoration: BoxDecoration(
                    image: new DecorationImage(
                        image: new AssetImage("images/img_auth1.png"),
                        fit: BoxFit.fill)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(L.of(context).$['authHome']['type1'],
                        style:
                            TextStyle(color: Color(0xff494951), fontSize: 14)),
                    Text(
                      identity == 0
                          ? L.of(context).$['authHome']['status1']
                          : identity == 1
                              ? L.of(context).$['authHome']['status2']
                              : L.of(context).$['authHome']['status3'],
                      style: TextStyle(color: Color(0xff5390E4), fontSize: 12),
                    )
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Application.router.navigateTo(context, Routes.authPerson,
                    replace: false, clearStack: false);
              },
              child: Container(
                width: double.infinity,
                height: 58,
                margin: EdgeInsets.fromLTRB(15, 15, 15, 5),
                decoration: BoxDecoration(
                    image: new DecorationImage(
                        image: new AssetImage("images/img_auth2.png"),
                        fit: BoxFit.fill)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(L.of(context).$['authHome']['type2'],
                        style:
                            TextStyle(color: Color(0xff494951), fontSize: 14)),
                    Text(
                      person == 0
                          ? L.of(context).$['authHome']['status1']
                          : person == 1
                              ? L.of(context).$['authHome']['status2']
                              : L.of(context).$['authHome']['status3'],
                      style: TextStyle(color: Color(0xff5390E4), fontSize: 12),
                    )
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Application.router.navigateTo(context, Routes.authWork,
                    replace: false, clearStack: false);
              },
              child: Container(
                width: double.infinity,
                height: 58,
                margin: EdgeInsets.fromLTRB(15, 15, 15, 5),
                decoration: BoxDecoration(
                    image: new DecorationImage(
                        image: new AssetImage("images/img_auth3.png"),
                        fit: BoxFit.fill)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(L.of(context).$['authHome']['type3'],
                        style:
                            TextStyle(color: Color(0xff494951), fontSize: 14)),
                    Text(
                      work == 0
                          ? L.of(context).$['authHome']['status1']
                          : work == 1
                              ? L.of(context).$['authHome']['status2']
                              : L.of(context).$['authHome']['status3'],
                      style: TextStyle(color: Color(0xff5390E4), fontSize: 12),
                    )
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Application.router.navigateTo(context, Routes.authContact,
                    replace: false, clearStack: false);
              },
              child: Container(
                width: double.infinity,
                height: 58,
                margin: EdgeInsets.fromLTRB(15, 15, 15, 5),
                decoration: BoxDecoration(
                    image: new DecorationImage(
                        image: new AssetImage("images/img_auth4.png"),
                        fit: BoxFit.fill)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(L.of(context).$['authHome']['type4'],
                        style:
                            TextStyle(color: Color(0xff494951), fontSize: 14)),
                    Text(
                      contact == 0
                          ? L.of(context).$['authHome']['status1']
                          : contact == 1
                              ? L.of(context).$['authHome']['status2']
                              : L.of(context).$['authHome']['status3'],
                      style: TextStyle(color: Color(0xff5390E4), fontSize: 12),
                    )
                  ],
                ),
              ),
            ),
            Container(
              height: 40,
              width: double.infinity,
              margin: EdgeInsets.fromLTRB(20, 70, 20, 20),
              child: RaisedButton(
                  child: Text(L.of(context).$['btn_next']),
                  color: Color(0xFF4F8AD9),
                  textColor: Color(0xFFFFFFFF),
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(42.33)),
                  onPressed: () async {
                    if(identity!=0&&person!=0&&work!=0&&contact!=0){

                      String id = widget.productId;
                      Application.router.navigateTo(
                          context, '${Routes.loanDetails}?productId=$id&isFail=1',
                          transition: TransitionType.inFromRight //过场效果
                      );
                    }else{
                      ToastAlert.tip(L.of(context).$['authHome']['toast1']);
                    }

                  }),
            )
          ],
        )));
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  void dispose() {
    super.dispose();

  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _reFresh();

  }



  int identity = 0, person = 0, work = 0, contact = 0;

  void _reFresh() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      identity = prefs.getInt("authIdentity");
      if (identity == null) {
        identity = 0;
      }
      person = prefs.getInt("authPerson");
      if (person == null) {
        person = 0;
      }
      work = prefs.getInt("authWork");
      if (work == null) {
        work = 0;
      }
      contact = prefs.getInt("authContact");
      if (contact == null) {
        contact = 0;
      }
    });
  }
}
