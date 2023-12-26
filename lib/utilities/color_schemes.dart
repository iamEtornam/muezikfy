import 'package:flutter/material.dart';

const lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xFF8B5000),
  onPrimary: Color(0xFFFFFFFF),
  primaryContainer: Color(0xFFFFDCBE),
  onPrimaryContainer: Color(0xFF2C1600),
  secondary: Color(0xFF725A42),
  onSecondary: Color(0xFFFFFFFF),
  secondaryContainer: Color(0xFFFFDCBE),
  onSecondaryContainer: Color(0xFF291806),
  tertiary: Color(0xFF8B5000),
  onTertiary: Color(0xFFFFFFFF),
  tertiaryContainer: Color(0xFFFFDCBE),
  onTertiaryContainer: Color(0xFF2C1600),
  error: Color(0xFFBA1A1A),
  errorContainer: Color(0xFFFFDAD6),
  onError: Color(0xFFFFFFFF),
  onErrorContainer: Color(0xFF410002),
  background: Color(0xFFFFFBFF),
  onBackground: Color(0xFF201B16),
  surface: Color(0xFFFFFBFF),
  onSurface: Color(0xFF201B16),
  surfaceVariant: Color(0xFFF2DFD1),
  onSurfaceVariant: Color(0xFF51453A),
  outline: Color(0xFF837468),
  onInverseSurface: Color(0xFFFAEFE7),
  inverseSurface: Color(0xFF352F2B),
  inversePrimary: Color(0xFFFFB870),
  shadow: Color(0xFF000000),
  surfaceTint: Color(0xFF8B5000),
  outlineVariant: Color(0xFFD5C3B5),
  scrim: Color(0xFF000000),
);

const darkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xFFFFB870),
  onPrimary: Color(0xFF4A2800),
  primaryContainer: Color(0xFF693C00),
  onPrimaryContainer: Color(0xFFFFDCBE),
  secondary: Color(0xFFE1C1A4),
  onSecondary: Color(0xFF402C18),
  secondaryContainer: Color(0xFF59422C),
  onSecondaryContainer: Color(0xFFFFDCBE),
  tertiary: Color(0xFFFFB870),
  onTertiary: Color(0xFF4A2800),
  tertiaryContainer: Color(0xFF693C00),
  onTertiaryContainer: Color(0xFFFFDCBE),
  error: Color(0xFFFFB4AB),
  errorContainer: Color(0xFF93000A),
  onError: Color(0xFF690005),
  onErrorContainer: Color(0xFFFFDAD6),
  background: Color(0xFF201B16),
  onBackground: Color(0xFFEBE0D9),
  surface: Color(0xFF201B16),
  onSurface: Color(0xFFEBE0D9),
  surfaceVariant: Color(0xFF51453A),
  onSurfaceVariant: Color(0xFFD5C3B5),
  outline: Color(0xFF9D8E81),
  onInverseSurface: Color(0xFF201B16),
  inverseSurface: Color(0xFFEBE0D9),
  inversePrimary: Color(0xFF8B5000),
  shadow: Color(0xFF000000),
  surfaceTint: Color(0xFFFFB870),
  outlineVariant: Color(0xFF51453A),
  scrim: Color(0xFF000000),
);


const Color colorMain = Color(0xFFFF9800);

Color fromHex(String hexString) {
  final buffer = StringBuffer();
  if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
  buffer.write(hexString.replaceFirst('#', ''));
  return Color(int.parse(buffer.toString(), radix: 16));
}
