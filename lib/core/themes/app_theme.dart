import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';

// enum ThemeType { Light, Dark, System }

extension ThemeModeExt on ThemeMode {
  String themeName({required BuildContext context}) {
    switch (this) {
      case ThemeMode.light:
        return AppLocalizations.of(context)!.light;
      case ThemeMode.dark:
        return AppLocalizations.of(context)!.dark;
      case ThemeMode.system:
        return AppLocalizations.of(context)!.system;
    }
  }
}

ThemeData get myLightThemeData => ThemeData(
      colorScheme: myLightColorScheme,
      fontFamily: 'Montserrat',
      textButtonTheme: myTextButtonThemeData,
    );

TextButtonThemeData get myTextButtonThemeData => TextButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(myLightColorScheme.primary),
        foregroundColor: MaterialStateProperty.all(Colors.white),
      ),
    );

ColorScheme get myLightColorScheme => const ColorScheme(
      surface: Color(0xffFFFFFF),
      primary: Color(0xff79BD8F),
      primaryVariant: Color(0xff1b3724), // FlatButton text color
      secondary: Color(0xFFff8a65),
      secondaryVariant: Color(0xFFc75b39), // FloatingButton color
      // secondary: Color(0xFF00A388),
      // secondaryVariant: Color(0xFF006252), // FloatingButton color
      background: Color(0xffFFFFFF),
      error: Color(0xffCF6679),
      onPrimary: Color(0xffFFFFFF),
      onSecondary: Color(0xffFFFFFF),
      onSurface:
          Color(0xff000000), // FloatingButton child background, e.g. icon color
      onBackground: Color(0xff000000), // TextFormField border color
      onError: Color(0xff000000),
      brightness: Brightness.light,
    );

// class AppTheme {
//   const AppTheme._();

//   static const _lightColorScheme = ColorScheme(
//     surface: Color(0xffFFFFFF),
//     primary: Color(0xff79BD8F),
//     primaryVariant: Color(0xff1b3724), // FlatButton text color
//     secondary: Color(0xFFff8a65),
//     secondaryVariant: Color(0xFFc75b39), // FloatingButton color
//     // secondary: Color(0xFF00A388),
//     // secondaryVariant: Color(0xFF006252), // FloatingButton color
//     background: Color(0xffFFFFFF),
//     error: Color(0xffCF6679),
//     onPrimary: Color(0xffFFFFFF),
//     onSecondary: Color(0xffFFFFFF),
//     onSurface:
//         Color(0xff000000), // FloatingButton child background, e.g. icon color
//     onBackground: Color(0xff000000), // TextFormField border color
//     onError: Color(0xff000000),
//     brightness: Brightness.light,
//   );

//   // static final _lightColorScheme = ColorScheme(
//   //   surface: Color(0xffFFFFFF),
//   //   primary: Color(0xff6fc27c),
//   //   primaryVariant: Color(0xff6fc27c), // FlatButton text color
//   //   secondary: Color(0xFF0f4d19),
//   //   secondaryVariant: Color(0xFF0f4d19), // FloatingButton color
//   //   background: Color(0xffFFFFFF),
//   //   error: Color(0xffCF6679),
//   //   onPrimary: Color(0xffFFFFFF),
//   //   onSecondary: Color(0xffFFFFFF),
//   //   onSurface:
//   //       Color(0xff000000), // FloatingButton child background, e.g. icon color
//   //   onBackground: Color(0xff000000), // TextFormField border color
//   //   onError: Color(0xff000000),
//   //   brightness: Brightness.light,
//   // );

//   // static final _lightColorScheme = ColorScheme(
//   //   surface: Color(0xffFFFFFF),
//   //   primary: Color(0xff9d9ad9),
//   //   primaryVariant: Color(0xff9d9ad9), // FlatButton text color
//   //   secondary: Color(0xFF1f5980),
//   //   secondaryVariant: Color(0xFF1f5980), // FloatingButton color
//   //   background: Color(0xffcedef0),
//   //   error: Color(0xffCF6679),
//   //   onPrimary: Color(0xffFFFFFF),
//   //   onSecondary: Color(0xffFFFFFF),
//   //   onSurface:
//   //       Color(0xff000000), // FloatingButton child background, e.g. icon color
//   //   onBackground: Color(0xff000000), // TextFormField border color
//   //   onError: Color(0xff000000),
//   //   brightness: Brightness.light,
//   // );

//   // static final _lightColorScheme = ColorScheme(
//   //   surface: Color(0xffFFFFFF),
//   //   primary: Color(0xffACFFAD),
//   //   primaryVariant: Color(0xff558056), // FlatButton text color
//   //   secondary: Color(0xFF3db2ff),
//   //   secondaryVariant: Color(0xFF1f5980), // FloatingButton color
//   //   background: Color(0xffFFFFFF),
//   //   error: Color(0xffCF6679),
//   //   onPrimary: Color(0xffFFFFFF),
//   //   onSecondary: Color(0xffFFFFFF),
//   //   onSurface:
//   //       Color(0xff000000), // FloatingButton child background, e.g. icon color
//   //   onBackground: Color(0xff000000), // TextFormField border color
//   //   onError: Color(0xff000000),
//   //   brightness: Brightness.light,
//   // );

//   static final lightTheme = ThemeData(
//     colorScheme: _lightColorScheme,
//     textTheme: TextTheme(
//       bodyText1: TextStyle()
//     ),
//   );

//   // static final _lightColorScheme = ColorScheme(
//   //   surface: Color(0xffFFFFFF),
//   //   primary: Color(0xff8e24aa),
//   //   primaryVariant: Color(0xff5c007a), // FlatButton text color
//   //   secondary: Color(0xFFd81b60),
//   //   secondaryVariant: Color(0xFFa00037), // FloatingButton color
//   //   background: Color(0xffFFFFFF),
//   //   error: Color(0xffCF6679),
//   //   onPrimary: Color(0xffFFFFFF),
//   //   onSecondary: Color(0xffFFFFFF),
//   //   onSurface:
//   //       Color(0xff000000), // FloatingButton child background, e.g. icon color
//   //   onBackground: Color(0xff000000), // TextFormField border color
//   //   onError: Color(0xff000000),
//   //   brightness: Brightness.light,
//   // );

//   // static final lightTheme = ThemeData.from(
//   //   colorScheme: _lightColorScheme,
//   // );

//   static final _darkColorScheme = ColorScheme(
//     surface: Color(0xff121212),
//     primary: Color(0xffb39ddb),
//     primaryVariant: Color(0xff836fa9), // FlatButton text color
//     secondary: Color(0xFFf48fb1),
//     secondaryVariant: Color(0xFFbf5f82), // FloatingButton color
//     background: Color(0xff121212),
//     error: Color(0xffCF6679),
//     onPrimary: Color(0xff000000),
//     onSecondary: Color(0xff000000),
//     onSurface:
//         Color(0xffFFFFFF), // FloatingButton child background, e.g. icon color
//     onBackground: Color(0xffFFFFFF), // TextFormField border color
//     onError: Color(0xff000000),
//     brightness: Brightness.dark,
//   );

//   static final darkTheme = ThemeData.from(colorScheme: _darkColorScheme);
// }
