import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String appTitle = 'twch';

void main() {
  runApp(TwchApp());
}

class TwchApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appTitle,
      home: AccountList(),
    );
  }
}

class AccountList extends StatefulWidget {
  @override
  createState() => AccountListState();
}

class AccountListState extends State<AccountList> {
  List<String> _usernames = [];

  _load() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() => _usernames = (prefs.getStringList('usernames')) ?? []);
  }

  void _save() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('usernames', _usernames);
  }

  void _add(String username) {
    if (username.length > 0) {
      setState(() {
        _usernames.add(username);
        _save();
      });
    }
  }

  void _remove(int index) {
    setState(() {
      _usernames.removeAt(index);
      _save();
    });
  }

  Widget _buildList() {
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        if (index < _usernames.length) {
          return _buildItem(_usernames[index], index);
        }
        return null; // cannot be void
      },
    );
  }

  Widget _buildItem(String username, int index) {
    return ListTile(
      title: Text(username),
      onTap: () => _promptRemove(index),
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
      appBar: AppBar(
        title: Text(appTitle)
      ),
      body: _buildList(),
      floatingActionButton: FloatingActionButton(
        onPressed: _pushAddScreen,
        tooltip: 'Add account',
        child: Icon(Icons.add),
      )
    );
  }

  void _pushAddScreen() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Add account')
            ),
            body: TextField(
              autofocus: true,
              onSubmitted: (val) {
                _add(val);
                Navigator.pop(context); // Close screen
              },
              decoration: InputDecoration(
                hintText: 'username',
                contentPadding: const EdgeInsets.all(16.0)
              ),
            )
          );
        }
      )
    );
  }

  void _promptRemove(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Remove account "${_usernames[index]}"?'),
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
              }
            )
          ]
        );
      }
    );
  }
}
