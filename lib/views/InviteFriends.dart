import 'package:flutter/material.dart';
import 'package:flutter_share_plugin/flutter_share_plugin.dart';
import 'package:flutterdemo/common/Api.dart';
import 'package:flutterdemo/common/get_login_datas.dart';
import 'package:flutterdemo/language/Localizations.dart';
import 'package:flutterdemo/routers/application.dart';

class InviteFriends extends StatefulWidget {
  @override
  _InviteFriendsState createState() => _InviteFriendsState();
}

class _InviteFriendsState extends State<InviteFriends> {
  String userId;
  @override
  void initState() {
    super.initState();
    GetLoginDatas().then(//登录完成，将信息注入请求头
            (e){
          if(e!=null){
            print(e.toString());
            setState(() {
              userId=e['id'].toString();
            });
          }
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Text(L.of(context).$['userInfo']['inviteFriends'],style: TextStyle(color: Color(0xFFFFFFFF))),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Image.asset("images/icon_nav_arrow.png",color: Colors.white),
          onPressed: () {
            Application.router.pop(context);
          },
        ),
        actions: <Widget>[
          IconButton(
              icon: Image.asset("images/icon_nav_share.png",height: 24,),
              onPressed: () async{
                String text = H5.inviteRegistered+"/"+userId+"/3/1";
                FlutterShare.shareText(text);
//                showModalBottomSheet(
//                  context: context,
//                  builder: (BuildContext context) {
//                    return new sharePage('3');
//                  },
//                ).then((val) {
//                  print(val);
//                });
              }
          )
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Color(0xFF1855A7),
        padding: EdgeInsets.symmetric(horizontal: 14.5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height:116.5),
            Image.asset("images/pic.png",fit: BoxFit.cover,),
            SizedBox(height:105.5),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                    child: Container(
                      height: 40,
                      child: RaisedButton(
                          child: Text(L.of(context).$['userInfo']['share']),
                          color: Color(0xFF4F8AD9),
                          textColor: Color(0xFFFFFFFF),
                          elevation: 10,
                          disabledTextColor:Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40)
                          ),
                          onPressed: ()async{
                            String text = H5.inviteRegistered+"/"+userId+"/3/1";
                            FlutterShare.shareText(text);
//                            showModalBottomSheet(
//                              context: context,
//                              builder: (BuildContext context) {
//                                return new sharePage("3");
//                              },
//                            ).then((val) {
//                              print(val);
//                            });
                          },
                      ),
                    )
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
