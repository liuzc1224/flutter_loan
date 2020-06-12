import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
class ToastAlert{
  static error(String msg) async {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.CENTER,
      timeInSecForIos: 1,
      backgroundColor: Color(0xFFF56C6C),
      textColor:  Color(0xFFFFFFFF),
    );
  }
  static success(String msg) async {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.CENTER,
      timeInSecForIos: 1,
      backgroundColor: Color(0xFF67C23A),
      textColor:  Color(0xFFFFFFFF),
    );
  }
  static tip(String msg) async {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.CENTER,
      timeInSecForIos: 1,
      backgroundColor: Color(0xFF909399),
      textColor:  Color(0xFFFFFFFF),
    );
  }
}
