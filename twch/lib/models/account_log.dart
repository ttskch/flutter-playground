import 'dart:convert';

class AccountLog {
  final String id;
  final int followerCount;
  final DateTime dateTime;

  AccountLog({this.id, this.followerCount, this.dateTime});

  AccountLog.fromJsonString(String jsonString)
      : this(
            followerCount: json.decode(jsonString)['followerCount'],
            dateTime: DateTime.parse(json.decode(jsonString)['dateTime']));

  String toJsonString() {
    return json
        .encode({'followerCount': followerCount, 'date': dateTime.toString()});
  }
}
