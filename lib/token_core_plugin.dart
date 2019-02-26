import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:token_core_plugin/model/ex_identity.dart';
import 'package:token_core_plugin/model/ex_wallet.dart';
import 'package:token_core_plugin/model/sign_result.dart';
import 'package:token_core_plugin/model/utxo.dart';

class TokenCorePlugin {
  static const MethodChannel _channel =
      const MethodChannel('realm.lhalcyon.com/token_core_plugin');

  static Future<ExIdentity> createIdentity(
      String password, String network, String segwit, int words) async {
    final String identityJson = await _channel.invokeMethod('createIdentity', {
      'password': password,
      'network': network,
      'segWit': segwit,
      'words': words,
    });
    Map<String, dynamic> map = json.decode(identityJson);
    var identity = ExIdentity.fromMap(map);
    return identity;
  }

  static Future<String> randomMnemonic(int words) async {
    final String mnemonic =
        await _channel.invokeMethod('randomMnemonic', {'words': words});
    return mnemonic;
  }

  static Future<String> exportMnemonic(String keystore, String password) async {
    final String mnemonic = await _channel.invokeMethod(
        'exportMnemonic', {'keystore': keystore, 'password': password});
    return mnemonic;
  }

  static Future<String> exportPrivateKey(
      String keystore, String password) async {
    final String privateKey = await _channel.invokeMethod(
        'exportPrivateKey', {'keystore': keystore, 'password': password});
    return privateKey;
  }

  static Future<bool> verifyPassword(String keystore, String password) async {
    final bool isValid = await _channel.invokeMethod(
        'verifyPassword', {'keystore': keystore, 'password': password});
    return isValid;
  }

  static Future<ExIdentity> recoverIdentity(
      String password, String network, String segwit, String mnemonic) async {
    final String identityJson = await _channel.invokeMethod('recoverIdentity', {
      'password': password,
      'network': network,
      'segWit': segwit,
      'mnemonic': mnemonic,
    });
    Map<String, dynamic> map = json.decode(identityJson);
    var identity = ExIdentity.fromMap(map);
    return identity;
  }

  static Future<ExWallet> importPrivateKey(String privateKey, String password,
      String network, String segwit, String chainType) async {
    final String walletJson = await _channel.invokeMethod('importPrivateKey', {
      'privateKey': privateKey,
      'password': password,
      'network': network,
      'chainType': chainType,
      'segWit': segwit
    });
    Map<String, dynamic> map = json.decode(walletJson);
    var wallet = ExWallet.fromMap(map);

    return wallet;
  }

  static Future<SignResult> signBitcoinTransaction(
      String toAddress,
      int amount,
      int fee,
      List<UTXO> utxo,
      ExWallet wallet,
      int changeIndex,
      String password) async {
    UTXOStore store = UTXOStore();
    store.utxos = utxo;
    String utxoListStr = jsonEncode(store.toList());

    final String signResultJson =
        await _channel.invokeMethod('signBitcoinTransaction', {
      'toAddress': toAddress,
      'fee': fee,
      'utxo': utxoListStr,
      'keystore': wallet.keystore,
      'changeIndex': changeIndex,
      'password': password,
      'amount': amount
    });
    Map<String, dynamic> map = json.decode(signResultJson);
    var signResult = SignResult.fromMap(map);
    return signResult;
  }

  static Future<SignResult> signUSDTTransaction(
      String toAddress,
      int amount,
      int fee,
      List<UTXO> utxo,
      ExWallet wallet,
      int changeIndex,
      String password,
      String usdtHex) async {
    UTXOStore store = UTXOStore();
    store.utxos = utxo;
    String utxoListStr = jsonEncode(store.toList());

    final String signResultJson =
    await _channel.invokeMethod('signUSDTTransaction', {
      'toAddress': toAddress,
      'fee': fee,
      'utxo': utxoListStr,
      'keystore': wallet.keystore,
      'changeIndex': changeIndex,
      'password': password,
      'usdtHex': usdtHex,
      'amount': amount
    });
    Map<String, dynamic> map = json.decode(signResultJson);
    var signResult = SignResult.fromMap(map);
    return signResult;
  }
}
