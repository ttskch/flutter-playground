import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:match/models/user.dart';
import 'package:match/repositories/user_repository.dart';
import 'package:match/services/storage.dart';
import 'package:match/widgets/logout_button.dart';
import 'package:match/widgets/spinner.dart';

class Home extends StatefulWidget {
  @override
  createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HOME'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.file_upload),
            onPressed: () async => Storage()
                .upload(await FilePicker.getFile(type: FileType.image)),
          ),
          LogoutButton(),
        ],
      ),
      body: _buildGrid(),
    );
  }

  Widget _buildGrid() {
    return FutureBuilder(
      future: _getSearchedUsers(),
      builder: (BuildContext context, AsyncSnapshot<List<User>> ss) {
        if (ss.connectionState != ConnectionState.done) {
          return Spinner();
        }
        return Container(
          padding: EdgeInsets.all(5.0),
          child: GridView.count(
            mainAxisSpacing: 5.0,
            crossAxisSpacing: 5.0,
            scrollDirection: Axis.vertical,
            crossAxisCount: 2,
            childAspectRatio: 0.65,
            children: ss.data.map(_buildTile).toList(),
          ),
        );
      },
    );
  }

  Widget _buildTile(User user) {
    return Column(
      children: <Widget>[
        Image.network('https://via.placeholder.com/500'),
        Text('${user.fullName} (${user.age})'),
        Text(user.selfIntroduction, overflow: TextOverflow.ellipsis),
      ],
    );
  }

  Future<List<User>> _getSearchedUsers() async {
    Gender targetGender = (await UserRepository().getMe()).gender;
    return UserRepository().list(targetGender, (users) => null);
  }
}
