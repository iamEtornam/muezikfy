import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:muezikfy/routes.dart';
import 'package:provider/provider.dart';

import 'providers/auth_provider.dart';
import 'shared_widgets/custom_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>.value(value: AuthProvider())
      ],
      child: MaterialApp(
        
        title: 'Muezikfy',
        builder: BotToastInit(),
        theme: CustomTheme().customLightTheme(context),
        darkTheme: CustomTheme().customDarkTheme(context),
        themeMode: ThemeMode.system,
        onGenerateRoute: Routes.generateRoute,
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        navigatorObservers: [
          FirebaseAnalyticsObserver(analytics: _analytics),
          BotToastNavigatorObserver()
        ],
      ),
    );
  }
}
