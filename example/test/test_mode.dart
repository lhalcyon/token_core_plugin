class TestBean {
  String name;

  int age;

  Map<String, dynamic> toJson() => {
    'name': name,
    'age': age,
  };



}