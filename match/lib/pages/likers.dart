import 'package:flutter/material.dart';
import 'package:match/models/user.dart';
import 'package:match/repositories/user_repository.dart';
import 'package:match/services/user_criteria.dart';
import 'package:match/widgets/logout_button.dart';
import 'package:match/widgets/profile_image.dart';
import 'package:match/widgets/settings_button.dart';
import 'package:match/widgets/spinner.dart';

class Likers extends StatefulWidget {
  @override
  createState() => _LikersState();
}

class _LikersState extends State<Likers> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('受け取ったいいね一覧'),
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
    return UserRepository().list(criteria: UserCriteria(onlyLikers: true));
  }
}
