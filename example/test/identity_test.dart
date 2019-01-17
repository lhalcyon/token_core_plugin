import 'package:flutter_test/flutter_test.dart';
import 'package:token_core_plugin/model/ex_identity.dart';
import 'package:token_core_plugin/model/ex_wallet.dart';
import 'package:token_core_plugin/token_core_plugin.dart';
import 'package:flutter/services.dart';
import 'package:token_core_plugin_example/main.dart';

void main() {

  testWidgets('random mnemonic test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());


    try {
      ExIdentity identity =
      await TokenCorePlugin.createIdentity('qq123456', Network.testNet, SegWit.none, Words.twelve);
      print(identity.toString());
    } on PlatformException catch (e) {
      print(e.toString());
    }

//    try {
//      String mnemonic = await TokenCorePlugin.randomMnemonic(Words.twelve);
//      print(mnemonic);
//    } on PlatformException catch (e) {
//      print(e.toString());
//    }

  });


  test('random mnemonic test', () async {
    try {
      String mnemonic = await TokenCorePlugin.randomMnemonic(Words.twelve);
      print(mnemonic);
    } on PlatformException catch (e) {
      print(e.toString());
    }
  });

  test('create identity test', () async {
    try {
      ExIdentity identity =
          await TokenCorePlugin.createIdentity('qq123456', Network.testNet, SegWit.none, Words.twelve);
      print(identity.toString());
    } on PlatformException catch (e) {
      print(e.toString());
    }
  });
}
