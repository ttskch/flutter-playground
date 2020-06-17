import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'twitter-service.dart';
import 'dart:convert';

class AccountLogList extends StatefulWidget {
  final String username;

  AccountLogList({Key key, this.username}) : super(key: key);

  @override
  createState() => AccountLogListState();
}

class AccountLogListState extends State<AccountLogList> {
  List<String> _accountLogItems = [];

  void _load() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() => _accountLogItems = (prefs.getStringList('accountLogItems/${widget.username}')) ?? []);
  }

  void _save() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('accountLogItems/${widget.username}', _accountLogItems);
  }

  void _add(String username) {
    setState(() {
      _accountLogItems.add(json.encode({
        'followerCount': TwitterService().getCurrentFollowerCount(username),
        'date': DateTime.now().toString(),
      }));
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
            title: Text(json.decode(_accountLogItems[index])['date']),
            trailing: Text('${json.decode(_accountLogItems[index])["followerCount"]}'),
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
}
