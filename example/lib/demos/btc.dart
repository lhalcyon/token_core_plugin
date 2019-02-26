import 'package:flutter/material.dart';
import 'package:token_core_plugin/model/ex_identity.dart';
import 'package:token_core_plugin/model/ex_wallet.dart';
import 'package:token_core_plugin/model/utxo.dart';
import 'package:token_core_plugin/token_core_plugin.dart';
import 'package:token_core_plugin_example/item.dart';
import 'package:flutter/services.dart';

class BTCDemo extends StatelessWidget {
  final List<Item> listData = List();

  void initList() {
    listData.clear();
    listData.add(Item('mnemonic create test'));
    listData.add(Item('mnemonic import test'));
    listData.add(Item('mnemonic export test'));
    listData.add(Item('private key import test'));
    listData.add(Item('private key export test'));
    listData.add(Item('transaction test'));
    listData.add(Item('verify password test'));
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
          var mnemonic =
              await TokenCorePlugin.exportMnemonic(identity.keystore, password);
          print(mnemonic);
        } on PlatformException catch (e) {
          print(e.toString());
        }
        break;
      case 3:
        try {
          String privateKey =
              "cPu5FwyCfpEizTJRJwmRDzaLWQyULqmELbFDQDYgxSvquM2Z9JSd";
          var wallet = await TokenCorePlugin.importPrivateKey(privateKey,
              password, Network.testNet, SegWit.none, ChainType.bitcoin);
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
          var keystore = identity.getBitcoinWallet().keystore;
          var privateKey =
              await TokenCorePlugin.exportPrivateKey(keystore, password);
          print(privateKey);
        } on PlatformException catch (e) {
          print(e.toString());
        }
        break;
      case 5:
        try {
          var amount = 9000;
          var fee = 7000;
          ExIdentity identity = await TokenCorePlugin.recoverIdentity(
              password,
              Network.testNet,
              SegWit.none,
              "hurt certain dash ankle cricket exist winner jelly dizzy diary embody radar");
          var bitcoinWallet = identity.getBitcoinWallet();
          print("bitcoinWallet:$bitcoinWallet");
          String to = "n4QyHicAPpidqHRtgr9MsaKqhMqq1kEDLn";
          List<UTXO> utxo = [
            UTXO(
                txHash:
                    "2301b40a6f8d6de8b7f2dbea987748a8c02275ca209ad6c80426283e6260824c",
                vout: 0,
                amount: 5000,
                address: bitcoinWallet.address,
                scriptPubKey: "a91480b7abac1f5c44d45c76fb2a43a0a2f062bd8cd887",
                derivedPath: "0/0"),
            UTXO(
                txHash:
                    "7d082237e2cfa5ebe5323cee85a645a4956d4c15eb110329115570d660bece6a",
                vout: 0,
                amount: 5000,
                address: bitcoinWallet.address,
                scriptPubKey: "a91480b7abac1f5c44d45c76fb2a43a0a2f062bd8cd887",
                derivedPath: "0/0")
          ];
          var signResult = await TokenCorePlugin.signBitcoinTransaction(
              to, amount, fee, utxo, bitcoinWallet, 0, password);
          print(signResult);
        } on PlatformException catch (e) {
          print(e.toString());
        }
        break;
      case 6:
        try {
          ExIdentity identity = await TokenCorePlugin.recoverIdentity(
              password,
              Network.testNet,
              SegWit.none,
              "reward left manage decorate joke milk tomorrow spoil wrist regular disease correct");
          var keystore = identity.keystore;
          var isCorrect = TokenCorePlugin.verifyPassword(keystore, password);
          print("isCorrect:$isCorrect");
          isCorrect.then((b){
            print('then:$b');
          });
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
    return new ListView.builder(
        itemCount: listData.length,
        itemBuilder: (BuildContext context, int index) {
          var data = listData[index];
          return new ListTile(
            title: new Text(data.title),
            onTap: () {
              print('--------------- ' + data.title + 'start ---------------');
              onItemTapped(index);
              print('end');
            },
          );
        });
  }
}
