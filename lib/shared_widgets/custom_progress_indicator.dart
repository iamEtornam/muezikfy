import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomProgressIndicator extends StatelessWidget {
  final double size;

  const CustomProgressIndicator({Key? key, this.size = 45.0}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Platform.isIOS
            ? CupertinoActivityIndicator()
            : SizedBox(
            width: size, height: size, child: CircularProgressIndicator()));
  }
}
