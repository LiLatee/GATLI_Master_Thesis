import 'dart:developer';

import 'package:background_fetch/background_fetch.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart' as dartz;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:master_thesis/core/themes/app_theme.dart';
import 'package:master_thesis/features/app/app_cubit.dart';
import 'package:master_thesis/features/data/user_session_repository.dart';
import 'package:master_thesis/features/data/users_repository.dart';
import 'package:master_thesis/features/home_page/home_screen.dart';
import 'package:master_thesis/features/login/login_page.dart';
import 'package:master_thesis/features/splash_screen/splash_screen.dart';
import 'package:master_thesis/main.dart';
import 'package:master_thesis/router/app_router.dart';
import 'package:master_thesis/service_locator.dart';

class App extends StatefulWidget {
  // This widget is the root of your application.
  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  // // Platform messages are asynchronous, so we initialize in an async method.
  // Future<void> initPlatformState() async {
  //   // Configure BackgroundFetch.
  //   int status = await BackgroundFetch.configure(
  //     BackgroundFetchConfig(
  //       minimumFetchInterval: 15,
  //       stopOnTerminate: false,
  //       enableHeadless: true,
  //       requiresBatteryNotLow: false,
  //       requiresCharging: false,
  //       requiresStorageNotLow: false,
  //       requiresDeviceIdle: false,
  //       requiredNetworkType: NetworkType.ANY,
  //     ),
  //     (String taskId) async {
  //       // <-- Event handler
  //       // This is the fetch-event callback.
  //       print("[BackgroundFetch] Event received $taskId");
  //       await updateUserSteps();
  //       print('STEPS UPDATED');
  //       // IMPORTANT:  You must signal completion of your task or the OS can punish your app
  //       // for taking too long in the background.
  //       BackgroundFetch.finish(taskId);
  //     },
  //     (String taskId) async {
  //       // <-- Task timeout handler.
  //       // This task has exceeded its allowed running-time.  You must stop what you're doing and immediately .finish(taskId)
  //       print("[BackgroundFetch] TASK TIMEOUT taskId: $taskId");
  //       BackgroundFetch.finish(taskId);
  //     },
  //   );
  //   print('[BackgroundFetch] configure success: $status');

  //   // If the widget was removed from the tree while the asynchronous platform
  //   // message was in flight, we want to discard the reply rather than calling
  //   // setState to update our non-existent appearance.
  //   if (!mounted) return;
  // }

  @override
  void initState() {
    super.initState();
    // initPlatformState();
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
      // darkTheme: AppTheme.darkTheme,
      // themeMode: themeState is ThemeDark ? ThemeMode.dark : ThemeMode.light,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('en'), // TODO
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
