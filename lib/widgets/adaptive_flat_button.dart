import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdaptiveFlatButton extends StatelessWidget {
  final Function onPressedFuction;
  final String text;

  // ignore: use_key_in_widget_constructors
  const AdaptiveFlatButton(this.onPressedFuction, this.text);
  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? CupertinoButton(
            onPressed: onPressedFuction,
            child: Text(
              text,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          )
        : TextButton(
            onPressed: onPressedFuction,
            child: Text(
              text,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          );
  }
}
