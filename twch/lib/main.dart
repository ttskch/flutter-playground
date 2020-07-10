import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:twch/pages/account_log_list.dart';
import 'package:twch/pages/home.dart';
import 'package:twch/pages/account_list.dart';
import 'models/account.dart';

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
      onGenerateRoute: (RouteSettings settings) {
        final args = settings.arguments as Account;
        if (settings.name == '/account-log-list') {
          return MaterialPageRoute(
            builder: (BuildContext context) {
              return AccountLogList(account: args);
            },
          );
        }
        return null;
      },
    );
  }
}
