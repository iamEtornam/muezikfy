import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:muezikfy/utilities/color_schemes.dart';

class CustomProgressIndicator extends StatelessWidget {
  final double size;

  const CustomProgressIndicator({super.key, this.size = 25.0});
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Platform.isIOS
            ? const CupertinoActivityIndicator()
            : SizedBox(
                width: size,
                height: size,
                child: const CircularProgressIndicator(
                  color: colorMain,
                )));
  }
}
