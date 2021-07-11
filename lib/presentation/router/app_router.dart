import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:master_thesis/presentation/home_screen/home_screen.dart';
import 'package:master_thesis/presentation/set_profile_screen/set_avatar_screen.dart';

class AppRouterNames {
  static const String home = '/homeScreen';
  static const String setAvatarScreen = '/setAvatarScreen';
}

class AppRouter {
  Route? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRouterNames.home:
        return MaterialPageRoute(
          builder: (_) => HomeScreen(),
        );
      case AppRouterNames.setAvatarScreen:
        return MaterialPageRoute(
          builder: (_) => SetAvatarScreen(),
        );
    }
  }
}
