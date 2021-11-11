import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:master_thesis/core/constants/image_paths.dart';

const lightLevelColors = {
  Level.BRONZE: Color(0xffAD8A56),
  Level.SILVER: Color(0xffB4B4B4),
  Level.GOLD: Color(0xffC9B037),
};

enum Level { BRONZE, SILVER, GOLD }

class Badge extends StatelessWidget {
  const Badge({
    required this.title,
    this.subtitle = '',
    required this.lightColor,
    required this.darkColor,
    required this.level,
    required this.icon,
  });

  final String title;
  final String subtitle;
  final Color lightColor;
  final Color darkColor;
  final Level level;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 95,
          child: Stack(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                    color: lightColor,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: darkColor,
                      width: 7,
                    )),
                child: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.black,
                  child: icon,
                ),
              ),
              Positioned(
                bottom: 0,
                left: 20,
                child: SvgPicture.asset(
                  badge2Icon,
                  color: lightLevelColors[level],
                  width: 40,
                  height: 40,
                ),
                // child: Icon(
                //   Icons.star,
                //   size: 40,
                //   color: lightLevelColors[badges[index].level],
                // ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(subtitle),
      ],
    );
  }
}

abstract class BadgesKeys {
  static const taiChiLevel1 = 'tai_chi_LEVEL1';
  static const taiChiLevel2 = 'tai_chi_LEVEL2';
  static const taiChiLevel3 = 'tai_chi_LEVEL3';
  static const stepsLevel1 = 'steps_LEVEL1';
  static const stepsLevel2 = 'steps_LEVEL2';
  static const stepsLevel3 = 'steps_LEVEL3';
  static const questionnaireFillerLevel1 = 'questionnaireFiller_LEVEL1';
  static const questionnaireFillerLevel2 = 'questionnaireFiller_LEVEL2';
  static const questionnaireFillerLevel3 = 'questionnaireFiller_LEVEL3';
  static const challanger30x30Level1 = 'challanger30x30_LEVEL1';
  static const challanger30x30Level2 = 'challanger30x30_LEVEL2';
  static const challanger30x30Level3 = 'challanger30x30_LEVEL3';
}

Widget? getBadgeUsingKey({required String badgeKey}) {
  final Map<String, Widget> badges = {
    BadgesKeys.challanger30x30Level1: Badge(
      title: 'Challenger',
      subtitle: '1 time',
      lightColor: const Color(0xff437356),
      darkColor: const Color(0xff365c45),
      level: Level.BRONZE,
      icon: Image.asset(
        distanceIcon,
        height: 50,
        width: 50,
      ),
    ),
    BadgesKeys.challanger30x30Level2: Badge(
      title: 'Challenger',
      subtitle: '5 times',
      lightColor: const Color(0xff437356),
      darkColor: const Color(0xff365c45),
      level: Level.SILVER,
      icon: Image.asset(
        distanceIcon,
        height: 50,
        width: 50,
      ),
    ),
    BadgesKeys.challanger30x30Level3: Badge(
      title: 'Challenger',
      subtitle: '10 times',
      lightColor: const Color(0xff437356),
      darkColor: const Color(0xff365c45),
      level: Level.GOLD,
      icon: Image.asset(
        distanceIcon,
        height: 50,
        width: 50,
      ),
    ),
    BadgesKeys.stepsLevel1: Badge(
      title: 'Walker',
      subtitle: '10 000 steps',
      lightColor: const Color(0xffFAE3B4),
      darkColor: const Color(0xfff5c563),
      level: Level.BRONZE,
      icon: Image.asset(
        footstepsIcon,
        height: 50,
        width: 50,
      ),
    ),
    BadgesKeys.stepsLevel2: Badge(
      title: 'Walker',
      subtitle: '100 000 steps',
      lightColor: const Color(0xffFAE3B4),
      darkColor: const Color(0xfff5c563),
      level: Level.SILVER,
      icon: Image.asset(
        footstepsIcon,
        height: 50,
        width: 50,
      ),
    ),
    BadgesKeys.stepsLevel3: Badge(
      title: 'Walker',
      subtitle: '1 000 000 steps',
      lightColor: const Color(0xffFAE3B4),
      darkColor: const Color(0xfff5c563),
      level: Level.GOLD,
      icon: Image.asset(
        footstepsIcon,
        height: 50,
        width: 50,
      ),
    ),
    BadgesKeys.taiChiLevel1: const Badge(
      title: 'Tai Chi',
      subtitle: '1 time',
      lightColor: Color(0xff7FB2F0),
      darkColor: Color(0xff624289),
      level: Level.BRONZE,
      icon: Icon(
        Icons.self_improvement,
        size: 50,
      ),
    ),
    BadgesKeys.taiChiLevel2: const Badge(
      title: 'Tai Chi',
      subtitle: '5 times',
      lightColor: Color(0xff7FB2F0),
      darkColor: Color(0xff624289),
      level: Level.SILVER,
      icon: Icon(
        Icons.self_improvement,
        size: 50,
      ),
    ),
    BadgesKeys.taiChiLevel3: const Badge(
      title: 'Tai Chi',
      subtitle: '10 times',
      lightColor: Color(0xff7FB2F0),
      darkColor: Color(0xff624289),
      level: Level.GOLD,
      icon: Icon(
        Icons.self_improvement,
        size: 50,
      ),
    ),
    BadgesKeys.questionnaireFillerLevel1: const Badge(
      title: 'Questionnainre filler',
      subtitle: '1 time',
      lightColor: Color(0xffFF6D1F),
      darkColor: Color(0xffe55000),
      level: Level.BRONZE,
      icon: Icon(
        Icons.poll,
        size: 50,
      ),
    ),
    BadgesKeys.questionnaireFillerLevel2: const Badge(
      title: 'Questionnainre filler',
      subtitle: '5 times',
      lightColor: Color(0xffFF6D1F),
      darkColor: Color(0xffe55000),
      level: Level.SILVER,
      icon: Icon(
        Icons.poll,
        size: 50,
      ),
    ),
    BadgesKeys.questionnaireFillerLevel3: const Badge(
      title: 'Questionnainre filler',
      subtitle: '10 times',
      lightColor: Color(0xffFF6D1F),
      darkColor: Color(0xffe55000),
      level: Level.GOLD,
      icon: Icon(
        Icons.poll,
        size: 50,
      ),
    ),
    // 'badgeWeekActivityTimeLevel1': Badge(
    //   title: context.l10n.runner,
    //   subtitle: '10 km',
    //   lightColor: const Color(0xffF34A53),
    //   darkColor: const Color(0xffee101c),
    //   level: Level.BRONZE,
    //   icon: const Icon(
    //     Icons.directions_run,
    //     size: 50,
    //   ),
    // ),
    // 'badgeKilometersLevel2': Badge(
    //   title: context.l10n.runner,
    //   subtitle: '100 km',
    //   lightColor: const Color(0xffF34A53),
    //   darkColor: const Color(0xffee101c),
    //   level: Level.SILVER,
    //   icon: const Icon(
    //     Icons.directions_run,
    //     size: 50,
    //   ),
    // ),
    // 'badgeKilometersLevel3': Badge(
    //   title: context.l10n.runner,
    //   subtitle: '1000 km',
    //   lightColor: const Color(0xffF34A53),
    //   darkColor: const Color(0xffee101c),
    //   level: Level.GOLD,
    //   icon: const Icon(
    //     Icons.directions_run,
    //     size: 50,
    //   ),
    // ),
  };

  return badges[badgeKey];
}
