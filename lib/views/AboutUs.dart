import 'package:flutter/material.dart';
import 'package:flutterdemo/language/Localizations.dart';
import 'package:flutterdemo/routers/application.dart';

class AboutUs extends StatefulWidget {
  final version;

  const AboutUs({Key key, this.version})
      : super(key: key);
  @override
  _AboutUsState createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Text(L.of(context).$['setting']['about'],style: TextStyle(color: Color(0xFFFFFFFF))),
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
        color: Colors.white,
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height:49.5),
            Image.asset("images/about_logo.png",width: 84.5,),
            SizedBox(height:22.5),
            Text.rich(
              TextSpan(
                text: L.of(context).$['setting']['version'],
                style: TextStyle(color: Color(0xFF494951),fontSize: 15),// default text style
                children: <TextSpan>[
                  TextSpan(text: widget.version),
                ],
              ),
            ),
            SizedBox(height:25.5),
            Text(L.of(context).$['setting']['text1'],style: TextStyle(color: Color(0xFF999999),fontSize: 15)),
            Text(L.of(context).$['setting']['text2'],style: TextStyle(color: Color(0xFF999999),fontSize: 15)),
          ],
        ),
      ),
    );
  }
}
