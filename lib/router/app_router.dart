import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:master_thesis/features/data/user_app.dart';
import 'package:master_thesis/features/home_page/achievements_page/points_history_page.dart';
import 'package:master_thesis/features/home_page/grid_items/30x30_challenge/challenge_30x30_page.dart';
import 'package:master_thesis/features/home_page/grid_items/activity/activity_history_page.dart';
import 'package:master_thesis/features/home_page/grid_items/activity/activity_page.dart';
import 'package:master_thesis/features/home_page/grid_items/admin_page/admin_page.dart';
import 'package:master_thesis/features/home_page/grid_items/questionnaire_page/questionnaire_intro_page.dart';
import 'package:master_thesis/features/home_page/grid_items/questionnaire_page/questionnaire_page.dart';
import 'package:master_thesis/features/home_page/grid_items/tai_chi/tai_chi_intervention_page.dart';
import 'package:master_thesis/features/home_page/grid_items/tai_chi/tai_chi_page.dart';
import 'package:master_thesis/features/home_page/home_screen.dart';
import 'package:master_thesis/features/home_page/settings_page/set_avatar_page.dart';
import 'package:master_thesis/features/home_page/week_stats.dart';
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
      case PointsHistoryPage.routeName:
        return MaterialPageRoute(
          builder: (_) =>
              PointsHistoryPage(userApp: settings.arguments as UserApp),
        );
      case QuestionnaireIntroPage.routeName:
        return MaterialPageRoute(
          builder: (_) => const QuestionnaireIntroPage(),
        );
      case QuestionnairePage.routeName:
        return MaterialPageRoute(
          builder: (_) => const QuestionnairePage(),
        );
      case ActivityPage.routeName:
        return MaterialPageRoute(
          builder: (_) => ActivityPage(),
        );
      case ActivityHistoryPage.routeName:
        return MaterialPageRoute(
          builder: (_) => ActivityHistoryPage(),
        );
      case Challenge30x30Page.routeName:
        return MaterialPageRoute(
          builder: (_) => const Challenge30x30Page(),
        );
      case TaiChiPage.routeName:
        final args = settings.arguments as TaiChiPageArguments;
        return MaterialPageRoute(
          builder: (_) => TaiChiPage(
            taiChiLesson: args.taiChiLesson,
            taiChiIntervention: args.taiChiIntervention,
          ),
        );
      case TaiChiInterventionPage.routeName:
        return MaterialPageRoute(
          builder: (_) => const TaiChiInterventionPage(),
        );
      case WeekStats.routeName:
        final WeekStatsArguments args =
            settings.arguments as WeekStatsArguments;
        return MaterialPageRoute(
          builder: (_) => WeekStats(args: args),
        );
      case SetAvatarPage.routeName:
        final bool fromSettings;
        if (settings.arguments == null) {
          fromSettings = false;
        } else {
          fromSettings = settings.arguments as bool;
        }
        return SlideRightRoute(
          page: SetAvatarPage(fromSettings: fromSettings),
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
