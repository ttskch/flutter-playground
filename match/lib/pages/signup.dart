import 'package:flutter/material.dart';
import 'package:match/services/auth.dart';

class Signup extends StatefulWidget {
  @override
  createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  bool _waiting = false;
  String _error = '';

  String _email;
  String _password;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('新規ユーザー登録')),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Center(
          child: _waiting ? CircularProgressIndicator() : _buildLoginForm(),
        ),
      ),
    );
  }

  Widget _buildLoginForm() {
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
                    child: Text('登録'),
                    onPressed: () async {
                      final form = _formKey.currentState;
                      _error = '';
                      if (form.validate()) {
                        form.save();
                        setState(() => _waiting = true);
                        try {
                          await Auth().signupWithEmailAndPassword(
                            email: _email,
                            password: _password,
                          );
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              '/register', (route) => false);
                        } on InvalidEmailException {
                          setState(() => _error = '有効なメールアドレスを入力してください');
                        } on WeakPasswordException {
                          setState(() => _error = 'パスワードは6文字以上にしてください');
                        } on EmailAlreadyInUseException {
                          setState(() => _error = 'そのメールアドレスはすでに登録されています');
                        } finally {
                          setState(() => _waiting = false);
                        }
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
