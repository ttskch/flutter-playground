import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'models/account.dart';
import 'models/account_log.dart';
import 'services/twitter_service.dart';
import 'services/storage.dart';

class AccountLogList extends StatefulWidget {
  final Account account;

  AccountLogList({Key key, this.account}) : super(key: key);

  @override
  createState() => _AccountLogListState();
}

class _AccountLogListState extends State<AccountLogList> {
  List<AccountLog> _accountLogs = [];

  void _load() {
    Storage.getAccountLogs(widget.account, (List<AccountLog> accountLogs) {
      if (mounted) {
        setState(() => _accountLogs = accountLogs);
      }
    });
  }

  void _add() async {
    final int followerCount =
        await TwitterService().getCurrentFollowerCount(widget.account.username);
    Storage.addAccountLog(
      account: widget.account,
      followerCount: followerCount,
    );
  }

  void _remove(AccountLog accountLog) {
    Storage.deleteAccountLog(accountLog);
  }

  void _removeAll() {
    Storage.deleteAccountLogs(widget.account);
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
                .format(_accountLogs.reversed.toList()[index].createdAt)),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              color: Colors.red[500],
              onPressed: () => _promptRemove(index, _accountLogs[index]),
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
      appBar: AppBar(
          title: Text('Account log list for ${widget.account.username}')),
      body: _buildList(),
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: EdgeInsets.only(right: 12),
            child: FloatingActionButton(
              heroTag: 'clear',
              onPressed: () => _removeAll(),
              tooltip: 'Clear',
              child: Icon(Icons.delete),
              backgroundColor: Colors.red[500],
            ),
          ),
          FloatingActionButton(
            heroTag: 'earn_log',
            onPressed: () => _add(),
            tooltip: 'Earn log',
            child: Icon(Icons.check),
          ),
        ],
      ),
    );
  }

  void _promptRemove(int index, AccountLog accountLog) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Remove account log?'),
          actions: <Widget>[
            FlatButton(
              child: Text('CANCEL'),
              onPressed: () => Navigator.of(context).pop(), // Close dialog
            ),
            FlatButton(
              child: Text('REMOVE'),
              onPressed: () {
                _remove(accountLog);
                Navigator.of(context).pop(); // Close dialog
              },
            ),
          ],
        );
      },
    );
  }
}
