import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:muezikfy/utilities/color_schemes.dart';

class CustomTheme {
  /// light theme
  ThemeData customLightTheme(
    BuildContext context,
  ) {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: const Color.fromARGB(255, 240, 242, 245),
      visualDensity: VisualDensity.adaptivePlatformDensity,
      platform: defaultTargetPlatform,
      highlightColor: colorMain.withOpacity(.5),
      primaryColor: colorMain,
      indicatorColor: colorMain,
      floatingActionButtonTheme:
          const FloatingActionButtonThemeData(backgroundColor: colorMain),
      unselectedWidgetColor: Colors.grey,
      brightness: Brightness.light,
      fontFamily: GoogleFonts.poppins().fontFamily,
      cardColor: const Color.fromRGBO(250, 250, 250, 1),
      inputDecorationTheme: InputDecorationTheme(
        fillColor: fromHex('#eceff1'),
        filled: true,
        alignLabelWithHint: true,
        hintStyle: Theme.of(context).textTheme.bodyLarge,
        contentPadding: const EdgeInsets.all(15.0),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: fromHex('#eceff1'), width: .5),
            borderRadius: const BorderRadius.all(Radius.circular(8.5))),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey[300]!, width: .5),
            borderRadius: const BorderRadius.all(Radius.circular(8.5))),
        disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: fromHex('#E5E5E5')),
            borderRadius: const BorderRadius.all(Radius.circular(8.5))),
        errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: fromHex('#B00020').withOpacity(.5)),
            borderRadius: const BorderRadius.all(Radius.circular(8.5))),
        focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: fromHex('#B00020')),
            borderRadius: const BorderRadius.all(Radius.circular(8.5))),
        labelStyle: Theme.of(context).textTheme.bodyLarge,
        errorStyle: Theme.of(context)
            .textTheme
            .bodyMedium!
            .copyWith(color: fromHex('#B00020')),
      ),
      iconTheme: const IconThemeData(color: Colors.black),
      tabBarTheme: TabBarTheme(
        unselectedLabelColor: Colors.black.withOpacity(.5),
      ),
      textTheme: Typography.material2018(platform: defaultTargetPlatform)
          .white
          .copyWith(
            bodyLarge: const TextStyle(color: Colors.black, fontSize: 17),
            bodyMedium: const TextStyle(color: Colors.black, fontSize: 14),
            bodySmall: const TextStyle(color: Colors.black, fontSize: 12),
            displayLarge: const TextStyle(color: Colors.black, fontSize: 96),
            displayMedium: const TextStyle(color: Colors.black, fontSize: 60),
            displaySmall: const TextStyle(color: Colors.black, fontSize: 48),
            headlineMedium: const TextStyle(color: Colors.black, fontSize: 34),
            headlineSmall: const TextStyle(color: Colors.black, fontSize: 24),
            titleLarge: const TextStyle(color: Colors.black, fontSize: 20),
            titleMedium: const TextStyle(color: Colors.black, fontSize: 16),
            titleSmall: const TextStyle(color: Colors.black, fontSize: 14),
            labelSmall: const TextStyle(color: Colors.black, fontSize: 10),
            labelLarge: const TextStyle(color: Colors.black, fontSize: 16),
          ),
      dividerColor: Colors.grey,
      appBarTheme: AppBarTheme(
          elevation: Platform.isIOS ? 0 : 2,
          color: const Color.fromARGB(255, 240, 242, 245),
          iconTheme: IconThemeData(color: fromHex('#000000')),
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          toolbarTextStyle: Typography.material2018(
                  platform: defaultTargetPlatform)
              .white
              .copyWith(
                bodyLarge: const TextStyle(color: Colors.black, fontSize: 17),
                bodyMedium: const TextStyle(color: Colors.black, fontSize: 14),
                bodySmall: const TextStyle(color: Colors.black, fontSize: 12),
                displayLarge:
                    const TextStyle(color: Colors.black, fontSize: 96),
                displayMedium:
                    const TextStyle(color: Colors.black, fontSize: 60),
                displaySmall:
                    const TextStyle(color: Colors.black, fontSize: 48),
                headlineMedium:
                    const TextStyle(color: Colors.black, fontSize: 34),
                headlineSmall:
                    const TextStyle(color: Colors.black, fontSize: 24),
                titleLarge: const TextStyle(color: Colors.black, fontSize: 20),
                titleMedium: const TextStyle(color: Colors.black, fontSize: 16),
                titleSmall: const TextStyle(color: Colors.black, fontSize: 14),
                labelSmall: const TextStyle(color: Colors.black, fontSize: 10),
                labelLarge: const TextStyle(color: Colors.black, fontSize: 16),
              )
              .bodyMedium,
          titleTextStyle: Typography.material2018(
                  platform: defaultTargetPlatform)
              .white
              .copyWith(
                bodyLarge: const TextStyle(color: Colors.black, fontSize: 17),
                bodyMedium: const TextStyle(color: Colors.black, fontSize: 14),
                bodySmall: const TextStyle(color: Colors.black, fontSize: 12),
                displayLarge:
                    const TextStyle(color: Colors.black, fontSize: 96),
                displayMedium:
                    const TextStyle(color: Colors.black, fontSize: 60),
                displaySmall:
                    const TextStyle(color: Colors.black, fontSize: 48),
                headlineMedium:
                    const TextStyle(color: Colors.black, fontSize: 34),
                headlineSmall:
                    const TextStyle(color: Colors.black, fontSize: 24),
                titleLarge: const TextStyle(color: Colors.black, fontSize: 20),
                titleMedium: const TextStyle(color: Colors.black, fontSize: 16),
                titleSmall: const TextStyle(color: Colors.black, fontSize: 14),
                labelSmall: const TextStyle(color: Colors.black, fontSize: 10),
                labelLarge: const TextStyle(color: Colors.black, fontSize: 16),
              )
              .titleLarge),
      textSelectionTheme: const TextSelectionThemeData(cursorColor: colorMain),
      colorScheme: lightColorScheme,
    );
  }

  ///dark theme
  ThemeData customDarkTheme(
    BuildContext context,
  ) {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: fromHex('#121212'),
      visualDensity: VisualDensity.adaptivePlatformDensity,
      primaryColor: colorMain,
      indicatorColor: colorMain,
      highlightColor: colorMain.withOpacity(.5),
      floatingActionButtonTheme:
          const FloatingActionButtonThemeData(backgroundColor: colorMain),
      platform: defaultTargetPlatform,
      unselectedWidgetColor: Colors.grey,
      brightness: Brightness.dark,
      fontFamily: GoogleFonts.poppins().fontFamily,
      cardColor: const Color.fromRGBO(31, 31, 31, 1),
      tabBarTheme: TabBarTheme(
        unselectedLabelColor: Colors.white.withOpacity(.7),
      ),
      textTheme: Typography.material2018(platform: defaultTargetPlatform)
          .white
          .copyWith(
            bodyLarge: const TextStyle(color: Colors.white70, fontSize: 17),
            bodyMedium: const TextStyle(color: Colors.white70, fontSize: 14),
            bodySmall: const TextStyle(color: Colors.white70, fontSize: 12),
            displayLarge: const TextStyle(color: Colors.white70, fontSize: 96),
            displayMedium: const TextStyle(color: Colors.white70, fontSize: 60),
            displaySmall: const TextStyle(color: Colors.white70, fontSize: 48),
            headlineMedium:
                const TextStyle(color: Colors.white70, fontSize: 34),
            headlineSmall: const TextStyle(color: Colors.white70, fontSize: 24),
            titleLarge: const TextStyle(color: Colors.white70, fontSize: 20),
            titleMedium: const TextStyle(color: Colors.white70, fontSize: 16),
            titleSmall: const TextStyle(color: Colors.white70, fontSize: 14),
            labelSmall: const TextStyle(color: Colors.white70, fontSize: 10),
            labelLarge: const TextStyle(color: Colors.white70, fontSize: 16),
          ),
      iconTheme: const IconThemeData(color: Colors.white70),
      dividerColor: Colors.white.withOpacity(.6),
      inputDecorationTheme: InputDecorationTheme(
        fillColor: const Color.fromRGBO(31, 31, 31, 1),
        filled: true,
        alignLabelWithHint: true,
        hintStyle: Theme.of(context)
            .textTheme
            .bodyLarge!
            .copyWith(fontWeight: FontWeight.normal),
        contentPadding: const EdgeInsets.all(10.0),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.all(Radius.circular(8.5))),
        enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.all(Radius.circular(8.5))),
        disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: fromHex('#E5E5E5')),
            borderRadius: const BorderRadius.all(Radius.circular(8.5))),
        errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: fromHex('#CF6679').withOpacity(.5)),
            borderRadius: const BorderRadius.all(Radius.circular(8.5))),
        focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: fromHex('#CF6679')),
            borderRadius: const BorderRadius.all(Radius.circular(8.5))),
        labelStyle: Theme.of(context)
            .textTheme
            .bodyLarge!
            .copyWith(color: Colors.white70),
        errorStyle: Theme.of(context)
            .textTheme
            .bodyMedium!
            .copyWith(color: fromHex('#CF6679')),
      ),
      appBarTheme: AppBarTheme(
          color: fromHex('#121212'),
          elevation: Platform.isIOS ? 0 : 2,
          iconTheme: const IconThemeData(color: Colors.white),
          systemOverlayStyle: SystemUiOverlayStyle.light,
          toolbarTextStyle: Typography.material2018(
                  platform: defaultTargetPlatform)
              .white
              .copyWith(
                bodyLarge: const TextStyle(color: Colors.white70, fontSize: 17),
                bodyMedium:
                    const TextStyle(color: Colors.white70, fontSize: 14),
                bodySmall: const TextStyle(color: Colors.white70, fontSize: 12),
                displayLarge:
                    const TextStyle(color: Colors.white70, fontSize: 96),
                displayMedium:
                    const TextStyle(color: Colors.white70, fontSize: 60),
                displaySmall:
                    const TextStyle(color: Colors.white70, fontSize: 48),
                headlineMedium:
                    const TextStyle(color: Colors.white70, fontSize: 34),
                headlineSmall:
                    const TextStyle(color: Colors.white70, fontSize: 24),
                titleLarge:
                    const TextStyle(color: Colors.white70, fontSize: 20),
                titleMedium:
                    const TextStyle(color: Colors.white70, fontSize: 16),
                titleSmall:
                    const TextStyle(color: Colors.white70, fontSize: 14),
                labelSmall:
                    const TextStyle(color: Colors.white70, fontSize: 10),
                labelLarge:
                    const TextStyle(color: Colors.white70, fontSize: 16),
              )
              .bodyMedium,
          titleTextStyle: Typography.material2018(
                  platform: defaultTargetPlatform)
              .white
              .copyWith(
                bodyLarge: const TextStyle(color: Colors.white70, fontSize: 17),
                bodyMedium:
                    const TextStyle(color: Colors.white70, fontSize: 14),
                bodySmall: const TextStyle(color: Colors.white70, fontSize: 12),
                displayLarge:
                    const TextStyle(color: Colors.white70, fontSize: 96),
                displayMedium:
                    const TextStyle(color: Colors.white70, fontSize: 60),
                displaySmall:
                    const TextStyle(color: Colors.white70, fontSize: 48),
                headlineMedium:
                    const TextStyle(color: Colors.white70, fontSize: 34),
                headlineSmall:
                    const TextStyle(color: Colors.white70, fontSize: 24),
                titleLarge:
                    const TextStyle(color: Colors.white70, fontSize: 20),
                titleMedium:
                    const TextStyle(color: Colors.white70, fontSize: 16),
                titleSmall:
                    const TextStyle(color: Colors.white70, fontSize: 14),
                labelSmall:
                    const TextStyle(color: Colors.white70, fontSize: 10),
                labelLarge:
                    const TextStyle(color: Colors.white70, fontSize: 16),
              )
              .titleLarge),
      textSelectionTheme: const TextSelectionThemeData(cursorColor: colorMain),
      colorScheme: darkColorScheme,
    );
  }
}
