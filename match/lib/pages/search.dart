import 'package:flutter/material.dart';
import 'package:match/models/user.dart';
import 'package:match/repositories/user_repository.dart';
import 'package:match/services/user_criteria.dart';
import 'package:match/widgets/spinner.dart';
import 'package:match/widgets/waitable_raised_button.dart';

class Search extends StatefulWidget {
  @override
  createState() => _SearchState();
}

class _SearchState extends State<Search> {
  Gender _gender;
  int _minAge;
  int _maxAge;
  String _query;
  bool _waiting = true;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    () async {
      // TODO: 保存されている検索条件を取得.

      _waiting = false;

      if (mounted) {
        setState(() => null);
      }
    }();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('検索条件'),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: _waiting ? Spinner() : _buildForm(),
      ),
    );
  }

  Widget _buildForm() {
    return Container(
      padding: EdgeInsets.only(left: 16.0, right: 16.0),
      child: ListView(
        children: [
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
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
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: '年齢（下限）',
                  ),
                  validator: (value) {
                    if (value != '' && int.tryParse(value) == null) {
                      return '数字を入力してください';
                    }
                    return null;
                  },
                  onSaved: (value) => _minAge = int.tryParse(value),
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: '年齢（上限）',
                  ),
                  validator: (value) {
                    if (value != '' && int.tryParse(value) == null) {
                      return '数字を入力してください';
                    }
                    return null;
                  },
                  onSaved: (value) => _maxAge = int.tryParse(value),
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'フリーワード',
                  ),
                  onSaved: (value) => _query = value,
                ),
                Container(
                  margin: EdgeInsets.only(top: 10.0),
                  child: WaitableRaisedButton(
                      child: Text('検索'),
                      onPressed: () async {
                        final form = _formKey.currentState;
                        if (form.validate()) {
                          form.save();
                          final List<User> users = await UserRepository().list(
                            criteria: UserCriteria(
                              gender: _gender ??
                                  (await UserRepository().getMe())
                                      .oppositeGender,
                              minAge: _minAge,
                              maxAge: _maxAge,
                              query: _query,
                            ),
                          );
                          Navigator.of(context).pushNamedAndRemoveUntil(
                            '/home/searched',
                            (_) => false, // 新しい画面をpushしない.
                            arguments: users,
                          );
                        }
                      }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
