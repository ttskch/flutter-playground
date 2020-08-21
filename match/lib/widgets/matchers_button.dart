import 'package:flutter/material.dart';

class MatchersButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.forum),
      onPressed: () {
        Navigator.of(context).pushNamed('/matchers');
      },
    );
  }
}
