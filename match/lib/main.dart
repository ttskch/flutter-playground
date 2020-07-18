import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:match/pages/login.dart';
import 'package:match/pages/register.dart';
import 'package:match/pages/signup.dart';

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
        '/signup': (BuildContext context) => Signup(),
        '/register': (BuildContext context) => Register(),
      },
    );
  }
}
