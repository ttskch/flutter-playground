import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'twitter-service.dart';

class AccountLogList extends StatefulWidget {
  final String username;

  AccountLogList({Key key, this.username}) : super(key: key);

  @override
  createState() => AccountLogListState();
}

class AccountLogListState extends State<AccountLogList> {
  List<AccountLogItem> _accountLogItems = [];

  void _add(String username) {
    setState(() {
      _accountLogItems.add(AccountLogItem(
        followerCount: TwitterService().getCurrentFollowerCount(username),
        date: DateTime.now()
      ));
    });
  }

  @override
  void initState() {
    super.initState();
  }

  Widget _buildList() {
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        if (index < _accountLogItems.length) {
          return ListTile(
            title: Text(_accountLogItems[index].date.toString()),
            trailing: Text('${_accountLogItems[index].followerCount}'),
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
