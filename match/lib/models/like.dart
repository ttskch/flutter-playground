import 'package:match/models/user.dart';
import 'package:meta/meta.dart';

class Like {
  final String id;
  final User from;
  final User to;
  DateTime matchedAt;
  final DateTime createdAt;

  Like({
    @required this.id,
    @required this.from,
    @required this.to,
    this.matchedAt,
    @required this.createdAt,
  });
}
