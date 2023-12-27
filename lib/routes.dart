import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:muezikfy/models/song.dart';
import 'package:muezikfy/views/auth/login_view.dart';
import 'package:muezikfy/views/auth/profile_view.dart';
import 'package:muezikfy/views/friends/friends_list_view.dart';
import 'package:muezikfy/views/home/home_view.dart';
import 'package:muezikfy/views/intro/splash_view.dart';
import 'package:muezikfy/views/playing/playing_view.dart';

class RoutesName {
  static const String initialRoute = '/';
  static const String home = '/home';
  static const String playing = '/playing';
  static const String login = '/login';
  static const String profile = '/profile';
  static const String personList = 'person-list';
}

final GoRouter router = GoRouter(
  debugLogDiagnostics: kDebugMode,
  initialLocation: RoutesName.initialRoute,
  observers: [
    FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance),
    BotToastNavigatorObserver()
  ],
  routes: [
    GoRoute(
        path: '/',
        name: RoutesName.initialRoute,
        pageBuilder: (BuildContext context, GoRouterState state) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: const SplashView(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity:
                    CurveTween(curve: Curves.easeInOutCirc).animate(animation),
                child: child,
              );
            },
          );
        }),
    GoRoute(
        path: '/login',
        name: RoutesName.login,
        pageBuilder: (BuildContext context, GoRouterState state) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: const LoginView(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity:
                    CurveTween(curve: Curves.easeInOutCirc).animate(animation),
                child: child,
              );
            },
          );
        }),
    GoRoute(
        path: '/profile',
        name: RoutesName.profile,
        pageBuilder: (BuildContext context, GoRouterState state) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: const ProfileView(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity:
                    CurveTween(curve: Curves.easeInOutCirc).animate(animation),
                child: child,
              );
            },
          );
        }),
    GoRoute(
        path: '/home',
        name: RoutesName.home,
        pageBuilder: (BuildContext context, GoRouterState state) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: const HomeView(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity:
                    CurveTween(curve: Curves.easeInOutCirc).animate(animation),
                child: child,
              );
            },
          );
        },
        routes: [
          GoRoute(
              path: 'playing',
              name: RoutesName.playing,
              pageBuilder: (BuildContext context, GoRouterState state) {
                final song = state.extra as Song;
                return CustomTransitionPage(
                  key: state.pageKey,
                  child: PlayingView(song: song),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    return FadeTransition(
                      opacity: CurveTween(curve: Curves.easeInOutCirc)
                          .animate(animation),
                      child: child,
                    );
                  },
                );
              }),
          GoRoute(
              path: 'person-list',
              name: RoutesName.personList,
              pageBuilder: (BuildContext context, GoRouterState state) {
                return CustomTransitionPage(
                  key: state.pageKey,
                  child: const FriendsListView(),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    return FadeTransition(
                      opacity: CurveTween(curve: Curves.easeInOutCirc)
                          .animate(animation),
                      child: child,
                    );
                  },
                );
              }),
        ]),
  ],
  errorBuilder: (context, state) {
    return Scaffold(
      body: Center(child: Text('No route defined for ${state.path}')),
    );
  },
);
