import 'dart:convert';

class Account {
  final String id;
  final String username;

  Account({this.id, this.username});

  Account.fromJsonString(String jsonString)
      : this(username: json.decode(jsonString)['username']);

  String toJsonString() {
    return json.encode({'username': username});
  }
}
