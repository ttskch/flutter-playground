import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class WaitableFlatButton extends StatefulWidget {
  @override
  createState() => _State();

  WaitableFlatButton({
    @required this.onPressed,
    this.child,
  });

  final VoidCallback onPressed;
  final Widget child;
}

class _State extends State<WaitableFlatButton> {
  bool _waiting = false;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: widget.onPressed == null || _waiting
          ? null
          : () async {
              setState(() => _waiting = true);
              await widget.onPressed();
              setState(() => _waiting = false);
            },
      child: widget.child,
    );
  }
}
