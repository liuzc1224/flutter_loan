import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutterdemo/common/Api.dart';
import 'package:flutterdemo/common/Toast.dart';
import 'package:flutterdemo/common/get_login_datas.dart';
import 'package:flutterdemo/common/http_manager.dart';
import 'package:flutterdemo/common/result_data.dart';
import 'package:flutterdemo/language/Localizations.dart';
import 'package:flutterdemo/routers/application.dart';
import 'package:flutterdemo/routers/routers.dart';

class AccountSelect extends StatefulWidget {
  @override
  _AccountSelectState createState() => _AccountSelectState();
}

class _AccountSelectState extends State<AccountSelect> {
  var bankData=[];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.getBankData();
  }
  void getBankData()async{
    final Map<String, dynamic> _param  = {};
    ResultData res =
    await HttpManager.getInstance().get(Api.bankPersonal, _param);
    print(res.data);
    if (res.isSuccess) {
      setState(() {
        if(res.data['data']!=null && res.data['data']['bankCardInfoVOS']!=null){
          this.bankData = res.data['data']['bankCardInfoVOS'];
        }
        print(res.data['data']);
      });
    }else {
      ToastAlert.error(res.data['message']);
      print("error");
    }
  }
  Widget accountList() {
    if (this.bankData.length > 0) {
      List<Widget> arr = [];
      this.bankData.forEach((item) {
        arr.add(
          GestureDetector(
            onTap: (){
              Navigator.of(context).pop(item);
            },
            child: Container(
              width: double.infinity,
              height: 145.75,
              padding: EdgeInsets.only(top: 15,left: 15,right: 15),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("images/card.png"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(item['bankName'],style: TextStyle(color: Colors.white,fontSize: 16),),
                        ),
                        SizedBox(width: 6.5),
//                        item['isCheck']==1 ?
                        Container(
//                          color: Color(0xFF505261),
                          decoration: BoxDecoration(
                            color: Color(0xFF505261),
                            borderRadius: new BorderRadius.circular(19),
                          ),
                          height: 19,
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          alignment: Alignment.center,
                          child: Text(L.of(context).$['account']['verified'],style: TextStyle(color: Colors.white,fontSize: 15),),
                        )
//                            : Container()
                      ],
                    ),
                    SizedBox(height: 15),
                    Text(L.of(context).$['account']['card'],style: TextStyle(color: Colors.white,fontSize: 13.62),),
                    SizedBox(height: 10),
                    Text( item['bankCardNum']!=null ? item['bankCardNum'].toString().substring(0,4)+"   ****   ****   "+ item['bankCardNum'].toString().substring(item['bankCardNum'].toString().length-4,item['bankCardNum'].toString().length):""
                    ,style: TextStyle(color: Colors.white,fontSize: 24),),
                  ],
              ),
            ),
          )
        );
        arr.add(
            SizedBox(height: 9.5)
        );
      });
      return ListView(
        children: arr,
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset("images/illustration_hkjl.png",width: 140,height: 116,),
          SizedBox(height: 25),
          Text(L.of(context).$['account']['null'],style: TextStyle(color: Color(0xFF999999),fontSize: 14)),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Text(L.of(context).$['account']['title'],style: TextStyle(color: Color(0xFFFFFFFF))),
        elevation: 0,
        centerTitle: true,
        leading:
        IconButton(
          icon: Image.asset("images/icon_nav_arrow.png",color: Colors.white),
          onPressed: () {
            Application.router.pop(context);
          },
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: EdgeInsets.fromLTRB(15, 15, 15, 50),
        child: Column(
          children: <Widget>[
            Expanded(
              child: accountList(),
            ),
            Container(
              alignment: Alignment.center,
              height: 40,
              margin: EdgeInsets.only(top: 10),
              child: RaisedButton(
                  child:Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.add,size: 25,),
                      Container(
                        width: 5,
                      ),
                      new Text(L.of(context).$['account']['add'], style: TextStyle(fontSize: 14.44,)),
                    ],
                  ),
                  color: Color(0xFF4F8AD9),
                  textColor: Color(0xFFFFFFFF),
                  elevation: 10,
                  disabledTextColor:Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40)
                  ),
                  onPressed: (){
                    Application.router.navigateTo(context, Routes.accountAdd,transition: TransitionType.inFromRight).then((result){
                      if(result !=null){
                        this.getBankData();
                      }
                    });
                  }
              ),
            )
          ],
        ),
      ),
    );
  }
}
