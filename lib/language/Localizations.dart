import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutterdemo/common/logs_interceptor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'zh.dart';
import 'in.dart';
import 'package:flutter/foundation.dart' show SynchronousFuture;

class L {

  final Locale locale;

  L(this.locale);

  static Map<String,dynamic> _localizedValues = {
    'id': id,
    'zh': zh
  };
  get ${
    return _localizedValues[locale.languageCode];
  }

  static L of(BuildContext context){
    return Localizations.of(context, L);
  }
}

class DemoLocalizationsDelegate extends LocalizationsDelegate<L>{

  const DemoLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['in','zh'].contains(locale.languageCode);
  }

  @override
  Future<L> load(Locale locale) async{
    //初始化 国际化
    print(locale);
    SharedPreferences prefs = await SharedPreferences.getInstance();
//    print(const Locale('id','ID'));
    if(locale.toString()=="zh_CH"){
      prefs.setString("Language", "zh-CN");
      return new SynchronousFuture<L>(new L(locale));
    }else{
      prefs.setString("Language", "in-ID");
      return new SynchronousFuture<L>(new L(const Locale('id','ID')));
    }

    // return new SynchronousFuture<L>(new L(const Locale('id','ID')));
//    return new SynchronousFuture<L>(new L(locale));//修改默认采用zh.dart的全球化
  }

  @override
  bool shouldReload(LocalizationsDelegate<L> old) {
    return false;
  }

  static DemoLocalizationsDelegate delegate = const DemoLocalizationsDelegate();
}

