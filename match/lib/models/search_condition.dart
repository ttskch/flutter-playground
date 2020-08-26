import 'package:match/models/user.dart';
import 'package:meta/meta.dart';

class SearchCondition {
  SearchCondition({
    @required this.id,
    @required this.owner,
    this.gender,
    this.minAge,
    this.maxAge,
    this.query,
    @required this.updatedAt,
  });

  final String id;
  final User owner;
  Gender gender;
  int minAge;
  int maxAge;
  String query;
  final DateTime updatedAt;
}
