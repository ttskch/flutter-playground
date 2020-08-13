import 'package:flutter/material.dart';
import 'package:match/models/like.dart';
import 'package:match/models/user.dart';
import 'package:match/repositories/like_repository.dart';
import 'package:match/repositories/user_repository.dart';
import 'package:match/widgets/logout_button.dart';
import 'package:match/widgets/profile_image.dart';
import 'package:match/widgets/settings_button.dart';
import 'package:match/widgets/spinner.dart';
import 'package:match/widgets/waitable_flat_button.dart';

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
  bool _alreadyLiked = false;
  int _likesCount = 0;
  bool _waiting = true;

  @override
  void initState() {
    super.initState();

    () async {
      final User me = await UserRepository().getMe();

      LikeRepository().list(widget.user, (List<Like> likes) {
        _alreadyLiked = likes.where((like) => like.from.id == me.id).length > 0;
        _likesCount = likes.length;
        _waiting = false;
        if (mounted) {
          setState(() => null);
        }
      });
    }();
  }

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
      body: _waiting ? Spinner() : _buildContent(),
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
      builder: (BuildContext context) => WaitableFlatButton(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _alreadyLiked ? Icons.favorite : Icons.favorite_border,
              color: Colors.red,
            ),
            Container(
              margin: EdgeInsets.only(left: 4.0),
              child: Text(_likesCount.toString()),
            ),
          ],
        ),
        onPressed: _alreadyLiked
            ? null
            : () async {
                await LikeRepository().create(widget.user);
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text('いいねを送信しました'),
                ));
              },
      ),
    );
  }
}
