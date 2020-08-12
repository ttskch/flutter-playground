import 'package:flutter/material.dart';
import 'package:match/models/user.dart';

class ProfileImage extends StatelessWidget {
  ProfileImage({
    Key key,
    @required this.user,
  }) : super(key: key);

  final User user;

  @override
  Widget build(BuildContext context) {
    return user.imageUrl != null
        ? Image.network(
            user.imageUrl,
            fit: BoxFit.cover,
          )
        : Image.network(
            'https://via.placeholder.com/300',
            fit: BoxFit.cover,
          );
  }
}
