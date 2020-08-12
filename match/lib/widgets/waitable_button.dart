import 'package:flutter/material.dart';

class WaitableButton extends StatefulWidget {
  WaitableButton({
    Key key,
    @required this.onPressed,
    this.label,
    this.textColor,
    this.color,
  }) : super(key: key);

  final VoidCallback onPressed;
  final String label;
  final Color textColor;
  final Color color;

  @override
  createState() => _WaitableButtonState();
}

class _WaitableButtonState extends State<WaitableButton> {
  bool _waiting = false;

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      child: Text(widget.label),
      onPressed: _waiting
          ? null
          : () async {
              setState(() => _waiting = true);
              await widget.onPressed();
              setState(() => _waiting = false);
            },
    );
  }
}
