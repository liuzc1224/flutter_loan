import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutterdemo/views/AboutUs.dart';
import 'package:flutterdemo/views/AccountAdd.dart';
import 'package:flutterdemo/views/AuthContact.dart';
import 'package:flutterdemo/views/AuthHome.dart';
import 'package:flutterdemo/views/AuthIdentity.dart';
import 'package:flutterdemo/views/AuthPerson.dart';
import 'package:flutterdemo/views/AuthWork.dart';

import 'package:flutter/material.dart';
import 'package:flutterdemo/views/InviteFriends.dart';
import 'package:flutterdemo/views/LoanDetails.dart';
import 'package:flutterdemo/views/PassWord.dart';
import 'package:flutterdemo/views/AccountSelect.dart';
import 'package:flutterdemo/views/TransitPage.dart';
import 'package:flutterdemo/views/bankPage.dart';
import 'package:flutterdemo/views/forgetPwd.dart';
import 'package:flutterdemo/views/popu.dart';
import 'package:flutterdemo/views/settingPage.dart';
import 'package:flutterdemo/views/settingPwd.dart';
import 'package:flutterdemo/views/updatePwd.dart';
import 'package:flutterdemo/widgets/404.dart';
import 'package:flutterdemo/views/Home.dart';
import 'package:flutterdemo/views/LoginPage.dart';
import 'package:flutterdemo/views/PassWord.dart';

class Routes {
//  static String root = "/";
  static String widgetDemo = '/widget-demo';
  static String home = "/home";
  static String login = "/login"; //登录
  static String passWord = "/passWord"; //登录输入密码
  static String updatePwd = "/updatePwd"; //修改密码
  static String forgetPwd = "/forgetPwd"; //忘记密码
  static String settingPwd = "/settingPwd"; //设置新密码
  static String authHome = "/authHome";
  static String authIdentity = "/authIdentity";
  static String authPerson = "/authPerson";
  static String authWork = "/authWork";
  static String authContact = "/authContact";
  static String setting = "/setting"; //设置
  static String aboutUs = "/aboutUs"; //关于我们
  static String inviteFriends = "/inviteFriends"; //邀请好友
  static String loanDetails = "/loanDetails"; //申请借款详情
  static String accountSelect = "/accountSelect";//选择账户
  static String accountAdd = "/accountAdd";//新增账户
  static String bankPage = "/bankPage";//銀行账户
  static String transitPage = "/transitPage";//活体中转页面


  static void configureRoutes(Router router) {
    router.define('/category/error/404', handler: new Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
          return new WidgetNotFound();
        }
    ));
    router.define(home, handler: new Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
          return new Home();
        }
    ));
    router.define(login, handler: new Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
          return new LoginPage();
        }
    ));
    router.define(passWord, handler: new Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
          //获取路由跳转传来的参数
          String phoneNumber = params["phoneNumber"][0];
          return new PassWord(phoneNumber:phoneNumber);
        }
    ));
    router.define(forgetPwd, handler: new Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
          String phoneNumber = params["phoneNumber"][0];
          return new ForgetPwd(phoneNumber:phoneNumber);
        }
    ));
    router.define(updatePwd, handler: new Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
          String phoneNumber = params["phoneNumber"][0];
          return new UpdatePwd(phoneNumber:phoneNumber);
        }
    ));
    router.define(settingPwd, handler: new Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      //获取路由跳转传来的参数
      String phoneNumber = params["phoneNumber"][0];
      String verificationCode = params["verificationCode"][0];
      return new SettingPwd(
          phoneNumber: phoneNumber, verificationCode: verificationCode);
    }));

    router.define(authHome, handler: new Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      String productId = params["productId"][0];
      return new AuthHome(
        productId: productId,
      );
    }));

    router.define(loanDetails, handler: new Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
          print("留在唱");
          String productId="84";
          String isFail="1";
          if(params!=null&&params.length>0){//活体回调回来
             productId = params["productId"][0];
             isFail=params['isFail'][0];
          }
      return new LoanDetails(
        productId: productId,
        isFail: isFail,
      );
    }));
    router.define(authIdentity, handler: new Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return new AuthIdentity();
    }));
    router.define(authPerson, handler: new Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return new AuthPerson();
    }));
    router.define(authWork, handler: new Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return new AuthWork();
    }));
    router.define(authContact, handler: new Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return new AuthContact();
    }));
    router.define(setting, handler: new Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return new SettingPage();
    }));
    router.define(aboutUs, handler: new Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
        String version = params["version"][0];
        return new AboutUs(version: version);
    }));
    router.define(inviteFriends, handler: new Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return new InviteFriends();
    }));
    router.define(accountSelect, handler:new Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
          return new AccountSelect();
        }
    ));
    router.define(accountAdd, handler:new Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
          return new AccountAdd();
        }
    ));
    router.define(bankPage, handler:new Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
          return new BankPage();
        }
    ));
    router.define(transitPage, handler:new Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
          String state = 'false';
          if(params!=null&&params.length>0){
            state = 'true';
          };
          return new TransitPage(
            state: state,
          );
        }
    ));
  }
}
