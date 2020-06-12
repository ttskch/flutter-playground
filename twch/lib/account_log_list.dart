import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountLogList extends StatefulWidget {
  String _username;

  AccountLogList(String username) {
    _username = username;
  }

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
        title: Text('Account log list for ${widget._username}')
      ),
      body: Text(widget._username),
    );
  }
}

class AccountLogItem {
  int followerCount;
  DateTime date;
}
