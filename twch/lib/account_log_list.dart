import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountLogList extends StatefulWidget {
  final String username;

  AccountLogList({Key key, this.username}) : super(key: key);

  @override
  createState() => AccountLogListState();
}

class AccountLogListState extends State<AccountLogList> {
  List<AccountLogItem> _accountLogs = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Account log list for ${widget.username}')
      ),
      body: Text(widget.username),
    );
  }
}

class AccountLogItem {
  int followerCount;
  DateTime date;
}
