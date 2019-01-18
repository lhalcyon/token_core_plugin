class UTXO {

  String txHash;

  int vout;

  int amount;

  String address;

  String scriptPubKey;

  String derivedPath;

  int sequence = 4294967295;

  UTXO({this.txHash, this.vout, this.amount, this.address, this.scriptPubKey,
      this.derivedPath, this.sequence});

  @override
  String toString() {
    return 'UTXO{txHash: $txHash, vout: $vout, amount: $amount, address: $address, scriptPubKey: $scriptPubKey, derivedPath: $derivedPath, sequence: $sequence}';
  }


}