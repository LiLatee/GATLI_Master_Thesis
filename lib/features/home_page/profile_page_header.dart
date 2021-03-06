import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttermoji/fluttermojiCircleAvatar.dart';
import 'package:master_thesis/core/constants/app_constants.dart';
import 'package:master_thesis/core/constants/image_paths.dart';
import 'package:master_thesis/core/l10n/l10n.dart';
import 'package:master_thesis/features/data/user_app.dart';
import 'package:master_thesis/features/home_page/grid_items/activity/activity_session.dart';

class ProfilePageHeader extends SliverPersistentHeaderDelegate {
  ProfilePageHeader({
    required this.minExtent,
    required this.maxExtent,
    required this.userApp,
    this.stepsToday = 0,
    this.metersOfMoveToday = 0,
  });

  @override
  final double minExtent;
  @override
  final double maxExtent;

  final int stepsToday;
  final int metersOfMoveToday;

  final UserApp userApp;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Card(
            elevation: 8,
            color: Theme.of(context).colorScheme.primary,
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(AppConstants.cornersRoundingRadius),
            ),
          ),
        ),
        Positioned(
          top: 8.0,
          child: Row(
            children: [
              FluttermojiCircleAvatar(
                radius: AppConstants.homePageAvatarRadius,
                backgroundColor: Colors.transparent,
              ),
              const SizedBox(width: 8.0),
              Text(
                userApp.nickname,
                style: Theme.of(context).textTheme.headline5,
              ),
            ],
          ),
        ),
        _buildContent(context, shrinkOffset, userApp),
      ],
    );
  }

  Widget _buildContent(
      BuildContext context, double shrinkOffset, UserApp userApp) {
    return Positioned(
      top: 2 * AppConstants.homePageAvatarRadius,
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            const Divider(thickness: 3, height: 0),
            const SizedBox(height: 8),
            _buildTodaysStatistics(context, userApp),
          ],
        ),
      ),
    );
  }

  Widget _buildTodaysStatistics(BuildContext context, UserApp userApp) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              context.l10n.todaysStatistics,
              style: Theme.of(context).textTheme.headline6,
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildStepsAndDistance(context),
            _buildCheckboxes(context, userApp),
          ],
        ),
        // const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildCheckboxes(BuildContext context, UserApp userApp) {
    // final bool wasActivityAbove30Mins = _checkTodayActivity(userApp);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Row(
        //   children: [
        //     const Icon(Icons.check_box_outlined),
        //     const SizedBox(width: 8),
        //     Text(
        //       context.l10n.taiChi,
        //       style:
        //           Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: 16),
        //     ),
        //   ],
        // ),
        // const SizedBox(height: 8),
        // Row(
        //   children: [
        //     Icon(wasActivityAbove30Mins
        //         ? Icons.check_box_outlined
        //         : Icons.check_box_outline_blank),
        //     const SizedBox(width: 8),
        //     Text(
        //       context.l10n.anyPhysicalActivity,
        //       style:
        //           Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: 16),
        //     ),
        //   ],
        // ),
        // const SizedBox(height: 8),
        Row(
          children: [
            Image.asset(
              distanceIcon,
              height: 20,
              width: 20,
            ),
            const SizedBox(width: 8),
            Text(
              '${metersOfMoveToday / 1000} km',
              style:
                  Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: 16),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStepsAndDistance(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Image.asset(
              footstepsIcon,
              height: 20,
              width: 20,
            ),
            const SizedBox(width: 8),
            Text(
              '$stepsToday ',
              style:
                  Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: 16),
            ),
            Text(
              context.l10n.steps,
              style:
                  Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: 16),
            ),
          ],
        ),
        // const SizedBox(height: 8),
        // Row(
        //   children: [
        //     Image.asset(
        //       distanceIcon,
        //       height: 20,
        //       width: 20,
        //     ),
        //     const SizedBox(width: 8),
        //     Text(
        //       '${userApp.kilometers} km',
        //       style:
        //           Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: 16),
        //     ),
        //   ],
        // ),
      ],
    );
  }

  // ignore: unused_element
  Widget _buildOverallStatistics(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              'Overall statistics:',
              style: Theme.of(context).textTheme.headline6,
            ),
          ],
        ),
        const SizedBox(height: 8),
        Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                // Image.asset(
                //   'assets/footsteps-silhouette-variant.png',
                //   height: 30,
                //   width: 30,
                // ),
                const SizedBox(width: 8),
                Text(
                  'All collected badges: ',
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  '8 ',
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              ],
            ),
            Row(
              children: [
                const SizedBox(width: 16),
                Image.asset(
                  'assets/distance.png',
                  height: 30,
                  width: 30,
                ),
                const SizedBox(width: 8),
                Text(
                  '3.4 km',
                  style: Theme.of(context).textTheme.headline5,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  double titleOpacity(double shrinkOffset) {
    // simple formula: fade out text as soon as shrinkOffset > 0
    return 1.0 - math.max(0.0, shrinkOffset) / maxExtent;
    // more complex formula: starts fading out text when shrinkOffset > minExtent
    //return 1.0 - max(0.0, (shrinkOffset - minExtent)) / (maxExtent - minExtent);
  }

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }

  // ignore: unused_element
  bool _checkTodayActivity(UserApp userApp) {
    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);

    final List<ActivitySession> todaysActivities =
        userApp.activitySessions.where((element) {
      final DateTime activityDay = DateTime(
        element.startTime.year,
        element.startTime.month,
        element.startTime.day,
      );

      if (activityDay.compareTo(today) == 0) {
        return true;
      } else {
        return false;
      }
    }).toList();

    final int todaysMinutesOfActivity = todaysActivities.fold(
        0,
        (int previousValue, element) =>
            previousValue + element.minutesOfActivity);

    if (todaysMinutesOfActivity >= 30) {
      return true;
    } else {
      return false;
    }
  }
}
