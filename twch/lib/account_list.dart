import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'account_log_list.dart';
import 'models/account.dart';
import 'services/storage.dart';

class AccountList extends StatefulWidget {
  @override
  createState() => _AccountListState();
}

class _AccountListState extends State<AccountList> {
  List<Account> _accounts = [];

  void _load() {
    Storage.getAccounts((List<Account> accounts) {
      if (mounted) {
        setState(() => _accounts = accounts);
      }
    });
  }

  void _add(String username) {
    if (username.length > 0) {
      Storage.addAccount(username);
    }
  }

  void _remove(Account account) {
    Storage.deleteAccount(account);
  }

  Widget _buildList() {
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        if (index < _accounts.length) {
          return _buildItem(_accounts[index]);
        }
        return null; // cannot be void
      },
    );
  }

  Widget _buildItem(Account account) {
    return ListTile(
      title: Text(account.username),
      subtitle:
          Text(DateFormat('yyyy/MM/dd HH:mm:ss').format(account.createdAt)),
      trailing: IconButton(
        icon: Icon(Icons.delete),
        color: Colors.red[500],
        onPressed: () => _promptRemove(account),
      ),
      onTap: () => _pushAccountLogListScreen(account),
    );
  }

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Account list')),
      body: _buildList(),
      floatingActionButton: FloatingActionButton(
        onPressed: _pushAddScreen,
        tooltip: 'Add account',
        child: Icon(Icons.add),
      ),
    );
  }

  void _pushAddScreen() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (BuildContext context) {
        return Scaffold(
          appBar: AppBar(title: Text('Add account')),
          body: TextField(
            autofocus: true,
            onSubmitted: (val) {
              _add(val);
              Navigator.pop(context); // Close screen
            },
            decoration: InputDecoration(
              hintText: 'username',
              contentPadding: const EdgeInsets.all(16.0),
            ),
          ),
        );
      }),
    );
  }

  void _promptRemove(Account account) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Remove account "${account.username}"?'),
            actions: <Widget>[
              FlatButton(
                child: Text('CANCEL'),
                onPressed: () => Navigator.of(context).pop(), // Close dialog
              ),
              FlatButton(
                child: Text('REMOVE'),
                onPressed: () {
                  _remove(account);
                  Navigator.of(context).pop(); // Close dialog
                },
              ),
            ],
          );
        });
  }

  void _pushAccountLogListScreen(Account account) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      return AccountLogList(account: account);
    }));
  }
}
