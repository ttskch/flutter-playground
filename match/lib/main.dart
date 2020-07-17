import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'match',
      home: Scaffold(
        appBar: AppBar(
          title: Text('match'),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Firestore.instance.collection('test').add({
              'content': 'test',
              'createdAt': FieldValue.serverTimestamp(),
            });
          },
        ),
        body: Center(
          child: Text('match'),
        ),
      ),
    );
  }
}
