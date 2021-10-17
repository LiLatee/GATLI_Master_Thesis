//! SharedPreferences Keys
import 'package:flutter/material.dart';
import 'package:master_thesis/features/home_page/grid_items/30x30_challange/challange_30x30_page.dart';
import 'package:master_thesis/features/home_page/grid_items/questionnaire_page/questionnaire_intro_page.dart';
import 'package:master_thesis/features/home_page/grid_items/thai_chi/thai_chi_intervention_page.dart';

class SPKeys {
  static const theme = 'theme';
  // static const String languageCode = 'languageCode';

  static const String setProfile = 'setProfile';
}

class AppConstants {
  //! Durations
  // static const Duration splashScreenDuration = Duration(seconds: 1);

  //! Paddings
  static const double toScreenEdgePadding = 16;
  static const double homePageAvatarRadius = 30;

  static const double cornersRoundingRadius = 30;

  //! Other
  static const Map<String, dynamic> interventionsKeysMapper = {
    'thai_chi': {
      'name': 'Thai Chi',
      'routeName': ThaiChiInterventionPage.routeName,
      'icon': Icons.self_improvement,
    },
    'QLQ-C30': {
      'name': 'Questionnaire',
      'routeName': QuestionnaireIntroPage.routeName,
      'icon': Icons.poll,
    },
    '30x30_challange': {
      'name': '30x30 Challange',
      'routeName': Challange30x30Page.routeName,
      'icon': Icons.thirty_fps,
    },
  };
}
