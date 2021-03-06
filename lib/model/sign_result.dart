class SignResult {
  String signedTx;

  String txHash;

  String wtxID;

  SignResult({this.signedTx, this.txHash, this.wtxID});

  SignResult.fromJson(Map<String, dynamic> map)
      : signedTx = map['signedTx'],
        txHash = map['txHash'];

  Map<String, dynamic> toJson() => {
        'signedTx': signedTx,
        'txHash': txHash,
        'wtxID': wtxID,
      };

  @override
  String toString() {
    return 'SignResult{signedTx: $signedTx, txHash: $txHash, wtxID: $wtxID}';
  }
}
