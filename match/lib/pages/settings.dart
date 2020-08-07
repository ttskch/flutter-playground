import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:match/models/user.dart';
import 'package:match/repositories/user_repository.dart';
import 'package:match/services/auth.dart';
import 'package:match/services/storage.dart';
import 'package:match/widgets/waitable_button.dart';
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
      setState(() => null);
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
                  width: 150,
                  height: 150,
                  child: _previewingImageFile != null
                      ? Image.file(
                          _previewingImageFile,
                          fit: BoxFit.cover,
                        )
                      : _me.imageUrl != null
                          ? Image.network(
                              _me.imageUrl,
                              fit: BoxFit.cover,
                            )
                          : Image.network(
                              'https://via.placeholder.com/150',
                              fit: BoxFit.cover,
                            ),
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
                Container(
                  margin: EdgeInsets.only(top: 10.0),
                  child: WaitableButton(
                    label: '保存',
                    onPressed: () async {
                      final form = _formKey.currentState;
                      if (form.validate()) {
                        form.save();
                        if (_newbie) {
                          await UserRepository().create(
                            fullName: _me.fullName,
                            gender: _me.gender,
                            age: _me.age,
                            selfIntroduction: _me.selfIntroduction,
                            imageUrl:
                                await Storage().upload(_previewingImageFile),
                          );
                          Navigator.of(context).pushReplacementNamed('/home');
                        } else {
                          _me.imageUrl =
                              await Storage().upload(_previewingImageFile);
                          await UserRepository().update(_me);
                          Fluttertoast.showToast(
                            msg: 'ユーザー情報を更新しました',
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.BOTTOM,
                            backgroundColor: Colors.green,
                          );
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
