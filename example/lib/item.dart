import 'package:flutter/material.dart';
import 'dart:async';

class Item {
  String title;

  Future onTap;

  Item(this.title,this.onTap);


}


class TestWidget extends StatelessWidget {

  final List<Item> listData;

  TestWidget(this.listData);

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: ListView.builder(
          itemCount: listData.length,
          itemBuilder: (BuildContext context, int index) {
            var item = listData[index];
            return ListTile(
                title: Text(item.title),
                onTap: () async {
                  await item.onTap;
                });
          }),
    );
  }

}


