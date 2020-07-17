import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:match/services/auth.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'match',
      home: Scaffold(
        appBar: AppBar(
          title: Text('match'),
        ),
        floatingActionButton: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: EdgeInsets.only(right: 12),
              child: FloatingActionButton(
                heroTag: 'login',
                child: Icon(Icons.person),
                onPressed: () async => print(
                  await Auth.loginWithEmailAndPassword(
                    email: 'test@test.com',
                    password: 'testtest',
                  ),
                ),
              ),
            ),
            FloatingActionButton(
              heroTag: 'add',
              child: Icon(Icons.add),
              onPressed: () {
                Firestore.instance.collection('test').add({
                  'content': 'test',
                  'createdAt': FieldValue.serverTimestamp(),
                });
              },
            ),
          ],
        ),
        body: Center(
          child: Text('match'),
        ),
      ),
    );
  }
}
