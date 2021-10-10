import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:master_thesis/core/constants/app_constants.dart';
import 'package:master_thesis/features/data/user_app.dart';
import 'package:master_thesis/features/data/users_repository.dart';
import 'package:master_thesis/features/home_page/grid_items/activity/activity_page.dart';
import 'package:master_thesis/features/home_page/grid_items/admin_page/admin_page.dart';
import 'package:master_thesis/features/home_page/grid_items/questionnaire_page/questionnaire_page.dart';
import 'package:master_thesis/features/home_page/grid_items/thai_chi/thai_chi_lesson.dart';
import 'package:master_thesis/service_locator.dart';

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
    final interventionsWidgets = userApp.activeInterventions.keys
        .map(
          (String key) => GestureDetector(
            child: Card(
              color: Theme.of(context).colorScheme.primary,
              elevation: 4,
              child: GridTile(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Center(
                    child: Text(
                      AppConstants.interventionsKeysMapper[key]['name'],
                      style: Theme.of(context).textTheme.headline5,
                    ),
                  ),
                ),
              ),
            ),
            onTap: () => Navigator.pushNamed(
                context, AppConstants.interventionsKeysMapper[key]['routeName'],
                arguments: thaiChiLessons[0]),
          ),
        )
        .toList();

    final adminWidget = GestureDetector(
      child: Card(
        // color: Theme.of(context).colorScheme.primary,
        elevation: 4,
        child: GridTile(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: Text(
                'Admin panel',
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
          ),
        ),
      ),
      onTap: () => Navigator.pushNamed(context, AdminPage.routeName,
          arguments: thaiChiLessons[0]),
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
              ),
            ),
          ),
        ),
      ),
      onTap: () => Navigator.pushNamed(context, ActivityPage.routeName),
    );

    return SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          crossAxisCount: 2,
        ),
        delegate: SliverChildListDelegate(
            interventionsWidgets + [adminWidget, testWidget]));
  }
}
