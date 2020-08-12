import 'package:flutter/material.dart';
import 'package:match/models/user.dart';
import 'package:match/widgets/logout_button.dart';
import 'package:match/widgets/settings_button.dart';

class UserShow extends StatefulWidget {
  @override
  createState() => _UserShowState();

  UserShow({
    Key key,
    @required this.user,
  }) : super(key: key);

  final User user;
}

class _UserShowState extends State<UserShow> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.user.fullName),
        actions: <Widget>[
          LogoutButton(),
          SettingsButton(),
        ],
      ),
      body: _buildContent(),
    );
  }

  Widget _buildContent() {
    return Text(widget.user.fullName);
  }
}
