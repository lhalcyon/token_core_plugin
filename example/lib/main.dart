import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:token_core_plugin/model/ex_identity.dart';
import 'package:token_core_plugin/model/ex_wallet.dart';
import 'package:token_core_plugin/token_core_plugin.dart';
import 'package:token_core_plugin_example/demos/identity.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}



class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {

  TabController mController;

  List<TabItem> tabs = [
    TabItem('Identity Test', IdentityDemo()),
    TabItem('BTC Test',Container(color: Colors.teal,))
  ];

  @override
  void initState() {
    super.initState();
    mController = TabController(
      length: tabs.length,
      vsync: this,
    );
  }

  @override
  void dispose() {
    super.dispose();
    mController.dispose();
  }


  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(title: Text('TokenCore Plugin Test'),),
        body: Column(
          children: <Widget>[
            Container(
              color: new Color(0xfff4f5f6),
              height: 38.0,
              child: TabBar(
                isScrollable: true,
                //是否可以滚动
                controller: mController,
                labelColor: Colors.blue,
                unselectedLabelColor: Colors.grey,
                labelStyle: TextStyle(fontSize: 16.0),
                tabs: tabs.map((item) {
                  return Tab(
                    text: item.label,
                  );
                }).toList(),
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: mController,
                children: tabs.map((item) {
                  return Stack(children: <Widget>[
                    Align(alignment:Alignment.topCenter,child: item.widget,),
                  ],);
                }).toList(),
              ),
            )
          ],
        ),
      ),
    );
  }
}


class TabItem {
  String label;

  Widget widget;

  TabItem(this.label, this.widget);

}