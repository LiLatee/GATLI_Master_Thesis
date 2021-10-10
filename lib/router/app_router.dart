import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:master_thesis/features/home_page/grid_items/activity/activity_page.dart';
import 'package:master_thesis/features/home_page/grid_items/admin_page/admin_page.dart';
import 'package:master_thesis/features/home_page/grid_items/questionnaire_page/questionnaire_page.dart';
import 'package:master_thesis/features/home_page/grid_items/thai_chi/thai_chi_intervention_page.dart';
import 'package:master_thesis/features/home_page/grid_items/thai_chi/thai_chi_lesson.dart';
import 'package:master_thesis/features/home_page/grid_items/thai_chi/thai_chi_page.dart';
import 'package:master_thesis/features/home_page/home_screen.dart';
import 'package:master_thesis/features/home_page/settings_page/set_avatar_page.dart';
import 'package:master_thesis/features/login/login_page.dart';

class AppRouter {
  Route? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case HomePage.routeName:
        return MaterialPageRoute(
          builder: (_) => const HomePage(),
        );
      case LoginPage.routeName:
        return MaterialPageRoute(
          builder: (_) => const LoginPage(),
        );
      case AdminPage.routeName:
        return MaterialPageRoute(
          builder: (_) => const AdminPage(),
        );
      case QuestionnairePage.routeName:
        return MaterialPageRoute(
          builder: (_) => const QuestionnairePage(),
        );
      case ActivityPage.routeName:
        return MaterialPageRoute(
          builder: (_) => ActivityPage(),
        );
      case ThaiChiPage.routeName:
        final args = settings.arguments as ThaiChiPageArguments;
        return MaterialPageRoute(
          builder: (_) => ThaiChiPage(
            thaiChiLesson: args.thaiChiLesson,
            thaiChiIntervention: args.thaiChiIntervention,
          ),
        );
      case ThaiChiInterventionPage.routeName:
        return MaterialPageRoute(
          builder: (_) => const ThaiChiInterventionPage(),
        );
      case SetAvatarPage.routeName:
        return SlideRightRoute(
          page: const SetAvatarPage(),
        );
    }
  }
}

class SlideRightRoute extends PageRouteBuilder {
  final Widget page;
  SlideRightRoute({required this.page})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
}
