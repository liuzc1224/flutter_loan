import 'package:flutter/cupertino.dart';
import 'package:flutterdemo/routers/application.dart';

class popu extends StatefulWidget {
  @override
  _popuState createState() => _popuState();
}

class _popuState extends State<popu> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xffff0000),
      child: new Container(),
    );
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Application.router.pop(context);

  }
}
