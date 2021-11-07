//! SharedPreferences Keys
import 'package:flutter/material.dart';
import 'package:master_thesis/features/home_page/grid_items/30x30_challenge/challenge_30x30_page.dart';
import 'package:master_thesis/features/home_page/grid_items/questionnaire_page/questionnaire_intro_page.dart';
import 'package:master_thesis/features/home_page/grid_items/tai_chi/tai_chi_intervention_page.dart';

class SPKeys {
  static const theme = 'theme';
  // static const String languageCode = 'languageCode';

  static const String setProfile = 'setProfile';
}

abstract class AppConstants {
  //! Durations
  // static const Duration splashScreenDuration = Duration(seconds: 1);

  //! Paddings
  static const double toScreenEdgePadding = 16;
  static const double homePageAvatarRadius = 30;

  static const double cornersRoundingRadius = 30;

  //! Other
  static const Map<String, dynamic> interventionsKeysMapper = {
    'tai_chi': {
      'name': 'Tai Chi',
      'routeName': TaiChiInterventionPage.routeName,
      'icon': Icons.self_improvement,
    },
    'QLQ-C30': {
      'name': 'Question-naire',
      'routeName': QuestionnaireIntroPage.routeName,
      'icon': Icons.poll,
    },
    '30x30_challange': {
      'name': '30x30 Challenge',
      'routeName': Challenge30x30Page.routeName,
      'icon': Icons.thirty_fps,
    },
  };
}
