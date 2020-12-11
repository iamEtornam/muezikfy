import 'package:flutter/material.dart';

import 'shared_widgets/custom_theme.dart';
import 'views/intro/splash_view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Muezikfy',
      theme: CustomTheme().customLightTheme(context),
      darkTheme: CustomTheme().customDarkTheme(context),
      themeMode: ThemeMode.system,
      home: SplashView(),
    );
  }
}
