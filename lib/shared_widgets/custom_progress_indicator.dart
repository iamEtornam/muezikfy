import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomProgressIndicator extends StatelessWidget {
  final double size;

  const CustomProgressIndicator({super.key, this.size = 45.0});
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Platform.isIOS
            ? const CupertinoActivityIndicator()
            : SizedBox(
            width: size, height: size, child: const CircularProgressIndicator()));
  }
}
