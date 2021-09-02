import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttermoji/fluttermojiCircleAvatar.dart';
import 'package:master_thesis/core/constants/app_constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:master_thesis/core/constants/image_paths.dart';

class ProfilePageHeader extends SliverPersistentHeaderDelegate {
  ProfilePageHeader({
    required this.minExtent,
    required this.maxExtent,
  });
  @override
  final double minExtent;
  @override
  final double maxExtent;

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
        // Container(
        //   margin: const EdgeInsets.all(4),
        //   decoration: BoxDecoration(
        //     color: Theme.of(context).colorScheme.primary,
        //     gradient: const LinearGradient(
        //         colors: [Color(0xff1D976C), Color(0xff93F9B9)]),
        //     borderRadius:
        //         BorderRadius.circular(AppConstants.cornersRoundingRadius),
        //   ),
        // ),
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
                "Marcin Hradowicz",
                style: Theme.of(context).textTheme.headline5,
              ),
            ],
          ),
        ),
        _buildContent(context, shrinkOffset),
      ],
    );
  }

  Widget _buildContent(BuildContext context, double shrinkOffset) {
    return Positioned(
      top: 2 * AppConstants.homePageAvatarRadius,
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            const Divider(thickness: 3, height: 0),
            const SizedBox(height: 8),
            _buildTodaysStatistics(context),
          ],
        ),
      ),
    );
  }

  Widget _buildTodaysStatistics(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              // "Today's statistics:",
              AppLocalizations.of(context)!.todaysStatistics,

              style: Theme.of(context).textTheme.headline6,
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildStepsAndDistance(context),
            _buildCheckboxes(context),
          ],
        ),
        // const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildCheckboxes(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.check_box_outlined),
            const SizedBox(width: 8),
            Text(
              // "Thai Chi Exercise",
              AppLocalizations.of(context)!.thaiChi,

              style:
                  Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: 16),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(Icons.check_box_outline_blank),
            const SizedBox(width: 8),
            Text(
              // "Any physical activity",
              AppLocalizations.of(context)!.anyPhysicalActivity,
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
              "1230 ",
              style:
                  Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: 16),
            ),
            Text(
              AppLocalizations.of(context)!.steps,
              style:
                  Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: 16),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Image.asset(
              distanceIcon,
              height: 20,
              width: 20,
            ),
            const SizedBox(width: 8),
            Text(
              "3.4 km",
              style:
                  Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: 16),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildOverallStatistics(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              "Overall statistics:",
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
                  "All collected badges: ",
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  "8 ",
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
                  "3.4 km",
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
    return 1.0 - max(0.0, shrinkOffset) / maxExtent;
    // more complex formula: starts fading out text when shrinkOffset > minExtent
    //return 1.0 - max(0.0, (shrinkOffset - minExtent)) / (maxExtent - minExtent);
  }

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
