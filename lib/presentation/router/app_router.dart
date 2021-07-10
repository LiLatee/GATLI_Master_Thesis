import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:master_thesis/presentation/home_screen/home_screen.dart';

class AppRouterNames {
  static const String home = '/homeScreen';
}

class AppRouter {
  Route? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRouterNames.home:
        return MaterialPageRoute(
          builder: (_) => HomeScreen(),
        );
    }
  }
}
