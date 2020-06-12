import 'dart:async';

import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_banner_swiper/flutter_banner_swiper.dart';
import 'package:flutterdemo/common/Api.dart';
import 'package:flutterdemo/common/Dateutils.dart';
import 'package:flutterdemo/common/Toast.dart';
import 'package:flutterdemo/common/get_login_datas.dart';
import 'package:flutterdemo/common/http_manager.dart';
import 'package:flutterdemo/common/result_data.dart';
import 'package:flutterdemo/common/to_h5_page.dart';
import 'package:flutterdemo/language/Localizations.dart';
import 'package:flutterdemo/routers/application.dart';
import 'package:flutterdemo/routers/routers.dart';
import 'package:location/location.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainHome extends StatefulWidget {
  @override
  _MainHomeState createState() => _MainHomeState();
}

class _MainHomeState extends State<MainHome> {
  List<String> bannerList = [
    "https://img-blog.csdn.net/20170214201828524?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvYXNreWNhdA==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast",
    "https://dss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=2534506313,1688529724&fm=26&gp=0.jpg"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          L.of(context).$['title'],
          style: TextStyle(color: Color(0xFF494951)),
        ),
      ),
      body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: false,
        header: WaterDropHeader(),
        footer: CustomFooter(
          builder: (BuildContext context, LoadStatus mode) {
            Widget body;
            if (mode == LoadStatus.idle) {
              body = Text("pull up load");
            } else if (mode == LoadStatus.loading) {
              body = CupertinoActivityIndicator();
            } else if (mode == LoadStatus.failed) {
              body = Text("Load Failed!Click retry!");
            } else if (mode == LoadStatus.canLoading) {
              body = Text("release to load more");
            } else {
              body = Text("No more Data");
            }
            return Container(
              height: 55.0,
              child: Center(child: body),
            );
          },
        ),
        controller: _refreshController,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child: homeStatus == 0
            ? ListView(
                children: this._getData(),
              )
            : homeStatus == 1
                ? Container(
                    height: double.infinity,
                    width: double.infinity,
                    color: Colors.white,

                    ///审核中
                    child: auditView(),
                  )
                : homeStatus == 2
                    ? Container(
                        ///借款失败
                        child: applyFail(),
                      )
                    : homeStatus == 3
                        ? Container(
                            ///审核被拒
                            child: refuse(),
                            color: Color(0xffeeeeee),
                          )
                        : homeStatus == 4
                            ? Container(
                                ///放款成功      首次需要弹出弹窗
                                child: rePayView(),
                              )
                            : Container(),
      ),
    );
  }

  ///审核
  Widget auditView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 10, child: Container(color: Color(0xFFEEEEEE))),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                L.of(context).$['mainHome']['orderName'] +
                    statusData['orderNo'].toString(),
                style: TextStyle(fontSize: 13, color: Color(0xff494951)),
              ),
              SizedBox(height: 15),
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: <Widget>[
                        Text(
                          statusData['applyMoney'].toString(),
                          style:
                              TextStyle(fontSize: 20, color: Color(0xff494951)),
                        ),
                        SizedBox(height: 10),
                        Text(
                          L.of(context).$['mainHome']['anount'],
                          style:
                              TextStyle(fontSize: 13, color: Color(0xff999999)),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: <Widget>[
                        Text(
                          (statusData['loanDays'] * statusData['applyMonth'])
                              .toString(),
                          style:
                              TextStyle(fontSize: 20, color: Color(0xff494951)),
                        ),
                        SizedBox(height: 10),
                        Text(
                          L.of(context).$['mainHome']['time'],
                          style:
                              TextStyle(fontSize: 13, color: Color(0xff999999)),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),
              Text(
                L.of(context).$['mainHome']['date'] +
                    DateUtils.instance.getFormartData(
                        timeSamp: statusData['createTime'],
                        format: "dd-MM-yyyy HH:mm"),
                style: TextStyle(fontSize: 13, color: Color(0xff494951)),
              ),
            ],
          ),
        ),
        SizedBox(height: 10, child: Container(color: Color(0xFFEEEEEE))),
        SizedBox(
          height: 13,
        ),

        ///提交成功
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(right: 5, left: 15),
              width: 65,
              child: Text(
                DateUtils.instance.getFormartData(
                    timeSamp: statusData['createTime'],
                    format: "dd-MM-yyyy HH:mm"),
                style: TextStyle(fontSize: 12, color: Color(0xff4F8AD9)),
              ),
            ),
            Column(
              children: <Widget>[
                Image.asset("images/img_isok.png", fit: BoxFit.fill),
                SizedBox(
                    height: 32,
                    width: 2,
                    child: Container(color: Color(0xff4F8AD9))),
              ],
            ),
            SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  L.of(context).$['mainHome']['submit_ok'],
                  style: TextStyle(fontSize: 15, color: Color(0xff4F8AD9)),
                ),
                Text(
                  L.of(context).$['mainHome']['submit_ok'],
                  style: TextStyle(fontSize: 13, color: Color(0xff999999)),
                )
              ],
            )
          ],
        ),

        ///审核
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(right: 5, left: 15),
              width: 65,
              child: Text(
/*                statusData['status']==13?
                DateUtils.instance.getFormartData(
                    timeSamp: statusData['applyDate'],
                    format: "dd-MM-yyyy HH:mm"):"",*/
                "",
                style: TextStyle(fontSize: 12, color: Color(0xff4F8AD9)),
              ),
            ),
            Column(
              children: <Widget>[
                Image.asset(
                    statusData['status'] == 13
                        ? "images/img_wiat.png"
                        : "images/img_isok.png",
                    fit: BoxFit.fill),
                SizedBox(
                    height: 32,
                    width: 2,
                    child: Container(color: Color(0xFFEEEEEE))),
              ],
            ),
            SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  L.of(context).$['mainHome']['wait_view'],
                  style: TextStyle(fontSize: 15, color: Color(0xff4F8AD9)),
                ),
                Text(
                  L.of(context).$['mainHome']['five_min'],
                  style: TextStyle(fontSize: 13, color: Color(0xff999999)),
                )
              ],
            )
          ],
        ),

        ///放款
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(right: 5, left: 15),
              width: 65,
              child: Text(
                "",
                style: TextStyle(fontSize: 12, color: Color(0xff4F8AD9)),
              ),
            ),
            Column(
              children: <Widget>[
                Image.asset(
                    statusData['status'] == 13
                        ? "images/img_wiat.png"
                        : "images/img_isok.png",
                    fit: BoxFit.fill),
                SizedBox(height: 32, width: 2),
              ],
            ),
            SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  L.of(context).$['mainHome']['give_money'],
                  style: TextStyle(fontSize: 15, color: Color(0xff4F8AD9)),
                ),
                Text(
                  L.of(context).$['mainHome']['give_result'],
                  style: TextStyle(fontSize: 13, color: Color(0xff999999)),
                )
              ],
            )
          ],
        ),
        Container(
          alignment: Alignment.center,
          child: Text(
            L.of(context).$['mainHome']['treating'],
            style: TextStyle(fontSize: 13, color: Color(0xff999999)),
          ),
        )
      ],
    );
  }

  int overDueDays = 0;

  ///放款成功，待还款
  Widget rePayView() {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                      flex: 1,
                      child: Text(
                        L.of(context).$['mainHome']['should_repayment'],
                        style:
                            TextStyle(fontSize: 13, color: Color(0xff999999)),
                      )),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    decoration: new BoxDecoration(
                      border:
                          new Border.all(color: Color(0xff999999), width: 0.5),
                      borderRadius: new BorderRadius.circular(15),
                    ),
                    child: Text(
                      statusData['currentPeriod'].toString() +
                          "/" +
                          statusData['applyMonth'].toString(),
                      style: TextStyle(fontSize: 13, color: Color(0xff999999)),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),
              Row(
                children: <Widget>[
                  Text(
                    statusData['repayAmount'].toString(),
                    style: TextStyle(fontSize: 30, color: Color(0xff494951)),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    decoration: new BoxDecoration(
                      //   border: new Border.all(color: Color(0xff999999), width: 0.5),
                      borderRadius: new BorderRadius.circular(10),
                      color: Color(0xffF56868),
                    ),
                    child: Text(
                      overDueDays != null
                          ? L.of(context).$['mainHome']['over_days'] +
                              overDueDays.toString() +
                              L.of(context).$['mainHome']['days']
                          : statusData['loanEndDays'].toString() +
                              L.of(context).$['mainHome']['days_repay'],
                      style: TextStyle(fontSize: 13, color: Colors.white),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),
              Text(
                L.of(context).$['mainHome']['repay_date'],
                style: TextStyle(fontSize: 13, color: Color(0xff999999)),
              ),
              SizedBox(
                height: 25,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: 40,
                    width: double.infinity,
                    //  margin: EdgeInsets.symmetric(horizontal: 20),
                    child: RaisedButton(
                        child: Text(L.of(context).$['mainHome']['go_repay']),
                        color: Color(0xFF4F8AD9),
                        textColor: Color(0xFFFFFFFF),
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(42.33)),
                        onPressed: () {
                          //马上还款
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ToH5Page(url:H5.toRepay +
                                  "?orderId=" +
                                  statusData['orderId'].toString()),
                            ),
                          );
                        }),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    L.of(context).$['mainHome']['already_repay'],
                    style: TextStyle(fontSize: 13, color: Color(0xff4F8AD9)),
                  ),
                ],
              )
            ],
          ),
        ),
        SizedBox(
          height: 10,
          child: Container(
            color: Color(0xffEEEEEE),
          ),
        ),
        SizedBox(
          height: 30,
        ),
        Image.asset(
          "images/img_repay.png",
          fit: BoxFit.fill,
          width: 188,
          height: 160,
          alignment: Alignment.center,
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: Text(
            L.of(context).$['mainHome']['blacklist'],
            style: TextStyle(fontSize: 13, color: Color(0xff999999)),
          ),
        )
      ],
    );
  }

  ///审核被拒
  Widget refuse() {
    return Column(
      children: <Widget>[
        Image.asset(
          'images/img_failtop.png',
          fit: BoxFit.fill,
          width: double.infinity,
          height: 166,
        ),
        Container(
          width: double.infinity,
          padding: EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 20),
          margin: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
          height: 196,
          decoration: new BoxDecoration(
              image:
                  DecorationImage(image: AssetImage("images/refuse_bg.png"))),
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Text(
                  L.of(context).$['mainHome']['refuse_content'] +
                      statusData['expireRejectDays'].toString() +
                      L.of(context).$['mainHome']['days'],
                  style: TextStyle(fontSize: 13, color: Color(0xff333333)),
                ),
              ),
              Text(
                L.of(context).$['mainHome']['again_apply'],
                style: TextStyle(fontSize: 13, color: Color(0xff999999)),
              )
            ],
          ),
        )
      ],
    );
  }

  ///放款失败
  Widget applyFail() {
    return Column(
      children: <Widget>[
        Image.asset(
          'images/img_fksb_top.png',
          fit: BoxFit.fill,
          width: double.infinity,
          height: 166,
        ),
        Container(
          width: double.infinity,
          padding: EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 20),
          margin: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
          height: 196,
          decoration: new BoxDecoration(
              image: DecorationImage(image: AssetImage("images/img_fksb.png"))),
          child: Column(
            children: <Widget>[
              SizedBox(height: 40),
              Expanded(
                flex: 1,
                child: Text(
                  L.of(context).$['mainHome']['loan_fail'],
                  style: TextStyle(fontSize: 13, color: Color(0xff333333)),
                ),
              ),
              GestureDetector(
                onTap: () {
                  //跳转到申请借款，重新借款
                },
                child: Text(
                  L.of(context).$['mainHome']['change_account'],
                  style: TextStyle(fontSize: 13, color: Color(0xff4F8AD9)),
                ),
              )
            ],
          ),
        )
      ],
    );
  }

//借款产品信息
  List<Widget> _getData() {
    List<Widget> list = new List();

    list.add(Container(
      width: double.infinity,
      height: 108,
      child: BannerSwiper(
        //width  和 height 是图片的高宽比  不用传具体的高宽   必传
        height: 1,
        width: 2,
        //轮播图数目 必传
        length: bannerData.length,
        spaceMode: false,
        //轮播的item  widget 必传
        getwidget: (index) {
          return new GestureDetector(
              child: bannerData.length == 0
                  ? Container()
                  : Image.network(
                      bannerData[index % bannerData.length]['url'],
                      fit: BoxFit.cover,
                      height: 100,
                      width: double.infinity,
                    ),
              onTap: () {
                if (bannerData[index % bannerData.length]['recommendUrl'] !=
                    null) {

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ToH5Page(url:bannerData[index % bannerData.length]['recommendUrl']),
                    ),
                  );
                }
                /*    Application.router.navigateTo(context, Routes.authHome,
                    replace: false, clearStack: false);*/
                //点击后todo
              });
        },
      ),
    ));
    for (var i = 0; i < productData.length; i++) {
      list.add(Container(
        width: double.infinity,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 10,
              child: Container(
                color: Color(0xFFeeeeee),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 15),
              child: Stack(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child:
                        Text(productData[i]['loanProductName'],
                            softWrap: true,
                            style: TextStyle(
                                fontSize: 16, color: Color(0xff494951))),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          height: 25,
                          child: RaisedButton(
                              child: Text(L.of(context).$['mainHome']['apply']),
                              color: Color(0xFF4F8AD9),
                              textColor: Color(0xFFFFFFFF),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              onPressed: () {
                                goApply(i);


                              }),
                        ),
                      )
                    ],
                  ),

                ],
              ),
            ),
            Row(
              children: <Widget>[
                SizedBox(
                  width: 15,
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                      borderRadius: new BorderRadius.circular(8),
                      color: Colors.blue),
                  child: Text(
                    'Fase ' + productData[i]['period'].toString(),
                    style: TextStyle(fontSize: 12, color: Colors.white),
                  )),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: double.infinity,
              alignment: Alignment.topLeft,
              margin: EdgeInsets.only(left: 15, right: 15),
              child: Stack(
                children: <Widget>[
                  Text.rich(
                    TextSpan(
                      text: productData[i]['loanQuotaMix'].toString(),
                      style: TextStyle(color: Color(0xFF333333), fontSize: 15),
                      // default text style
                      children: <TextSpan>[
                        TextSpan(
                            text:
                                "~" + productData[i]['loanQuotaMax'].toString(),
                            style: TextStyle(color: Color(0xff4F8AD9))),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(L.of(context).$['mainHome']['amount'],
                        style:
                            TextStyle(color: Color(0xff999999), fontSize: 12)),
                  )
                ],
              ),
            ),
            Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
              child: Stack(
                children: <Widget>[
                  Text(
                      productData[i]['period'] > 1
                          ? (productData[i]['period'] *
                                  productData[i]['loanTermMax'])
                              .toString()
                          : productData[i]['loanTermMax'].toString(),
                      style: TextStyle(color: Colors.blue, fontSize: 16)),
                  Positioned(
                    left: 55,
                    child: Text(
                      L.of(context).$['mainHome']['time'],
                      style: TextStyle(color: Color(0xff999999), fontSize: 12),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ));
    }
    return list;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.getBanner();
    this._getHomeStatus();
    //  getLocation1();
  }

  void goApply(int i) async{
    ///申请借款
    //判断登陆
    SharedPreferences prefs = await SharedPreferences.getInstance();
   String islogin= prefs.getString("loginDatas");
    if(islogin!=null){
      String id = productData[i]['id'].toString();
      Application.router.navigateTo(
          context, '${Routes.authHome}?productId=$id',
          transition: TransitionType.inFromRight //过场效果
      );
    }else{
      Application.router.navigateTo(context, Routes.login, replace: true, clearStack: true);

    }
  }

  void getLocation1() async {
    var currentLocation;

    var location = new Location();

    currentLocation = await location.getLocation();
    print("location" + currentLocation);
  }

  var userInfo;
  var statusData;
  int person = 0, work = 0, contact = 0;
  int homeStatus = 0; //0可借款、1审核中、2放款失败、3审核被拒、4放款成功

  void _getHomeStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString("loginDatas") == null) {
      homeStatus = 0;
      _product();
    } else{

      Map<String, dynamic> params = {};
      ResultData res =
      await HttpManager.getInstance().get(Api.homeStatus, params);
      if (res.isSuccess) {
        this.statusData = res.data['data'];
        setState(() {});
        if (statusData == null) {
          _product();
          return;
        }
        if (statusData['successOrderCount'] > 0) {
          //身份证认证锁定为已认证、不能再更改
          prefs.setInt("authIdentity", 2);
          person = prefs.getInt("authPerson");
          if (person == null) {
            person = 0;
          }
          work = prefs.getInt("authWork");
          if (work == null) {
            work = 0;
          }
          contact = prefs.getInt("authContact");
          if (contact == null) {
            contact = 0;
          }
          if (person == 1 && work == 1 && contact == 1) {
            prefs.setInt("authWork", 0);
            prefs.setInt("authPerson", 0);
            prefs.setInt("authContact", 0);
          }
        }
        int status = statusData['creditStatus'];
        int orderStatus = statusData['status'];

        if (status == 1 || status == 8 || status == 9) {
          //审核状态
          homeStatus = 1;
        } else if (status == 2 || status == 6 || status == 7 || status == 25) {
          if (orderStatus == 4 ||
              orderStatus == 5 ||
              orderStatus == 18 ||
              orderStatus == 26) {
            //还款状态
            overDueDays = statusData['overDueDays'];
            homeStatus = 4;
          } else if (orderStatus == 13 || orderStatus == 25 || orderStatus == 2) {
            //审核状态
            homeStatus = 1;
          } else if (orderStatus == 22 ||
              orderStatus == 23 ||
              orderStatus == 24) {
            //放款失败
            homeStatus = 2;
          }
        } else if (status == 3 || status == 4) {
          //审核拒绝
          if (statusData['expireRejectDays'] != null &&
              statusData['expireRejectDays'] > 0) {
            homeStatus = 3;
          } else {
            _product();
          }
        } else if (status == 10 || status == 11 || status == 12) {
          //首页未借款
          homeStatus = 0;

          _product();
        } else {
          //首页未借款
          homeStatus = 0;
          _product();
        }

        print(res.data);
      } else {
        ToastAlert.error(res.data['message']);
      }


    }

  }

  List productData = [];

  ///获取首页产品信息
  void _product() async {
    Map<String, dynamic> params = {"state": true};
    ResultData res =
        await HttpManager.getInstance().get(Api.getProduct, params);
    if (res.isSuccess) {
      setState(() {
        this.productData = res.data['data'];
      });
      print(res.data);
    } else {
      ToastAlert.error(res.data['message']);
    }
  }

  List bannerData = [];

  void getBanner() async {
    Map<String, dynamic> params = {"state": true};
    ResultData res =
        await HttpManager.getInstance().get(Api.bannerInfo, params);
    if (res.isSuccess) {
      setState(() {
        this.bannerData = res.data['data'];
      });
      print(res.data);
    } else {
      ToastAlert.error(res.data['message']);
    }
  }

  List<String> items = ["1", "2", "3", "4", "5", "6", "7", "8"];
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    getBanner();
    _getHomeStatus();
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    items.add((items.length + 1).toString());
    if (mounted) setState(() {});
    _refreshController.loadComplete();
  }
}

/*void getDate() {
  var now = new DateTime.now();

  var a = now.millisecondsSinceEpoch; // 时间戳

  print("----" + DateTime.fromMillisecondsSinceEpoch(a).toString());
}*/
