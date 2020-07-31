import 'package:flutter/material.dart';
import 'package:match/services/auth.dart';

class LogoutButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.exit_to_app),
      onPressed: () {
        Auth().logout();
        Navigator.of(context).pushReplacementNamed('/login');
      },
    );
  }
}
