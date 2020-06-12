import 'package:flutter/material.dart';
import 'package:flutterdemo/common/Api.dart';
import 'package:flutterdemo/common/Toast.dart';
import 'package:flutterdemo/common/http_manager.dart';
import 'package:flutterdemo/common/result_data.dart';
import 'package:flutterdemo/language/Localizations.dart';
import 'package:flutterdemo/routers/application.dart';

class BankPage extends StatefulWidget {
  @override
  _BankPageState createState() => _BankPageState();
}

class _BankPageState extends State<BankPage> {
  var bankData=[];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.getBankData();
  }
  getBankData()async{
    final Map<String, dynamic> _param  = {};
    ResultData res =
    await HttpManager.getInstance().get(Api.bankSupport, _param);
    print(res.data);
    if (res.isSuccess) {
      setState(() {
        if(res.data['data']!=null){
          this.bankData = res.data['data'];
        }
        print(res.data['data']);
      });
    }else {
      ToastAlert.error(res.data['message']);
      print("error");
    }
  }
  Widget bankList() {
    if (this.bankData.length > 0) {
      List<Widget> arr = [];
      this.bankData.forEach((item) {
        arr.add(
            ListTile(
                title: Text((item['bankName']!=null ? item['bankName'] : "") ,
                  style: TextStyle(color: Color(0xFF666666), fontSize: 15),),
                leading: item['bankIconUrl']!=null ? Image.network(
                  item['bankIconUrl'],
                  width: 30,
                  height: 30,
                ) : Container(
                  height: 30,
                  width: 30,
                ),
                enabled: true,
                onTap: () {
                  Navigator.of(context).pop(item);
                }
            )
        );
        arr.add(
            SizedBox(height: 1, child: Container(color: Color(0xFFF5F5F5))));
      });
      return Column(
        children: arr,
      );
    } else {
      return Container(
        padding: EdgeInsets.only(top: 150),
        child:  Center(
          child:CircularProgressIndicator(),
        )
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Text(L.of(context).$['account']['bank'],style: TextStyle(color: Color(0xFFFFFFFF))),
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
      body: ListView(
        children: <Widget>[
          bankList()
        ],
      ),
    );
  }
}
