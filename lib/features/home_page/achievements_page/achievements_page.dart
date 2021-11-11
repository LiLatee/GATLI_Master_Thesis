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
    // final badgesMap = _countOccurences(userApp.badgesKeys);
    // final userMockedBadgesKeys = [
    //   BadgesKeys.challanger30x30Level1,
    //   BadgesKeys.challanger30x30Level2,
    //   BadgesKeys.challanger30x30Level3,
    //   BadgesKeys.taiChiLevel1,
    //   BadgesKeys.taiChiLevel2,
    //   BadgesKeys.taiChiLevel3,
    //   BadgesKeys.questionnaireFillerLevel1,
    //   BadgesKeys.questionnaireFillerLevel2,
    //   BadgesKeys.questionnaireFillerLevel3,
    //   BadgesKeys.stepsLevel1,
    //   BadgesKeys.stepsLevel2,
    //   BadgesKeys.stepsLevel3,
    // ];
    // final badgesKeys = _determineBadges(userMockedBadgesKeys);

    final badgesKeys = _determineBadges(userApp.badgesKeys);

    return GridView.builder(
      itemCount: badgesKeys.length,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      primary: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisExtent: 170,
      ),
      itemBuilder: (BuildContext context, int index) {
        return Card(
          child: getBadgeUsingKey(badgeKey: badgesKeys[index]),
        );
      },
    );
  }

  List<String> _determineBadges(List<dynamic> list) {
    final map = <String, int>{};

    // ignore: avoid_function_literals_in_foreach_calls
    list.forEach((element) {
      if (!map.containsKey(element)) {
        map[element] = 1;
      } else {
        map[element] = map[element]! + 1;
      }
    });

    const int goldThreshold = 10;
    const int silverThreshold = 5;
    const int bronzeThreshold = 1;

    final List<String> resultListOfBadges = [];
    map.forEach((key, value) {
      if (value >= goldThreshold) {
        resultListOfBadges.add(key);
        if (key == BadgesKeys.challanger30x30Level1) {
          resultListOfBadges.add(BadgesKeys.challanger30x30Level2);
          resultListOfBadges.add(BadgesKeys.challanger30x30Level3);
        } else if (key == BadgesKeys.questionnaireFillerLevel1) {
          resultListOfBadges.add(BadgesKeys.questionnaireFillerLevel2);
          resultListOfBadges.add(BadgesKeys.questionnaireFillerLevel3);
        } else if (key == BadgesKeys.taiChiLevel1) {
          resultListOfBadges.add(BadgesKeys.taiChiLevel2);
          resultListOfBadges.add(BadgesKeys.taiChiLevel3);
        }
      } else if (value >= silverThreshold) {
        resultListOfBadges.add(key);
        if (key == BadgesKeys.challanger30x30Level1) {
          resultListOfBadges.add(BadgesKeys.challanger30x30Level2);
        } else if (key == BadgesKeys.questionnaireFillerLevel1) {
          resultListOfBadges.add(BadgesKeys.questionnaireFillerLevel2);
        } else if (key == BadgesKeys.taiChiLevel1) {
          resultListOfBadges.add(BadgesKeys.taiChiLevel2);
        }
      } else if (value >= bronzeThreshold) {
        resultListOfBadges.add(key);
      }
    });
    return resultListOfBadges;
    // return map;
  }
}
