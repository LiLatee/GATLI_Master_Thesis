import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:master_thesis/features/data/points_entry.dart';
import 'package:master_thesis/features/data/user_app.dart';
import 'package:master_thesis/features/data/users_repository.dart';
import 'package:master_thesis/features/home_page/achievements_page/points_history_page.dart';
import 'package:master_thesis/features/widgets/badges.dart';
import 'package:master_thesis/service_locator.dart';

class AchievementsPage extends StatelessWidget {
  const AchievementsPage({Key? key}) : super(key: key);

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
    log('userApp.badgesKeys: ${userApp.badgesKeys.toString()}');

    log('badgesMap: ${badgesMap.toString()}');

    return GridView.builder(
      itemCount: badgesMap.length,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      primary: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisExtent: 150,
      ),
      itemBuilder: (BuildContext context, int index) {
        final String badgeKey;
        if (badgesMap.keys.toList()[index] == BadgesKeys.taiChiLevel1) {
          if (badgesMap.values.toList()[index] == 2) {
            badgeKey = BadgesKeys.taiChiLevel2;
          } else if (badgesMap.values.toList()[index] > 2) {
            badgeKey = BadgesKeys.taiChiLevel3;
          } else {
            badgeKey = BadgesKeys.taiChiLevel1;
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
          if (badgesMap.keys.toList()[index] == BadgesKeys.taiChiLevel1) {
            if (badgesMap.values.toList()[index] == 2) {
              badgeKey = BadgesKeys.taiChiLevel2;
            } else if (badgesMap.values.toList()[index] > 2) {
              badgeKey = BadgesKeys.taiChiLevel3;
            } else {
              badgeKey = BadgesKeys.taiChiLevel1;
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
