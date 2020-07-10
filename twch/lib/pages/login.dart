import 'package:flutter/material.dart';
import 'package:twch/services/auth.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Center(
        child: MaterialButton(
          child: Text('Login with Twitter'),
          color: Colors.blue,
          textColor: Colors.white,
          onPressed: () async {
            await Auth().loginWithTwitter();
            Navigator.of(context).pushReplacementNamed('/account-list');
          },
        ),
      ),
    );
  }
}
