import 'package:match/models/user.dart';
import 'package:meta/meta.dart';

class Message {
  final String id;
  final User from;
  final User to;
  final Message replyTo;
  String body;
  bool isRead;
  final DateTime createdAt;

  Message({
    @required this.id,
    @required this.from,
    @required this.to,
    this.replyTo,
    @required this.body,
    this.isRead = false,
    @required this.createdAt,
  });
}
