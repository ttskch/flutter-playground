import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:match/pages/login.dart';
import 'package:match/services/auth.dart';

void main() async {
  await DotEnv().load('.env');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'match',
      initialRoute: '/',
      routes: {
        '/': (BuildContext context) => Login(),
      },
      // home: Scaffold(
      //   appBar: AppBar(
      //     title: Text('match'),
      //   ),
      //   floatingActionButton: Row(
      //     mainAxisSize: MainAxisSize.min,
      //     children: [
      //       Container(
      //         margin: EdgeInsets.only(right: 12),
      //         child: FloatingActionButton(
      //           heroTag: 'login_with_email',
      //           child: Icon(Icons.email),
      //           onPressed: () async => print(
      //             await Auth.loginWithEmailAndPassword(
      //               email: 'test@test.com',
      //               password: 'testtest',
      //             ),
      //           ),
      //         ),
      //       ),
      //       Container(
      //         margin: EdgeInsets.only(right: 12),
      //         child: FloatingActionButton(
      //           heroTag: 'login_with_twitter',
      //           child: Text('Tw'),
      //           onPressed: () async => print(
      //             await Auth.loginWithTwitter(),
      //           ),
      //         ),
      //       ),
      //       FloatingActionButton(
      //         heroTag: 'add',
      //         child: Icon(Icons.add),
      //         onPressed: () {
      //           Firestore.instance.collection('test').add({
      //             'content': 'test',
      //             'createdAt': FieldValue.serverTimestamp(),
      //           });
      //         },
      //       ),
      //     ],
      //   ),
      //   body: Center(
      //     child: Text('match'),
      //   ),
      // ),
    );
  }
}
