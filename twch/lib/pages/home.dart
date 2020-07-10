import 'package:flutter/material.dart';
import 'package:twch/pages/login.dart';
import 'package:twch/pages/account_list.dart';
import 'package:twch/services/auth.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Auth().getCurrentUser(),
      builder: (BuildContext context, AsyncSnapshot ss) {
        if (ss.connectionState != ConnectionState.done) {
          return Center(child: CircularProgressIndicator());
        }

        if (ss.data != null) {
          return AccountList();
        }

        return Login();
      },
    );
  }
}
