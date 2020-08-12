import 'package:flutter/material.dart';
import 'package:match/models/user.dart';
import 'package:match/widgets/logout_button.dart';
import 'package:match/widgets/profile_image.dart';
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
    return ListView(
      children: [
        Center(
          child: Container(
            margin: EdgeInsets.only(top: 16.0),
            width: 200,
            height: 200,
            child: ProfileImage(user: widget.user),
          ),
        ),
        Center(
          child: _buildLikeButton(),
        ),
        ListTile(
          leading: Text('氏名'),
          title: Text(widget.user.fullName),
        ),
        ListTile(
          leading: Text('性別'),
          title: Text(widget.user.gender == Gender.Man ? '男性' : '女性'),
        ),
        ListTile(
          leading: Text('年齢'),
          title: Text(widget.user.age.toString()),
        ),
        ListTile(
          leading: Text('自己紹介'),
          title: Text(
            widget.user.selfIntroduction,
          ),
        ),
      ],
    );
  }

  Widget _buildLikeButton() {
    return Builder(
      builder: (BuildContext context) => FlatButton(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.favorite_border,
              color: Colors.red,
            ),
            Container(
              margin: EdgeInsets.only(left: 4.0),
              child: Text('100'),
            ),
          ],
        ),
        onPressed: () {
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text('いいねを送信しました'),
          ));
        },
      ),
    );
  }
}
