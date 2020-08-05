import 'package:flutter/material.dart';

class SettingsButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.settings),
      onPressed: () {
        Navigator.of(context).pushNamed('/settings');
      },
    );
  }
}
