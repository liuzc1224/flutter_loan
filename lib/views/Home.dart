import 'package:flutter/material.dart';
import 'package:flutterdemo/language/Localizations.dart';
import 'package:flutterdemo/views/MainHome.dart';
import 'package:flutterdemo/views/Mine.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  AnimationController _controller;
  TabController controller1; //TabBar控制器
  int initialIndex = 0; //HomePage页TabBar的index

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    super.initState();

    controller1 = new TabController(
        initialIndex: this.initialIndex,
        vsync: this,
        length: 2); // 这里的length 决定有多少个底导 submenus
//    for (int i = 0; i < tabData.length; i++) {
//      myTabs.add(new Tab(text: tabData[i]['text'], icon: tabData[i]['icon']));
//    }
    controller1.addListener(() {
      if (controller1.indexIsChanging) {
        _onTabChange();
      }
    });
   //  Application.controller1 = controller1;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
//      appBar: AppBar(
//        title: Text(L.of(context).$['title']),
//      ),
      body: TabBarView(
        controller: controller1,
        children: <Widget>[new MainHome(), new Mine()],
      ),
      bottomNavigationBar: Material(
        color: const Color(0xFFFFFFFF), //底部导航栏主题颜色
        child: SafeArea(
          child: Container(
            height: 50.0,
            decoration: BoxDecoration(
              color: const Color(0xFFFFFFFF),
              border: Border(
                top: BorderSide(
                  width: 0.5, //宽度
                  color: Color(0xFFF4F4F4), //边框颜色
                ),
              ),
            ),
            child: TabBar(
              indicator: const BoxDecoration(),
              controller: controller1,
//              indicatorColor: Theme.of(context).primaryColor, //tab标签的下划线颜色
              labelColor: const Color(0xFF5999F6),
              labelStyle:TextStyle(fontSize: 9.52),
              indicatorWeight: 3.0,
              unselectedLabelColor: const Color(0xFF8E8E8E),
              tabs: <Tab>[
                Tab(child: Column(
                  children: <Widget>[
                    SizedBox(height: 4),
                    Icon(Icons.home, size: 24),
                    SizedBox(height: 3),
                    Text(L.of(context).$['home']),
                  ],
                ),),
                Tab(child: Column(
                  children: <Widget>[
                    SizedBox(height: 4),
                    Icon(Icons.person, size: 24),
                    SizedBox(height: 3),
                    Text(L.of(context).$['mine']),
                  ],
                ),),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onTabChange() {
    if (this.mounted) {
      // this.popup();
      this.setState(() {
        if (controller1.index == 0) {
        } else {}
//      appBarTitle = tabData[controller.index]['text'];
      });
    }
  }
}
