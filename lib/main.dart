import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutterdemo/common/response_interceptor.dart';
import 'package:flutterdemo/views/SplashPage.dart';
import 'package:flutterdemo/routers/routers.dart';
import 'package:flutterdemo/routers/application.dart';
import 'package:flutterdemo/language/Localizations.dart';
//import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'dart:async';
void main() => runApp(MyApp());


class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  MyApp() {
    final router = new Router();
    Routes.configureRoutes(router);
    Application.router = router;
  }
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'FlutterDemo',
      theme: new ThemeData(
        primaryColor: Color(0xFF4F8AD9),
      ),
      home: new SplashPage(),
      navigatorKey: ResponseInterceptors.navigatorKey,
      onGenerateRoute: Application.router.generator,
      localizationsDelegates: [                             //此处
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        DemoLocalizationsDelegate.delegate,
        const FallbackCupertinoLocalisationsDelegate()
      ],
      supportedLocales: [//此处
        const Locale('zh','CH'),
        const Locale('in','ID'),
      ],
    );
  }
}

class FreeLocalizations extends StatefulWidget{

  final Widget child;

  FreeLocalizations({Key key,this.child}):super(key:key);

  @override
  State<FreeLocalizations> createState() {
    return new _FreeLocalizations();
  }
}
class FallbackCupertinoLocalisationsDelegate
    extends LocalizationsDelegate<CupertinoLocalizations> {
  const FallbackCupertinoLocalisationsDelegate();

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<CupertinoLocalizations> load(Locale locale) =>
      DefaultCupertinoLocalizations.load(locale);

  @override
  bool shouldReload(FallbackCupertinoLocalisationsDelegate old) => false;
}
class _FreeLocalizations extends State<FreeLocalizations>{
  Locale _locale = const Locale('in','ID');
  changeLocale(Locale locale){
    setState((){
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Localizations.override(
      context: context,
      locale: _locale,
      child: widget.child,
    );
  }
}


