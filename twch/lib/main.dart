import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:twch/services/auth.dart';
import 'account_list.dart';

const String appTitle = 'twch';

void main() async {
  await DotEnv().load('.env');
  runApp(TwchApp());
}

class TwchApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Auth().loginWithTwitter();

    return MaterialApp(
      title: appTitle,
      home: AccountList(),
    );
  }
}
