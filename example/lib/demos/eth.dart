

import 'package:flutter/material.dart';
import 'package:token_core_plugin/model/ex_identity.dart';
import 'package:token_core_plugin/model/ex_wallet.dart';
import 'package:token_core_plugin/token_core_plugin.dart';
import 'package:token_core_plugin_example/item.dart';
import 'package:flutter/services.dart';

class ETHDemo extends StatelessWidget {

  final List<Item> listData = List();

  void initList() {
    listData.clear();
    listData.add(Item('mnemonic create'));
    listData.add(Item('mnemonic import'));
    listData.add(Item('mnemonic export'));
    listData.add(Item('private key import '));
    listData.add(Item('private key export'));
    listData.add(Item('keystore import '));
    listData.add(Item('keystore import '));
  }

  Future onItemTapped(int index) async {
    var password = 'qq123456';
    switch (index) {
      case 0:
        try {
          ExIdentity identity = await TokenCorePlugin.createIdentity(
              password, Network.testNet, SegWit.none, Words.twelve);
          print(identity.toString());
          var btc = identity.getBitcoinWallet();
          print(btc.toString());
        } on PlatformException catch (e) {
          print(e.toString());
        }
        break;
      case 1:
        try {
          ExIdentity identity = await TokenCorePlugin.recoverIdentity(
              password,
              Network.testNet,
              SegWit.none,
              "reward left manage decorate joke milk tomorrow spoil wrist regular disease correct");
          var btc = identity.getBitcoinWallet();
          print(btc.toString());
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
          var mnemonic = await TokenCorePlugin.exportMnemonic(identity.keystore, password);
          print(mnemonic);
        } on PlatformException catch (e) {
          print(e.toString());
        }
        break;
      case 3:
        try {
          String privateKey = "cPu5FwyCfpEizTJRJwmRDzaLWQyULqmELbFDQDYgxSvquM2Z9JSd";
          var wallet = await TokenCorePlugin.importPrivateKey(privateKey, password,Network.testNet,SegWit.none,ChainType.bitcoin);
          print(wallet.toString());
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
          var keystore = identity.keystore;
          var mnemonic =
          await TokenCorePlugin.exportMnemonic(keystore, password);
          print(mnemonic);
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
        print('--------------- '+data.title +'start ---------------');
        onItemTapped(index);
        print('end');
      },);
    });
  }


}