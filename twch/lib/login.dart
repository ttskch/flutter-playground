import 'package:flutter/material.dart';
import 'package:twch/services/auth.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Auth().getCurrentUser(),
      builder: (BuildContext context, AsyncSnapshot ss) {
        if (ss.connectionState == ConnectionState.done) {
          if (ss.data != null) {
            Future.microtask(() =>
                Navigator.of(context).pushReplacementNamed('/account-list'));
          } else {
            return Scaffold(
              appBar: AppBar(title: Text('Login')),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MaterialButton(
                      child: Text('Login with Twitter'),
                      color: Colors.blue,
                      textColor: Colors.white,
                      onPressed: () async {
                        await Auth().loginWithTwitter();
                        Navigator.of(context)
                            .pushReplacementNamed('/account-list');
                      },
                    ),
                  ],
                ),
              ),
            );
          }
        }

        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
