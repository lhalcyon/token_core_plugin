

import 'package:flutter/material.dart';
import 'package:token_core_plugin/model/ex_identity.dart';
import 'package:token_core_plugin/model/ex_wallet.dart';
import 'package:token_core_plugin/token_core_plugin.dart';
import 'package:token_core_plugin_example/item.dart';
import 'package:flutter/services.dart';

class IdentityDemo extends StatelessWidget {

  List<Item> listData = List();

  void initList() {
    listData.clear();
    listData.add(Item('random mnemonic test', onItemTapped(0)));
    listData.add(Item('create identity test', onItemTapped(1)));
    listData.add(Item('recover identity test',onItemTapped(2)));
    listData.add(Item('identity export mnemonic test', onItemTapped(3)));
  }

  Future onItemTapped(int index) async {
    var password = 'qq123456';
    switch (index) {
      case 0:
        try {
          String mnemonic = await TokenCorePlugin.randomMnemonic(Words.twelve);
          print(mnemonic);
        } on PlatformException catch (e) {
          print(e.toString());
        }
        break;
      case 1:
        try {
          ExIdentity identity = await TokenCorePlugin.createIdentity(
              password, Network.testNet, SegWit.none, Words.twelve);
          print(identity.toString());
        } on PlatformException catch (e) {
          print(e.toString());
        }
        break;
      case 2:
        try {
          ExIdentity identity = await TokenCorePlugin.recoverIdentity(
              password,
              Network.testNet,
              SegWit.none,
              "reward left manage decorate joke milk tomorrow spoil wrist regular disease correct");
          print(identity.toString());
        } on PlatformException catch (e) {
          print(e.toString());
        }
        break;
      case 3:
        try {
          ExIdentity identity = await TokenCorePlugin.recoverIdentity(
              password,
              Network.testNet,
              SegWit.none,
              "reward left manage decorate joke milk tomorrow spoil wrist regular disease correct");
          var keystore = identity.keystore;
          var mnemonic =
          await TokenCorePlugin.exportMnemonic(keystore, password);
          print(mnemonic);
        } on PlatformException catch (e) {
          print(e.toString());
        }
        break;
      case 4:
        try {
          ExIdentity identity = await TokenCorePlugin.recoverIdentity(
              password,
              Network.testNet,
              SegWit.none,
              "reward left manage decorate joke milk tomorrow spoil wrist regular disease correct");
          var wallet = identity.getBitcoinWallet();
          String privateKey =
          await TokenCorePlugin.exportPrivateKey(wallet.keystore, password);
          print(privateKey);
        } on PlatformException catch (e) {
          print(e.toString());
        }
        break;
      default:
        break;
    }
  }


  @override
  Widget build(BuildContext context) {
    initList();
    return new ListView.builder(itemCount:listData.length,itemBuilder: (BuildContext context, int index){
      var data = listData[index];
      return new ListTile(title: new Text(data.title),onTap: (){
        data.onTap;
      },);
    });
  }


}