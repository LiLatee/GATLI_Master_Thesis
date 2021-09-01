import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_thesis/core/themes/app_theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:master_thesis/features/home_page/home_screen.dart';
import 'package:master_thesis/features/launching/first_launch/presentation/pages/set_name_page.dart';
import 'package:master_thesis/features/launching/presentation/cubit/launching_cubit.dart';
import 'package:master_thesis/features/splash_screen/splash_screen.dart';
import 'package:master_thesis/router/app_router.dart';
import 'package:master_thesis/service_locator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initServiceLocator();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LaunchingCubit>(
          create: (_) => sl<LaunchingCubit>(),
        )
      ],
      child: Builder(
        builder: (context) => _buildMaterialApp(),
      ),
    );
  }

  MaterialApp _buildMaterialApp() {
    return MaterialApp(
      title: 'Flutter Demo',
      onGenerateRoute: sl<AppRouter>().onGenerateRoute,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      // themeMode: themeState is ThemeDark ? ThemeMode.dark : ThemeMode.light,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: null, // TODO
      // home: _buildProperScreen(),
      home: HomePage(),
    );
  }

  Widget _buildProperScreen() {
    return BlocBuilder<LaunchingCubit, LaunchingState>(
      builder: (context, state) {
        if (state is LaunchingSetProfile) {
          return SetNameScreen();
        } else if (state is LaunchingHomeScreen) {
          return HomePage();
        } else {
          return SplashScreen();
        }
      },
    );
  }
}
