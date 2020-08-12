import 'package:flutter/material.dart';
import 'package:match/models/user.dart';
import 'package:match/repositories/user_repository.dart';
import 'package:match/widgets/logout_button.dart';
import 'package:match/widgets/settings_button.dart';
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
          SettingsButton(),
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
            childAspectRatio: 0.65,
            children: ss.data.map(_buildTile).toList(),
          ),
        );
      },
    );
  }

  Widget _buildTile(User user) {
    return Column(
      children: <Widget>[
        Container(
          child: AspectRatio(
            aspectRatio: 1,
            child: Image.network(
              user.imageUrl ?? 'https://via.placeholder.com/500',
              fit: BoxFit.cover,
            ),
          ),
        ),
        Text('${user.fullName} (${user.age})'),
        Text(user.selfIntroduction, overflow: TextOverflow.ellipsis),
      ],
    );
  }

  Future<List<User>> _getSearchedUsers() async {
    Gender targetGender = (await UserRepository().getMe()).gender == Gender.Man
        ? Gender.Woman
        : Gender.Man;
    return UserRepository().list(targetGender, (users) => null);
  }
}
