import 'package:flutter/material.dart';
import 'package:match/models/user.dart';
import 'package:match/repositories/user_repository.dart';
import 'package:match/services/user_criteria.dart';
import 'package:match/widgets/likers_button.dart';
import 'package:match/widgets/logout_button.dart';
import 'package:match/widgets/matchers_button.dart';
import 'package:match/widgets/profile_image.dart';
import 'package:match/widgets/settings_button.dart';
import 'package:match/widgets/spinner.dart';

class Home extends StatefulWidget {
  @override
  createState() => _HomeState();

  Home({
    Key key,
    this.users,
  }) : super(key: key);

  final List<User> users;
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
          LikersButton(),
          MatchersButton(),
        ],
      ),
      body: _build(),
    );
  }

  Widget _build() {
    return widget.users != null
        ? _buildGrid(widget.users)
        : FutureBuilder(
            future: _getSearchedUsers(),
            builder: (BuildContext context, AsyncSnapshot<List<User>> ss) {
              if (ss.connectionState != ConnectionState.done) {
                return Spinner();
              }
              return _buildGrid(ss.data);
            },
          );
  }

  Widget _buildGrid(List<User> users) {
    return ListView(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: RaisedButton(
            child: Icon(Icons.search),
            onPressed: () => Navigator.of(context).pushNamed('/search'),
          ),
        ),
        Container(
          padding: EdgeInsets.all(5.0),
          child: GridView.count(
            shrinkWrap: true,
            mainAxisSpacing: 5.0,
            crossAxisSpacing: 5.0,
            scrollDirection: Axis.vertical,
            crossAxisCount: 2,
            childAspectRatio: 0.65,
            children: users.map(_buildTile).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildTile(User user) {
    return GestureDetector(
      onTap: () =>
          Navigator.of(context).pushNamed('/user/show', arguments: user),
      child: Column(
        children: [
          Container(
            child: AspectRatio(
              aspectRatio: 1,
              child: ProfileImage(user: user),
            ),
          ),
          Text('${user.fullName} (${user.age})'),
          Text(user.selfIntroduction, overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }

  Future<List<User>> _getSearchedUsers() async {
    return UserRepository().list(
        criteria: UserCriteria(
            gender: (await UserRepository().getMe()).oppositeGender));
  }
}
