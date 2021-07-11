import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_thesis/core/themes/app_theme.dart';
import 'package:master_thesis/logic/cubit/launching_cubit.dart';
import 'package:master_thesis/presentation/home_screen/home_screen.dart';
import 'package:master_thesis/presentation/router/app_router.dart';
import 'package:master_thesis/presentation/yt_player_test_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:master_thesis/service_locator.dart' as di;

import 'presentation/set_profile_screen/set_name_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LaunchingCubit>(
          create: (_) => di.sl<LaunchingCubit>(),
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
      onGenerateRoute: di.sl<AppRouter>().onGenerateRoute,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      // themeMode: themeState is ThemeDark ? ThemeMode.dark : ThemeMode.light,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: null, // TODO
      home: _buildProperScreen(),
    );
  }

  Widget _buildProperScreen() {
    return BlocBuilder<LaunchingCubit, LaunchingState>(
      builder: (context, state) {
        if (state is LaunchingSetProfile)
          return SetNameScreen();
        else if (state is LaunchingHomeScreen)
          return HomeScreen();
        else if (state is LaunchingLoading)
          return Center(
            child: CircularProgressIndicator(),
          );

        throw Exception("Wrong LaunchingCubit state!");
      },
    );
  }
}

// class MyHomePage extends StatefulWidget {
//   MyHomePage({Key? key}) : super(key: key);
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   @override
//   Widget build(BuildContext context) {
//     return YTPlayerTestScreen(
//       videoId: 'PY3mu1XmxL0', // PY3mu1XmxL0, Giagiyrp6T8
//     );
//   }
// }
