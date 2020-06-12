import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterplugin3/flutterplugin3.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TransitPage extends StatefulWidget {
  final state;

  const TransitPage({Key key, this.state})
      : super(key: key);
  @override
  _TransitPageState createState() => _TransitPageState();
}

class _TransitPageState extends State<TransitPage> {

  static const eventChannel = EventChannel('Flutterplugin3Plugin');
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    eventChannel.receiveBroadcastStream().listen(_getData, onError: _getError);
     _open();

  }

  void _open()async{
//    SharedPreferences prefs = await SharedPreferences.getInstance();
//    bool boo= prefs.getBool("tran");
    if(widget.state=='true'){
      try {
//        prefs.setBool("tran", false);
        var platformVersion = await Flutterplugin3.platformVersion;

      } on PlatformException {
        //  platformVersion = 'Failed to get platform version.';
      }
    }
  }
//活体返回回调
  void _getData(dynamic data) {
    setState(() {
      print('ds--------------ddd');
      Navigator.of(context).pop(data);
      //_commitAdvance(data.toString());
    });
  }
  //获取到错误
  void _getError(Object err) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
