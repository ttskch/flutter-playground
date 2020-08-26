import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:match/pages/home.dart';
import 'package:match/pages/likers.dart';
import 'package:match/pages/login.dart';
import 'package:match/pages/matchers.dart';
import 'package:match/pages/messaging.dart';
import 'package:match/pages/search.dart';
import 'package:match/pages/settings.dart';
import 'package:match/pages/signup.dart';
import 'package:match/pages/user_show.dart';
import 'package:match/services/auth.dart';
import 'package:match/widgets/spinner.dart';

import 'models/user.dart';

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
        '/likers': (BuildContext context) => Likers(),
        '/matchers': (BuildContext context) => Matchers(),
        '/search': (BuildContext context) => Search(),
      },
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/home/searched':
            return MaterialPageRoute(
              builder: (BuildContext context) =>
                  Home(users: settings.arguments as List<User>),
            );
          case '/user/show':
            return MaterialPageRoute(
              builder: (BuildContext context) =>
                  UserShow(user: settings.arguments as User),
            );
          case '/messaging':
            return MaterialPageRoute(
              builder: (BuildContext context) =>
                  Messaging(user: settings.arguments as User),
            );
          default:
            return null;
        }
      },
    );
  }
}
