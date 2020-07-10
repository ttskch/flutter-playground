import 'package:flutter/material.dart';
import 'package:twch/services/auth.dart';

class Login extends StatefulWidget {
  @override
  createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Center(
        child: _loading
            ? CircularProgressIndicator()
            : MaterialButton(
                child: Text('Login with Twitter'),
                color: Colors.blue,
                textColor: Colors.white,
                onPressed: () async {
                  setState(() => _loading = true);
                  await Auth().loginWithTwitter();
                  Navigator.of(context).pushReplacementNamed('/account-list');
                },
              ),
      ),
    );
  }
}
