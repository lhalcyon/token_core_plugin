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

  UTXO.fromMap(Map<String, dynamic> map)
      :
        txHash = map['txHash'],
        vout = map['vout'],
        amount = map['amount'],
        address = map['address'],
        scriptPubKey = map['scriptPubKey'],
        derivedPath = map['derivedPath']
  ;

  Map<String, dynamic> toMap() =>
      {
        'txHash': txHash,
        'vout': vout,
        'amount': amount,
        'address': address,
        'scriptPubKey': scriptPubKey,
        'derivedPath': derivedPath,
        'sequence': sequence,
      };


  @override
  String toString() {
    return 'UTXO{txHash: $txHash, vout: $vout, amount: $amount, address: $address, scriptPubKey: $scriptPubKey, derivedPath: $derivedPath, sequence: $sequence}';
  }

}

class UTXOStore {

  List<UTXO> utxos;

  List<Map<String,dynamic>> toList() {
    return utxos.map((u) => u.toMap()).toList();
  }
}