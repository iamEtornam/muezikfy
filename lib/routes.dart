import 'package:flutter/material.dart';
import 'package:muezikfy/views/auth/login_view.dart';
import 'package:muezikfy/views/home/home_view.dart';
import 'package:muezikfy/views/intro/splash_view.dart';
import 'package:muezikfy/views/playing/playing_view.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => SplashView());
      case '/homeView':
        return MaterialPageRoute(builder: (_) => HomeView());
      case '/playingView':
        return MaterialPageRoute(builder: (_) => PlayingView());
      case '/loginView':
        return MaterialPageRoute(builder: (_) => LoginView());
      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
              body: Center(
                  child: Text('No route defined for ${settings.name}')),
            ));
    }
  }
}