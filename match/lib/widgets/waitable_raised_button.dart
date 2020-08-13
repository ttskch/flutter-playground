import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class WaitableRaisedButton extends StatefulWidget {
  @override
  createState() => _State();

  WaitableRaisedButton({
    @required this.onPressed,
    this.child,
  });

  final VoidCallback onPressed;
  final Widget child;
}

class _State extends State<WaitableRaisedButton> {
  bool _waiting = false;

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
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
