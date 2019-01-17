import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:token_core_plugin/model/ex_identity.dart';

void main() {
  test('json convert test', () {
    var encoded = jsonEncode([
      1,
      2,
      {"a": null}
    ]);
    var decoded = jsonDecode('["foo", { "bar": 499 }]');
    var tmp = decoded[1];
    print(tmp);
  });

  test('json real test', () {
    var json = '{"wallets":[{"address":"0xffbbb","keystore":"inner 123","metadata":{"network":1,"segwit":2}}],"keystore":"123"}';

    Map<String, dynamic> map = jsonDecode(json);
    print(map);

    var identity = ExIdentity.fromMap(map);

    print(identity);
  });
}
