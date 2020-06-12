import 'package:flutter/material.dart';
import 'account_list.dart';

const String appTitle = 'twch';

void main() {
  runApp(TwchApp());
}

class TwchApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appTitle,
      home: AccountList(),
    );
  }
}
