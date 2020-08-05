import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:match/pages/home.dart';
import 'package:match/pages/login.dart';
import 'package:match/pages/settings.dart';
import 'package:match/pages/signup.dart';
import 'package:match/services/auth.dart';
import 'package:match/widgets/spinner.dart';

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
              future: Auth().getLoginStatus(),
              builder: (BuildContext context, AsyncSnapshot<LoginStatus> ss) {
                if (ss.connectionState != ConnectionState.done) {
                  return Spinner();
                }
                switch (ss.data) {
                  case LoginStatus.LoggedIn:
                    return Home();
                  case LoginStatus.SignedUp:
                    return Settings();
                  case LoginStatus.Anonymous:
                  default:
                    return Login();
                }
              },
            ),
        '/login': (BuildContext context) => Login(),
        '/signup': (BuildContext context) => Signup(),
        '/settings': (BuildContext context) => Settings(),
        '/home': (BuildContext context) => Home(),
      },
    );
  }
}
