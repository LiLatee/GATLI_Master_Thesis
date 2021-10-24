import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:master_thesis/core/constants/app_constants.dart';
import 'package:master_thesis/features/data/user_app.dart';
import 'package:master_thesis/features/data/users_repository.dart';
import 'package:master_thesis/features/home_page/grid_items/activity/activity_cubit.dart';
import 'package:master_thesis/features/home_page/grid_items/activity/activity_history_page.dart';
import 'package:master_thesis/features/home_page/grid_items/admin_page/admin_page.dart';
import 'package:master_thesis/features/home_page/grid_items/tai_chi/tai_chi_lesson.dart';
import 'package:master_thesis/features/home_page/grid_items/tai_chi/tai_chi_page.dart';
import 'package:master_thesis/service_locator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ActionsGridView extends StatelessWidget {
  const ActionsGridView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: StreamBuilder<DocumentSnapshot>(
          stream: sl<UserRepository>().getStream(),
          builder: (
            BuildContext context,
            AsyncSnapshot<DocumentSnapshot> snapshot,
          ) {
            if (snapshot.hasData) {
              final UserApp userApp = UserApp.fromJson(
                  snapshot.data!.data() as Map<String, dynamic>);
              return _buildGrid(context: context, userApp: userApp);
            } else {
              return _buildNoData();
            }
          }),
    );
  }

  Widget _buildNoData() {
    return const SliverToBoxAdapter(
      child: Center(
        child: Text('No data.'),
      ),
    );
  }

  SliverGrid _buildGrid(
      {required BuildContext context, required UserApp userApp}) {
    final interventionsWidgets = userApp.activeInterventions.keys.map(
      (String key) {
        bool isDoneToday = false;
        if (key == 'tai_chi') {
          if (sl<SharedPreferences>().containsKey(TaiChiPage.lastTaiChiDate)) {
            final DateTime lastThaiChiDate = DateTime.parse(
                sl<SharedPreferences>().getString(TaiChiPage.lastTaiChiDate)!);
            final DateTime now = DateTime.now().toUtc();
            final DateTime today = DateTime(now.year, now.month, now.day);
            if (today.compareTo(lastThaiChiDate) == 0) {
              isDoneToday = true;
            }
          }
        } else if (key == '30x30_challange') {
          if (sl<SharedPreferences>()
              .containsKey(ActivityCubit.last30MinActivityDoneDate)) {
            final DateTime last30MinActivityDoneDate = DateTime.parse(
                sl<SharedPreferences>()
                    .getString(ActivityCubit.last30MinActivityDoneDate)!);
            final DateTime now = DateTime.now().toUtc();
            final DateTime today = DateTime(now.year, now.month, now.day);
            if (today.compareTo(last30MinActivityDoneDate) == 0) {
              isDoneToday = true;
            }
          }
        }

        return GestureDetector(
          child: Card(
            color: Theme.of(context).colorScheme.primary,
            elevation: 4,
            child: GridTile(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Opacity(
                        opacity: 0.1,
                        child: FittedBox(
                          fit: BoxFit.fill,
                          child: Icon(AppConstants.interventionsKeysMapper[key]
                              ['icon']),
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        AppConstants.interventionsKeysMapper[key]['name'],
                        style: Theme.of(context).textTheme.headline5,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    if (isDoneToday)
                      Positioned(
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Icon(
                            Icons.done_outline,
                            color:
                                Theme.of(context).colorScheme.secondaryVariant,
                            size: 36,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          onTap: () {
            if (isDoneToday) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('You have done this today. Back tomorrow 😊')));
              return;
            } else {
              Navigator.pushNamed(context,
                  AppConstants.interventionsKeysMapper[key]['routeName'],
                  arguments: taiChiLessons[0]);
            }
          },
        );
      },
    ).toList();

    final activitiesWidget = GestureDetector(
      child: Card(
        color: Theme.of(context).colorScheme.primary,
        elevation: 4,
        child: GridTile(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Stack(
              children: [
                const Positioned.fill(
                  child: Opacity(
                    opacity: 0.1,
                    child: FittedBox(
                      fit: BoxFit.fill,
                      child: Icon(Icons.directions_run),
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    'Activities',
                    style: Theme.of(context).textTheme.headline5,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      onTap: () => Navigator.pushNamed(context, ActivityHistoryPage.routeName),
    );

    final adminWidget = GestureDetector(
      child: Card(
        elevation: 4,
        color: Theme.of(context).colorScheme.secondary,
        child: GridTile(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Stack(
              children: [
                const Positioned.fill(
                  child: Opacity(
                    opacity: 0.1,
                    child: FittedBox(
                      fit: BoxFit.fill,
                      child: Icon(Icons.admin_panel_settings),
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    'Admin panel',
                    style: Theme.of(context).textTheme.headline5,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      onTap: () => Navigator.pushNamed(context, AdminPage.routeName,
          arguments: taiChiLessons[0]),
    );

    final testWidget = GestureDetector(
      child: Card(
        // color: Theme.of(context).colorScheme.primary,
        elevation: 4,
        child: GridTile(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: Text(
                'Test',
                style: Theme.of(context).textTheme.headline5,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
      // onTap: () => Navigator.pushNamed(context, TestFit.routeName),
    );

    return SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          crossAxisCount: 2,
        ),
        delegate: SliverChildListDelegate(interventionsWidgets +
            [
              activitiesWidget,
              adminWidget,
              // testWidget,
            ]));
  }
}
