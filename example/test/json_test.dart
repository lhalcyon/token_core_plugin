import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:token_core_plugin/model/ex_identity.dart';
import 'package:token_core_plugin_example/util/log.dart';

import 'test_mode.dart';

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
    TestBean m = TestBean();
    m.name = "zhangsan";
    m.age = 25;
    print(m.toMap());
    Log.i(m);
  });
}
