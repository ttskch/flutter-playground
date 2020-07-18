import 'package:flutter/material.dart';
import 'package:match/services/auth.dart';

class Login extends StatefulWidget {
  @override
  createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _waiting = false;
  String _error = '';

  String _email;
  String _password;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('ログイン')),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Center(
          child: _waiting ? CircularProgressIndicator() : _buildForm(),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Container(
      padding: EdgeInsets.only(left: 16.0, right: 16.0),
      child: ListView(
        children: [
          Container(
            child: _error.isNotEmpty
                ? Container(
                    margin: EdgeInsets.only(top: 28.0, bottom: 8.0),
                    child: Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(right: 4.0),
                          child: Icon(
                            Icons.error,
                            color: Colors.red,
                            size: 16.0,
                          ),
                        ),
                        Text(_error, style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  )
                : null,
          ),
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'メールアドレス',
                  ),
                  validator: (value) =>
                      value.isEmpty ? 'メールアドレスが入力されていません' : null,
                  onSaved: (value) => _email = value,
                  initialValue: _email,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'パスワード',
                  ),
                  obscureText: true,
                  validator: (value) =>
                      value.isEmpty ? 'パスワードが入力されていません' : null,
                  onSaved: (value) => _password = value,
                ),
                Container(
                  margin: EdgeInsets.only(top: 10.0),
                  child: RaisedButton(
                    child: Text('ログイン'),
                    onPressed: () async {
                      final form = _formKey.currentState;
                      _error = '';
                      if (form.validate()) {
                        form.save();
                        setState(() => _waiting = true);
                        try {
                          await Auth().loginWithEmailAndPassword(
                            email: _email,
                            password: _password,
                          );
                          // Navigator.of(context).pushReplacementNamed('/home');
                        } catch (e) {
                          setState(() {
                            _waiting = false;
                            _error = 'メールアドレスかパスワードが間違っています';
                          });
                        }
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          Center(
            child: Container(
              padding: EdgeInsets.only(top: 28.0, bottom: 28.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FlatButton(
                    child: Text('新規ユーザー登録'),
                    onPressed: () => Navigator.of(context).pushNamed('/signup'),
                  ),
                  Text('または'),
                ],
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              RaisedButton(
                child: Text('Twitterでログイン'),
                color: Colors.blue,
                textColor: Colors.white,
                onPressed: () async {
                  setState(() => _waiting = true);
                  if (await Auth().loginWithTwitter() != null) {
                    // Navigator.of(context).pushReplacementNamed('/home');
                  } else {
                    setState(() => _waiting = false);
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
