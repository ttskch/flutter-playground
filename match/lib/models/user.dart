import 'package:meta/meta.dart';

class User {
  User({
    @required this.id,
    @required this.fullName,
    @required this.gender,
    @required this.age,
    this.selfIntroduction,
    this.imageUrl,
    @required this.createdAt,
  });

  final String id;
  String fullName;
  Gender gender;
  int age;
  String selfIntroduction;
  String imageUrl;
  final DateTime createdAt;

  Gender get oppositeGender {
    return gender == Gender.Man ? Gender.Woman : Gender.Man;
  }
}

enum Gender {
  Man,
  Woman,
}
