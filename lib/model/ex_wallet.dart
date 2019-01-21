class Network {

  static const int mainNet = 0;

  static const int testNet = 1;


}

class SegWit {

  static const int none = 0;

  static const int p2wpkh = 1;
}

class ChainType {

  static const String bitcoin = "BITCOIN";

  static const String ethereum = "ETHEREUM";

  static const String eos = "EOS";

}

class WalletType {

  static const int hd = 0;

  static const int random = 1;

  static const int v3 = 2;
}

class Words {

  static const int twelve = 128;

  static const int fifteen = 160;

  static const int eighteen = 192;

  static const int twentyOne = 224;

  static const int twentyFour = 256;
}

class WalletFrom {

  static const int mnemonic = 0;

  static const int keystore = 1;

  static const int privateKey = 2;

  static const int wif = 3;
}

class ExMetadata {

  int walletFrom;

  int network;

  int segWit;

  int walletType;

  String chainType;

  ExMetadata.fromMap(Map<String, dynamic> map)
      :
        walletFrom = map['walletFrom'],
        walletType = map['walletType'],
        network = map['network'],
        segWit = map['segWit'],
        chainType = map['chainType']
  ;

  Map<String, dynamic> toMap() =>
      {
        'walletFrom': walletFrom,
        'walletType': walletType,
        'network': network,
        'segWit': segWit,
        'chainType': chainType
      };

  @override
  String toString() {
    return 'ExMetadata{walletFrom: $walletFrom, network: $network, segWit: $segWit, walletType: $walletType, chainType: $chainType}';
  }


}

class ExWallet {

  ExMetadata metadata;

  String keystore;

  String address;

  ExWallet.fromMap(Map<String, dynamic> map)
      :
        keystore = map['keystore'],
        address = map['address'],
        metadata = ExMetadata.fromMap(map['metadata'])
  ;

  Map<String, dynamic> toMap() =>
      {
        'keystore': keystore,
        'address': address,
        'metadata': metadata.toMap()
      };

  @override
  String toString() {
    return 'ExWallet{metadata: $metadata, keystore: $keystore, address: $address}';
  }


}