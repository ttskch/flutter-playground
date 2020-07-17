import 'package:meta/meta.dart';

class User {
  final String id;
  String fullName;
  Gender gender;
  int age;
  String selfIntroduction;
  final DateTime createdAt;

  User({
    @required this.id,
    @required this.fullName,
    @required this.gender,
    @required this.age,
    this.selfIntroduction,
    @required this.createdAt,
  });
}

enum Gender {
  Man,
  Woman,
}
