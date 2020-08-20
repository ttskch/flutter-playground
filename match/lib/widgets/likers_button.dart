import 'package:flutter/material.dart';

class LikersButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.favorite),
      onPressed: () {
        Navigator.of(context).pushNamed('/likers');
      },
    );
  }
}
