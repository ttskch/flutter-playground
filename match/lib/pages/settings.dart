import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:match/models/user.dart';
import 'package:match/repositories/user_repository.dart';
import 'package:match/services/auth.dart';
import 'package:match/services/storage.dart';
import 'package:match/widgets/profile_image.dart';
import 'package:match/widgets/spinner.dart';

class Settings extends StatefulWidget {
  @override
  createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool _newbie;
  User _me;
  File _previewingImageFile;
  bool _waiting = true;
  bool _saving = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    () async {
      _me = await UserRepository().getMe();

      if (_me == null) {
        _newbie = true;
        _me = User(
          id: await Auth().getCurrentUserId(),
          fullName: null,
          gender: null,
          age: null,
          createdAt: null,
        );
      } else {
        _newbie = false;
      }

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
        title: Text('ユーザー情報'),
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
          Container(
            margin: EdgeInsets.only(top: 16.0),
            child: GestureDetector(
              child: Center(
                child: Container(
                  width: 200,
                  height: 200,
                  child: _previewingImageFile != null
                      ? Image.file(
                          _previewingImageFile,
                          fit: BoxFit.cover,
                        )
                      : ProfileImage(user: _me),
                ),
              ),
              onTap: () async {
                _previewingImageFile =
                    await FilePicker.getFile(type: FileType.image);
                setState(() => null);
              },
            ),
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
                  onSaved: (value) => _me.fullName = value,
                  initialValue: _me.fullName,
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
                  value: _me.gender,
                  onChanged: (value) => null,
                  onSaved: (value) => _me.gender = value,
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
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
                  onSaved: (value) => _me.age = int.parse(value),
                  initialValue: _me.age != null ? _me.age.toString() : '',
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: '自己紹介文',
                  ),
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  onSaved: (value) => _me.selfIntroduction = value,
                  initialValue: _me.selfIntroduction,
                ),
                Builder(
                  builder: (BuildContext context) => Container(
                    margin: EdgeInsets.only(top: 10.0),
                    child: RaisedButton(
                      child: Text('保存'),
                      onPressed: _saving
                          ? null
                          : () async {
                              setState(() => _saving = true);

                              final form = _formKey.currentState;
                              if (form.validate()) {
                                form.save();
                                if (_newbie) {
                                  await UserRepository().create(
                                    fullName: _me.fullName,
                                    gender: _me.gender,
                                    age: _me.age,
                                    selfIntroduction: _me.selfIntroduction,
                                    imageUrl: await Storage()
                                        .upload(_previewingImageFile),
                                  );
                                  Navigator.of(context)
                                      .pushReplacementNamed('/home');
                                } else {
                                  _me.imageUrl = await Storage()
                                      .upload(_previewingImageFile);
                                  await UserRepository().update(_me);
                                  Scaffold.of(context).showSnackBar(SnackBar(
                                    content: Text('ユーザー情報を変更しました'),
                                  ));
                                }

                                setState(() => _saving = false);
                              }
                            },
                    ),
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
