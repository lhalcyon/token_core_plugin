import 'dart:convert';

import 'package:token_core_plugin/model/ex_wallet.dart';

class ExIdentity {

  ExMetadata metadata;

  List<ExWallet> wallets = List();

  String keystore;

  ExWallet getBitcoinWallet() {
    if (wallets.length > 1) {
      return wallets[1];
    }
    return null;
  }

  ExWallet getEthereumWallet() {
    if (wallets.length > 0) {
      return wallets[0];
    }
    return null;
  }

  ExIdentity.fromMap(Map<String, dynamic> map) {
    keystore = map['keystore'];
    metadata = ExMetadata.fromMap(map['metadata']);

    var rawWallets = map['wallets'];
    if (rawWallets == null || rawWallets.length == 0) {
      print("error occurs for wallets parse error");
      return;
    }
    for (var i = 0; i < rawWallets.length; i++) {
      var walletMap = rawWallets[i];
      var wallet = ExWallet.fromMap(walletMap);

//      var metadataMap = walletMap['metadata'];
//      var metadata = ExMetadata.fromMap(metadataMap);
//      wallet.metadata = metadata;

      wallets.add(wallet);
    }
  }


  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is ExIdentity &&
              runtimeType == other.runtimeType;

  @override
  int get hashCode {
    var json = jsonDecode(this.keystore);
    var identifier = json['identifier'];
    return identifier == null ? 0 : identifier.hashCode;
  }


  Map<String, dynamic> toMap() =>
      {
        'keystore': keystore,
        'wallets': wallets,
      };

  @override
  String toString() {
    return 'ExIdentity{wallets: $wallets, keystore: $keystore}';
  }


}
