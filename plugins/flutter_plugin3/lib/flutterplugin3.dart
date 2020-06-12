import 'dart:async';

import 'package:flutter/services.dart';

class Flutterplugin3 {
  static const MethodChannel _channel =
      const MethodChannel('Flutterplugin3Plugin');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('flutter_push_to_ios');
    return version;
  }
  static Future<String> get yiTuFace async {
    final String version = await _channel.invokeMethod('flutter_push_to_ios_yiTu');
    return version;
  }
}
