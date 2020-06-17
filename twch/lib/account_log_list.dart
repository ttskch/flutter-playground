import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'twitter-service.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

class AccountLogList extends StatefulWidget {
  final String username;

  AccountLogList({Key key, this.username}) : super(key: key);

  @override
  createState() => AccountLogListState();
}

class AccountLogListState extends State<AccountLogList> {
  List<AccountLogItem> _accountLogItems = [];

  void _load() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      final jsonStrings = prefs.getStringList('accountLogItems/${widget.username}') ?? [];
      _accountLogItems = jsonStrings.map((jsonString) => AccountLogItem.fromJsonString(jsonString)).toList();
    });
  }

  void _save() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('accountLogItems/${widget.username}', _accountLogItems.map((item) => item.toJsonString()).toList());
  }

  void _add(String username) {
    setState(() {
      _accountLogItems.add(AccountLogItem(
        followerCount: TwitterService().getCurrentFollowerCount(username),
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
        if (index < _accountLogItems.length) {
          return ListTile(
            title: Text(DateFormat('yyyy/MM/dd HH:mm:ss').format(_accountLogItems[index].date)),
            trailing: Text('フォロワー数：${_accountLogItems[index].followerCount}'),
          );
        }
        return null; // cannot be void
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Account log list for ${widget.username}')
      ),
      body: _buildList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _add(widget.username),
        tooltip: 'Add account',
        child: Icon(Icons.check),
      ),
    );
  }
}

class AccountLogItem {
  final int followerCount;
  final DateTime date;

  AccountLogItem({this.followerCount, this.date});

  AccountLogItem.fromJsonString(String jsonString) : this(
    followerCount: json.decode(jsonString)['followerCount'],
    date: DateTime.parse(json.decode(jsonString)['date'])
  );

  String toJsonString() {
    return json.encode({'followerCount': followerCount, 'date': date.toString()});
  }
}
