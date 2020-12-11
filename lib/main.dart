import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:muezikfy/routes.dart';
import 'shared_widgets/custom_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Muezikfy',
      theme: CustomTheme().customLightTheme(context),
      darkTheme: CustomTheme().customDarkTheme(context),
      themeMode: ThemeMode.system,
      onGenerateRoute: Routes.generateRoute,
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      localeResolutionCallback:
          (Locale locale, Iterable<Locale> supportedLocales) {
        return locale;
      },
    );
  }
}
