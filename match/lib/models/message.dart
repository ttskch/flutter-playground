import 'package:match/models/user.dart';
import 'package:meta/meta.dart';

class Message {
  Message({
    @required this.id,
    @required this.from,
    @required this.to,
    @required this.body,
    this.isRead = false,
    @required this.createdAt,
  });

  final String id;
  final User from;
  final User to;
  final String body;
  bool isRead;
  final DateTime createdAt;
}
