import 'package:flutter/material.dart';

class PlayingView extends StatefulWidget {
  PlayingView({Key? key}) : super(key: key);

  @override
  _PlayingViewState createState() => _PlayingViewState();
}

class _PlayingViewState extends State<PlayingView> {
  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'to_playing',
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'PLAYING',
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(fontWeight: FontWeight.w600),
          ),
          actions: [IconButton(icon: Icon(Icons.more_vert), onPressed: () {})],
        ),
      ),
    );
  }
}
