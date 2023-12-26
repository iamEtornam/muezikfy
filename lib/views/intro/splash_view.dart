import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:muezikfy/routes.dart';
import 'package:muezikfy/services/songs_persistence_service.dart';
import 'package:muezikfy/shared_widgets/custom_progress_indicator.dart';
import 'package:on_audio_query/on_audio_query.dart';

class SplashView extends StatefulWidget {
  @override
  _SplashViewState createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {

  late BuildContext buildContext;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loginAuthState(buildContext);
    });
    super.initState();
  }

  Future loginAuthState(BuildContext context) async {
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    if (_firebaseAuth.currentUser != null) {
    
      context.goNamed(RoutesName.home);
    } else {
      context.goNamed(RoutesName.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    buildContext = context;
    return Scaffold(
      body: Column(
        children: [
          Spacer(),
          CustomProgressIndicator(),
          SizedBox(
            height: 24,
          )
        ],
      ),
    );
  }
}
