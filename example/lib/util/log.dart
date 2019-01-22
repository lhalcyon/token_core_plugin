import 'dart:convert';

class Log {
  static void i(Object object) {
    var type = object.runtimeType;
    print('print object type: $type');
//    var jsonStr = jsonDecode(object);
    if (object is Map) {
      print(object);
      for (var i = 0; i < object.keys.length; i++) {
        var key = object.keys.elementAt(i);
        var value = object[key];
        print("$key : $value");
      }
    } else {
      print(object);
    }
  }
}
