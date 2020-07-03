import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'models/account_log.dart';
import 'services/twitter_service.dart';

class AccountLogList extends StatefulWidget {
  final String username;

  AccountLogList({Key key, this.username}) : super(key: key);

  @override
  createState() => _AccountLogListState();
}

class _AccountLogListState extends State<AccountLogList> {
  List<AccountLog> _accountLogs = [];

  void _load() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      final jsonStrings =
          prefs.getStringList('accountLogs/${widget.username}') ?? [];
      _accountLogs = jsonStrings
          .map((jsonString) => AccountLog.fromJsonString(jsonString))
          .toList();
    });
  }

  void _save() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('accountLogs/${widget.username}',
        _accountLogs.map((item) => item.toJsonString()).toList());
  }

  void _add(String username) async {
    int followerCount =
        await TwitterService().getCurrentFollowerCount(username);
    setState(() {
      _accountLogs.add(AccountLog(
        followerCount: followerCount,
        date: DateTime.now(),
      ));
    });
    _save();
  }

  @override
  void initState() {
    super.initState();
    _load();
  }

  Widget _buildList() {
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        if (index < _accountLogs.length) {
          return ListTile(
            title: Text(DateFormat('yyyy/MM/dd HH:mm:ss')
                .format(_accountLogs.reversed.toList()[index].date)),
            trailing: Text(
                'フォロワー数：${_accountLogs.reversed.toList()[index].followerCount}'),
          );
        }
        return null; // cannot be void
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Account log list for ${widget.username}')),
      body: _buildList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _add(widget.username),
        tooltip: 'Add account',
        child: Icon(Icons.check),
      ),
    );
  }
}
