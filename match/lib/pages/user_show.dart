import 'package:flutter/material.dart';
import 'package:match/models/like.dart';
import 'package:match/models/user.dart';
import 'package:match/repositories/like_repository.dart';
import 'package:match/repositories/user_repository.dart';
import 'package:match/widgets/likers_button.dart';
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
  Like _likeToMe;
  bool _alreadyMatched = false;
  bool _waiting = true;

  @override
  void initState() {
    super.initState();

    () async {
      final User me = await UserRepository().getMe();

      LikeRepository().listen(
          from: widget.user,
          callback: (List<Like> likes) {
            _likeToMe = likes.firstWhere(
              (like) => like.to.id == me.id,
              orElse: () => _likeToMe = null,
            );
            if (_likeToMe != null && _likeToMe.matchedAt != null) {
              _alreadyMatched = true;
            }
            if (mounted) {
              setState(() => null);
            }
          });

      LikeRepository().listen(
        to: widget.user,
        callback: (List<Like> likes) {
          _alreadyLiked = likes.map((like) => like.from.id).contains(me.id);
          _likesCount = likes.length;
          _waiting = false;
          if (mounted) {
            setState(() => null);
          }
        },
      );
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
          LikersButton(),
        ],
      ),
      body: _waiting ? Spinner() : _buildContent(),
    );
  }

  Widget _buildContent() {
    return ListView(
      children: [
        Container(
          child: _likeToMe == null
              ? null
              : Container(
                  child: Center(
                    child: Text(
                      _likeToMe.matchedAt == null
                          ? 'あなたにいいねしています'
                          : 'マッチングしています',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  color: Colors.redAccent,
                  padding: EdgeInsets.all(5.0),
                ),
        ),
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
              _alreadyLiked || _alreadyMatched
                  ? Icons.favorite
                  : Icons.favorite_border,
              color: Colors.red,
            ),
            Container(
              margin: EdgeInsets.only(left: 4.0),
              child: Text(_likesCount.toString()),
            ),
          ],
        ),
        onPressed: _alreadyLiked || _alreadyMatched
            ? null
            : () {
                if (_likeToMe == null) {
                  _like();
                } else if (_likeToMe.matchedAt == null) {
                  _match();
                }
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text('いいねを送信しました'),
                ));
              },
      ),
    );
  }

  void _like() async {
    await LikeRepository().create(widget.user);
  }

  void _match() async {
    _likeToMe.matchedAt = DateTime.now();
    await LikeRepository().update(_likeToMe);
  }
}
