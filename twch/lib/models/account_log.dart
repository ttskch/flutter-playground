import 'dart:convert';

class AccountLog {
  final int followerCount;
  final DateTime date;

  AccountLog({this.followerCount, this.date});

  AccountLog.fromJsonString(String jsonString)
      : this(
            followerCount: json.decode(jsonString)['followerCount'],
            date: DateTime.parse(json.decode(jsonString)['date']));

  String toJsonString() {
    return json
        .encode({'followerCount': followerCount, 'date': date.toString()});
  }
}
