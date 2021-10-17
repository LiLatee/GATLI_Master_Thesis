import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:master_thesis/core/constants/image_paths.dart';
import 'package:master_thesis/features/data/points_entry.dart';
import 'package:master_thesis/features/data/user_app.dart';
import 'package:master_thesis/features/data/users_repository.dart';
import 'package:master_thesis/features/home_page/achievements_page/points_history_page.dart';
import 'package:master_thesis/features/widgets/badges.dart';
import 'package:master_thesis/service_locator.dart';

// enum Level { BRONZE, SILVER, GOLD }

// class Badge {
//   Badge({
//     required this.name,
//     required this.lightColor,
//     required this.darkColor,
//     required this.level,
//     required this.icon,
//   });

//   final String name;
//   final Color lightColor;
//   final Color darkColor;
//   final Level level;
//   final Widget icon;
// }

// dark
// Color(0xffAF9500),
// Color(0xffD7D7D7),
// Color(0xff6A3805),
// light
// Color(0xffAD8A56),
// Color(0xffB4B4B4),
// Color(0xffC9B037),

// const lightLevelColors = {
//   Level.BRONZE: Color(0xffAD8A56),
//   Level.SILVER: Color(0xffB4B4B4),
//   Level.GOLD: Color(0xffC9B037),
// };

// final List<Widget> badges = [
//   Badge(
//     name: 'badge0',
//     lightColor: Color(0xffF34A53),
//     darkColor: Color(0xffee101c),
//     level: Level.BRONZE,
//     icon: Icon(
//       Icons.directions_run,
//       size: 50,
//     ),
//   ),
//   Badge(
//     name: 'badge0',
//     lightColor: Color(0xffF34A53),
//     darkColor: Color(0xffee101c),
//     level: Level.SILVER,
//     icon: Icon(
//       Icons.directions_run,
//       size: 50,
//     ),
//   ),
//   Badge(
//     name: 'badge0',
//     lightColor: Color(0xffF34A53),
//     darkColor: Color(0xffee101c),
//     level: Level.GOLD,
//     icon: Icon(
//       Icons.directions_run,
//       size: 50,
//     ),
//   ),
//   Badge(
//     name: 'badge1',
//     lightColor: Color(0xff437356),
//     darkColor: Color(0xff365c45),
//     level: Level.BRONZE,
//     icon: Image.asset(
//       distanceIcon,
//       height: 50,
//       width: 50,
//     ),
//   ),
//   Badge(
//     name: 'badge1',
//     lightColor: Color(0xff437356),
//     darkColor: Color(0xff365c45),
//     level: Level.SILVER,
//     icon: Image.asset(
//       distanceIcon,
//       height: 50,
//       width: 50,
//     ),
//   ),
//   Badge(
//     name: 'badge1',
//     lightColor: Color(0xff437356),
//     darkColor: Color(0xff365c45),
//     level: Level.GOLD,
//     icon: Image.asset(
//       distanceIcon,
//       height: 50,
//       width: 50,
//     ),
//   ),
//   Badge(
//     name: 'badge2',
//     lightColor: Color(0xffFAE3B4),
//     darkColor: Color(0xfff5c563),
//     level: Level.BRONZE,
//     icon: Image.asset(
//       footstepsIcon,
//       height: 50,
//       width: 50,
//     ),
//   ),
//   Badge(
//     name: 'badge2',
//     lightColor: Color(0xffFAE3B4),
//     darkColor: Color(0xfff5c563),
//     level: Level.SILVER,
//     icon: Image.asset(
//       footstepsIcon,
//       height: 50,
//       width: 50,
//     ),
//   ),
//   Badge(
//     name: 'badge2',
//     lightColor: Color(0xffFAE3B4),
//     darkColor: Color(0xfff5c563),
//     level: Level.GOLD,
//     icon: Image.asset(
//       footstepsIcon,
//       height: 50,
//       width: 50,
//     ),
//   ),
//   Badge(
//     name: 'badge3',
//     lightColor: Color(0xff7FB2F0),
//     darkColor: Color(0xff624289),
//     level: Level.BRONZE,
//     icon: Icon(
//       Icons.local_activity,
//       size: 50,
//     ),
//   ),
//   Badge(
//     name: 'badge3',
//     lightColor: Color(0xff7FB2F0),
//     darkColor: Color(0xff624289),
//     level: Level.SILVER,
//     icon: Icon(
//       Icons.local_activity,
//       size: 50,
//     ),
//   ),
//   Badge(
//     name: 'badge3',
//     lightColor: Color(0xff7FB2F0),
//     darkColor: Color(0xff624289),
//     level: Level.GOLD,
//     icon: Icon(
//       Icons.local_activity,
//       size: 50,
//     ),
//   ),
//   Badge(
//     name: 'badge4',
//     lightColor: Color(0xffFF6D1F),
//     darkColor: Color(0xffe55000),
//     level: Level.BRONZE,
//     icon: Icon(
//       Icons.directions_bike,
//       size: 50,
//     ),
//   ),
//   Badge(
//     name: 'badge4',
//     lightColor: Color(0xffFF6D1F),
//     darkColor: Color(0xffe55000),
//     level: Level.SILVER,
//     icon: Icon(
//       Icons.directions_bike,
//       size: 50,
//     ),
//   ),
//   Badge(
//     name: 'badge4',
//     lightColor: Color(0xffFF6D1F),
//     darkColor: Color(0xffe55000),
//     level: Level.GOLD,
//     icon: Icon(
//       Icons.directions_bike,
//       size: 50,
//     ),
//   ),
// ];

// const Map<String, List<Color>> badges = {
//   "badge0": [
//     Color(0xffF34A53),
//     Color(0xffee101c),
//   ],
//   "badge1": [
//     Color(0xff437356),
//     Color(0xff365c45),
//   ],
//   "badge2": [
//     Color(0xffFAE3B4),
//     Color(0xfff5c563),
//   ],
//   "badge3": [
//     Color(0xff7FB2F0),
//     Color(0xff3d8ae8),
//   ],
//   "badge4": [
//     Color(0xff7B52AB),
//     Color(0xff624289),
//   ],
//   "badge5": [
//     Color(0xffFF6D1F),
//     Color(0xffe55000),
//   ],
// };

class AchievementsPage extends StatelessWidget {
  const AchievementsPage({Key? key}) : super(key: key);

  // final myBadgesKeys = const ['badgeStepsLevel3', 'badgeKilometersLevel2'];

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: sl<UserRepository>().getStream(),
        builder: (
          BuildContext context,
          AsyncSnapshot<DocumentSnapshot> snapshot,
        ) {
          if (snapshot.hasData) {
            final UserApp userApp =
                UserApp.fromJson(snapshot.data!.data() as Map<String, dynamic>);

            // return _buildBadgesWidget(userApp);
            return SliverList(
              delegate: SliverChildListDelegate([
                _buildPointsWidget(context, userApp),
                _buildBadgesWidget(userApp),
              ]),
            );
          } else {
            return const SliverToBoxAdapter(
              child: Center(
                child: Text('No data.'),
              ),
            );
          }
        });
  }

  Widget _buildPointsWidget(BuildContext context, UserApp userApp) {
    final int overallPoints = userApp.pointsEntries.fold(
        0,
        (int previousValue, PointsEntry pointsEntry) =>
            previousValue + pointsEntry.points);

    return Card(
      child: ListTile(
        title: Row(
          children: [
            Text(
              'Overall points:',
              style: Theme.of(context).textTheme.subtitle1,
            ),
            const SizedBox(width: 8),
            Text(
              overallPoints.toString(),
              style: Theme.of(context).textTheme.subtitle1!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.secondaryVariant,
                  ),
            ),
          ],
        ),
        onTap: () => Navigator.pushNamed(context, PointsHistoryPage.routeName,
            arguments: userApp),
      ),
    );
  }

  Widget _buildBadgesWidget(UserApp userApp) {
    final badgesMap = _countOccurences(userApp.badgesKeys);

    return GridView.builder(
      itemCount: badgesMap.length,
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      primary: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisExtent: 150,
      ),
      itemBuilder: (BuildContext context, int index) {
        final String badgeKey;
        if (badgesMap.keys.toList()[index] == BadgesKeys.thaiChiLevel1) {
          if (badgesMap.values.toList()[index] == 2) {
            badgeKey = BadgesKeys.thaiChiLevel2;
          } else if (badgesMap.values.toList()[index] > 2) {
            badgeKey = BadgesKeys.thaiChiLevel3;
          } else {
            badgeKey = BadgesKeys.thaiChiLevel1;
          }
        } else {
          badgeKey = badgesMap.keys.toList()[index];
        }

        return Card(
          child: getBadgeUsingKey(context: context, badgeKey: badgeKey),
        );
      },
    );

    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisExtent: 150,
      ),
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          final String badgeKey;
          if (badgesMap.keys.toList()[index] == BadgesKeys.thaiChiLevel1) {
            if (badgesMap.values.toList()[index] == 2) {
              badgeKey = BadgesKeys.thaiChiLevel2;
            } else if (badgesMap.values.toList()[index] > 2) {
              badgeKey = BadgesKeys.thaiChiLevel3;
            } else {
              badgeKey = BadgesKeys.thaiChiLevel1;
            }
          } else {
            badgeKey = badgesMap.keys.toList()[index];
          }

          return Card(
            child: getBadgeUsingKey(context: context, badgeKey: badgeKey),
          );
        },
        childCount: badgesMap.length,
      ),
    );
  }

  Map<String, int> _countOccurences(List<dynamic> list) {
    final map = <String, int>{};

    // ignore: avoid_function_literals_in_foreach_calls
    list.forEach((element) {
      if (!map.containsKey(element)) {
        map[element] = 1;
      } else {
        map[element] = map[element]! + 1;
      }
    });
    return map;
  }
}


///! Ramki w kolorze poziomu
// class AchievementsPage extends StatelessWidget {
//   const AchievementsPage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return SliverGrid(
//       gridDelegate:
//           SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
//       delegate: SliverChildBuilderDelegate(
//         (BuildContext context, int index) {
//           log(index.toString());
//           log('badge${(index / 3).floor()}');
//           log('${(index % 3) + 1}');
//           log('------------');
//           return Card(
//             child: Column(
//               children: [
//                 Container(
//                   width: 80,
//                   height: 80,
//                   decoration: BoxDecoration(
//                       color: badges['badge${(index / 3).floor()}']![0],
//                       shape: BoxShape.circle,
//                       border: Border.all(
//                         color: badges['badge${(index / 3).floor()}']![
//                             (index % 3) + 1],
//                         width: 7,
//                       )),
//                   child: Text('asdas'),
//                 ),
//                 SizedBox(height: 16),
//                 Text("Biegacz 2"),
//               ],
//             ),
//           );
//         },
//         childCount: badges.length * 3,
//       ),
//     );
//   }
// }
