import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:match/pages/home.dart';
import 'package:match/pages/login.dart';
import 'package:match/pages/register.dart';
import 'package:match/pages/signup.dart';
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
        '/': (BuildContext context) => FutureBuilder(
              future: Auth().getCurrentUserId(),
              builder: (BuildContext context, AsyncSnapshot<String> ss) {
                return ss.data == null ? Login() : Home();
              },
            ),
        '/login': (BuildContext context) => Login(),
        '/signup': (BuildContext context) => Signup(),
        '/register': (BuildContext context) => Register(),
        '/home': (BuildContext context) => Home(),
      },
    );
  }
}
