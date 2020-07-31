import 'package:flutter/material.dart';
import 'package:match/models/user.dart';
import 'package:match/repositories/user_repository.dart';
import 'package:match/widgets/logout_button.dart';
import 'package:match/widgets/spinner.dart';

class Home extends StatefulWidget {
  @override
  createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HOME'),
        actions: <Widget>[
          LogoutButton(),
        ],
      ),
      body: _buildGrid(),
    );
  }

  Widget _buildGrid() {
    return FutureBuilder(
      future: _getSearchedUsers(),
      builder: (BuildContext context, AsyncSnapshot<List<User>> ss) {
        if (ss.connectionState != ConnectionState.done) {
          return Spinner();
        }
        return Container(
          padding: EdgeInsets.all(5.0),
          child: GridView.count(
            mainAxisSpacing: 5.0,
            crossAxisSpacing: 5.0,
            scrollDirection: Axis.vertical,
            crossAxisCount: 2,
            children: ss.data.map(_buildTile).toList(),
          ),
        );
      },
    );
  }

  Widget _buildTile(User user) {
    return Container(
      child: Center(
        child: Text(user.fullName),
      ),
      color: Colors.red,
    );
  }

  Future<List<User>> _getSearchedUsers() async {
    Gender targetGender = (await UserRepository().getMe()).gender;
    return UserRepository().list(targetGender, (users) => null);
  }
}
