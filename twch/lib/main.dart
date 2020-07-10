import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:twch/account_list.dart';
import 'login.dart';

const String appTitle = 'twch';

void main() async {
  await DotEnv().load('.env');
  runApp(TwchApp());
}

class TwchApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appTitle,
      initialRoute: '/login',
      routes: <String, WidgetBuilder>{
        '/login': (BuildContext context) => Login(),
        '/account-list': (BuildContext context) => AccountList(),
      },
    );
  }
}
