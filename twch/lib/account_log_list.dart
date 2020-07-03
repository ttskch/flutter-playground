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

  void _add() async {
    int followerCount =
        await TwitterService().getCurrentFollowerCount(widget.username);
    setState(() {
      _accountLogs.add(AccountLog(
        followerCount: followerCount,
        date: DateTime.now(),
      ));
    });
    _save();
  }

  void _remove(int index) {
    setState(() {
      _accountLogs.removeAt(index);
      _save();
    });
  }

  void _removeAll() {
    setState(() {
      _accountLogs = [];
      _save();
    });
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
            title: Text(
                'フォロワー数：${_accountLogs.reversed.toList()[index].followerCount}'),
            subtitle: Text(DateFormat('yyyy/MM/dd HH:mm:ss')
                .format(_accountLogs.reversed.toList()[index].date)),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              color: Colors.red[500],
              onPressed: () => _promptRemove(index),
            ),
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
      floatingActionButton: Row(mainAxisSize: MainAxisSize.min, children: [
        Container(
            margin: EdgeInsets.only(right: 12),
            child: FloatingActionButton(
              heroTag: 'clear',
              onPressed: () => _removeAll(),
              tooltip: 'Clear',
              child: Icon(Icons.delete),
              backgroundColor: Colors.red[500],
            )),
        FloatingActionButton(
          heroTag: 'earn_log',
          onPressed: () => _add(),
          tooltip: 'Earn log',
          child: Icon(Icons.check),
        )
      ]),
    );
  }

  void _promptRemove(int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text('Remove account log?'),
              actions: <Widget>[
                FlatButton(
                    child: Text('CANCEL'),
                    onPressed: () => Navigator.of(context).pop() // Close dialog
                    ),
                FlatButton(
                    child: Text('REMOVE'),
                    onPressed: () {
                      _remove(index);
                      Navigator.of(context).pop(); // Close dialog
                    })
              ]);
        });
  }
}
