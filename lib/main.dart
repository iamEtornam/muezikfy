import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:muezikfy/firebase_options.dart';
import 'package:muezikfy/routes.dart';
import 'package:provider/provider.dart';

import 'providers/auth_provider.dart';
import 'shared_widgets/custom_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await JustAudioBackground.init(
    androidNotificationChannelId: 'dev.etornam.muezikfy.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
    
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>.value(value: AuthProvider())
      ],
      child: MaterialApp.router(
        title: 'Muezikfy',
        builder: BotToastInit(),
        routeInformationProvider: router.routeInformationProvider,
        routeInformationParser: router.routeInformationParser,
        routerDelegate: router.routerDelegate,
        debugShowCheckedModeBanner: false,
        theme: CustomTheme().customLightTheme(context),
        darkTheme: CustomTheme().customDarkTheme(context),
        themeMode: ThemeMode.system,
      ),
    );
  }
}
