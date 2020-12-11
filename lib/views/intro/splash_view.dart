import 'package:flutter/material.dart';
import 'package:muezikfy/shared_widgets/custom_progress_indicator.dart';

class SplashView extends StatefulWidget {
  @override
  _SplashViewState createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {

  @override
  void initState() {
    Future.delayed(Duration(seconds: 5),(){
      Navigator.pushNamedAndRemoveUntil(context, '/homeView', (route) => false);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Spacer(),
          CustomProgressIndicator(),
          SizedBox(height: 24,)
        ],
      ),
    );
  }
}
