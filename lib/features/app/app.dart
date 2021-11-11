import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:master_thesis/core/themes/app_theme.dart';
import 'package:master_thesis/features/app/app_cubit.dart';
import 'package:master_thesis/features/home_page/home_screen.dart';
import 'package:master_thesis/features/login/login_page.dart';
import 'package:master_thesis/features/splash_screen/splash_screen.dart';
import 'package:master_thesis/router/app_router.dart';
import 'package:master_thesis/service_locator.dart';

class App extends StatefulWidget {
  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) => _buildMaterialApp(),
    );
  }

  MaterialApp _buildMaterialApp() {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      onGenerateRoute: sl<AppRouter>().onGenerateRoute,
      theme: myLightThemeData,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('en'),
      home: _buildProperScreen(),
      // home: const EmailSignUpPage(),
    );
  }

  Widget _buildProperScreen() {
    return BlocBuilder<AppCubit, AppState>(
      bloc: sl<AppCubit>(),
      builder: (contetx, state) {
        log('_buildProperScreen: $state');

        log('AppState: $state');
        if (state == AppState.authorized) {
          log('HomePage');
          return const HomePage();
        } else if (state == AppState.unauthorized) {
          log('LoginPage');
          return const LoginPage();
        } else {
          log('SplashScreen');
          return const SplashScreen();
        }
      },
    );
  }
}
