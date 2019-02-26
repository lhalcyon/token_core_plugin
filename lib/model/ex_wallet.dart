class Network {
  static const mainNet = "MAINNET";

  static const testNet = "TESTNET";
}

class SegWit {
  static const none = "NONE";

  static const p2wpkh = "P2WPKH";
}

class ChainType {
  static const bitcoin = "BITCOIN";

  static const ethereum = "ETHEREUM";

  static const eos = "EOS";
}

class WalletType {

  static const hd = "HD";

  static const random = "RANDOM";

  static const v3 = "V3";
}

class Words {
  static const int twelve = 128;

  static const int fifteen = 160;

  static const int eighteen = 192;

  static const int twentyOne = 224;

  static const int twentyFour = 256;
}

class WalletFrom {
  static const mnemonic = "MNEMONIC";

  static const keystore = "KEYSTORE";

  static const privateKey = "PRIAVTE_KEY";

  static const wif = "WIF";
}

class ExMetadata {

  String from;

  String network;

  String segWit;

  String chainType;

  ExMetadata.fromMap(Map<String, dynamic> map)
      : from = map['from'],
        network = map['network'],
        segWit = map['segWit'],
        chainType = map['chainType'];

  Map<String, dynamic> toMap() => {
        'walletFrom': from,
        'network': network,
        'segWit': segWit,
        'chainType': chainType
      };

  @override
  String toString() {
    return 'ExMetadata{walletFrom: $from, network: $network, segWit: $segWit, chainType: $chainType}';
  }
}

class ExWallet {
  ExMetadata metadata;

  String keystore;

  String address;

  ExWallet.fromMap(Map<String, dynamic> map)
      : keystore = map['keystore'],
        address = map['address'],
        metadata = ExMetadata.fromMap(map['metadata']);

  Map<String, dynamic> toMap() =>
      {'keystore': keystore, 'address': address, 'metadata': metadata.toMap()};

  @override
  String toString() {
    return 'ExWallet{metadata: $metadata, keystore: $keystore, address: $address}';
  }
}
