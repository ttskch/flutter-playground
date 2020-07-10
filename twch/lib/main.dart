import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:twch/pages/home.dart';
import 'package:twch/pages/account_list.dart';

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
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/': (BuildContext context) => Home(),
        '/account-list': (BuildContext context) => AccountList(),
      },
    );
  }
}
