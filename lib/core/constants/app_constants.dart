//! SharedPreferences Keys
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
    },
  };
}

// const Map<String, List<Color>> badges = {
// "badge1": [Color(0xfff34a53), Color(0xff53f34a),],
// };
