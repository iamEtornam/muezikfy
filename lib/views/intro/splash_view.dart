import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:muezikfy/resources/resources.dart';
import 'package:muezikfy/routes.dart';
import 'package:muezikfy/shared_widgets/custom_progress_indicator.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
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
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    if (firebaseAuth.currentUser != null) {
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
          const Spacer(),
          Image.asset(Images.appstore, height: 100, width: 100),
          const Spacer(),
          const CustomProgressIndicator(),
          const SizedBox(
            height: 24,
          )
        ],
      ),
    );
  }
}
