import 'package:flutter/material.dart';
import 'package:match/models/message.dart';
import 'package:match/models/user.dart';
import 'package:match/repositories/message_repository.dart';
import 'package:match/repositories/user_repository.dart';
import 'package:match/widgets/profile_image.dart';
import 'package:match/widgets/spinner.dart';

class Messaging extends StatefulWidget {
  @override
  createState() => _MessagingState();

  Messaging({
    Key key,
    @required this.user,
  }) : super(key: key);

  final User user;
}

class _MessagingState extends State<Messaging> {
  List<Message> _messages = [];
  String _body = '';
  bool _waiting = true;

  @override
  void initState() {
    super.initState();

    () async {
      final User me = await UserRepository().getMe();

      MessageRepository().listen(me, widget.user, (messages) {
        _messages = messages;
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
        title: Text('${widget.user.fullName}さんとのメッセージ'),
      ),
      // TODO: body全体をGestureDetectorでラップしてしまうとbottomSheetも含まれてしまうようで、入力欄タップ直後に常にキーボードが消えてしまう...
      // body: GestureDetector(
      //   onTap: () => FocusScope.of(context).unfocus(),
      //   child: _waiting ? Spinner() : _buildContent(),
      // ),
      body: _waiting ? Spinner() : _buildContent(),
      bottomSheet: _buildForm(),
    );
  }

  Widget _buildContent() {
    return ListView(
      children: _messages
          .map((message) => ListTile(
                leading: ProfileImage(user: message.from),
                title: Text(message.body),
                subtitle: Container(
                  child: Text(
                    message.createdAt.toString(),
                    style: TextStyle(fontSize: 10.0),
                  ),
                  margin: EdgeInsets.only(top: 12.0),
                ),
              ))
          .toList(),
    );
  }

  Widget _buildForm() {
    return BottomAppBar(
      child: Container(
        padding: EdgeInsets.only(left: 8.0),
        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: 'メッセージを入力',
                ),
                keyboardType: TextInputType.multiline,
                maxLines: null,
                onChanged: (value) => _body = value,
                initialValue: _body,
              ),
            ),
            IconButton(
              icon: Icon(Icons.send),
              onPressed: () {
                // TODO: Formを使ってvalidate/saveする方法をとりたかったけど Multiple widgets used the same GlobalKey エラーの対処法が分からず保留中...
                if (_body.length > 0) {
                  MessageRepository().create(widget.user, _body);
                  setState(() => _body = ''); // 再描画.
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
