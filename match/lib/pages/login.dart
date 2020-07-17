import 'package:flutter/material.dart';
import 'package:match/services/auth.dart';

class Login extends StatefulWidget {
  @override
  createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _loggingIn = false;
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
          child: _loggingIn ? CircularProgressIndicator() : _buildLoginForm(),
        ),
      ),
    );
  }

  Widget _buildLoginForm() {
    return Container(
      padding: EdgeInsets.only(left: 16.0, right: 16.0),
      child: ListView(
        children: [
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
                      if (form.validate()) {
                        form.save();
                        setState(() => _loggingIn = true);
                        if (await Auth.loginWithEmailAndPassword(
                              email: _email,
                              password: _password,
                            ) !=
                            null) {
                          // Navigator.of(context).pushReplacementNamed('/home');
                        } else {
                          setState(() => _loggingIn = false);
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
              child: Text('または'),
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
                  setState(() => _loggingIn = true);
                  if (await Auth.loginWithTwitter() != null) {
                    // Navigator.of(context).pushReplacementNamed('/home');
                  } else {
                    setState(() => _loggingIn = false);
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
