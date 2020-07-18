import 'package:flutter/material.dart';
import 'package:match/models/user.dart';
import 'package:match/services/auth.dart';

class Register extends StatefulWidget {
  @override
  createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool _waiting = false;
  String _error = '';

  String _fullName;
  Gender _gender;
  int _age;
  String _selfIntroduction;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('ユーザー情報入力')),
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
                    labelText: '氏名',
                  ),
                  validator: (value) => value.isEmpty ? '入力してください' : null,
                  onSaved: (value) => _fullName = value,
                  initialValue: _fullName,
                ),
                DropdownButtonFormField(
                  decoration: InputDecoration(
                    labelText: '性別',
                  ),
                  items: [
                    DropdownMenuItem(
                      value: Gender.Man,
                      child: Text('男性'),
                    ),
                    DropdownMenuItem(
                      value: Gender.Woman,
                      child: Text('女性'),
                    ),
                  ],
                  value: _gender,
                  onChanged: (value) => null,
                  onSaved: (value) => _gender = value,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: '年齢',
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return '入力してください';
                    }
                    if (int.tryParse(value) == null) {
                      return '数字を入力してください';
                    }
                    return null;
                  },
                  onSaved: (value) => _age = int.parse(value),
                  initialValue: _age != null ? _age.toString() : '',
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: '自己紹介文',
                  ),
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  onSaved: (value) => _selfIntroduction = value,
                  initialValue: _selfIntroduction,
                ),
                Container(
                  margin: EdgeInsets.only(top: 10.0),
                  child: RaisedButton(
                    child: Text('利用を開始する'),
                    onPressed: () async {
                      final form = _formKey.currentState;
                      _error = '';
                      if (form.validate()) {
                        form.save();
                        setState(() => _waiting = true);
                        try {
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
        ],
      ),
    );
  }
}
