import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:token_core_plugin/model/ex_identity.dart';

class TokenCorePlugin {
  static const MethodChannel _channel =
  const MethodChannel('realm.lhalcyon.com/token_core_plugin');

  static Future<ExIdentity> createIdentity(String password, int network,
      int segwit, int words) async {
    final String identityJson = await _channel.invokeMethod('createIdentity', {
      'password': password,
      'network': network,
      'segwit': segwit,
      'words': words,
    });
    print('result:\n'+identityJson);
    Map<String, dynamic> map = json.decode(identityJson);
    var identity = ExIdentity.fromMap(map);
    return identity;
  }

  static Future<String> randomMnemonic(int words) async {
    final String mnemonic =
    await _channel.invokeMethod('randomMnemonic', {'words': words});
    return mnemonic;
  }

  static Future<String> exportMnemonic(String keystore,String password) async {
    final String mnemonic = await _channel.invokeMethod('exportMnemonic',{
      'keystore':keystore,
      'password':password
    });
    return mnemonic;
  }

  static Future<String> exportPrivateKey(String keystore,String password) async{
    final String privateKey = await _channel.invokeMethod('exportPrivateKey',{
      'keystore':keystore,
      'password':password
    });
    return privateKey;
  }

  static Future<bool> verifyPassword(String keystore,String password) async{
    final bool isValid = await _channel.invokeMethod('verifyPassword',{
      'keystore':keystore,
      'password':password
    });
    return isValid;
  }

  static Future<ExIdentity> recoverIdentity(String password, int network,
      int segwit, String mnemonic) async {
    final String identityJson = await _channel.invokeMethod('recoverIdentity', {
      'password': password,
      'network': network,
      'segwit': segwit,
      'mnemonic': mnemonic,
    });
    print('result:\n'+identityJson);
    Map<String, dynamic> map = json.decode(identityJson);
    var identity = ExIdentity.fromMap(map);
    return identity;
  }

}
