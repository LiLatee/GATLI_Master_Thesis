import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:master_thesis/features/data/user_app.dart';
import 'package:master_thesis/features/data/users_repository.dart';
import 'package:master_thesis/features/home_page/grid_items/activity/activity_page.dart';
import 'package:master_thesis/features/home_page/grid_items/activity/activity_session.dart';
import 'package:master_thesis/service_locator.dart';

class ActivityHistoryPage extends StatelessWidget {
  static const String routeName = '/historyActivity';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your activity history'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, ActivityPage.routeName),
        label: const Text('Track activity'),
        icon: const Icon(Icons.add),
      ),
      body: StreamBuilder<DocumentSnapshot>(
          stream: sl<UserRepository>().getStream(),
          builder: (
            BuildContext context,
            AsyncSnapshot<DocumentSnapshot> snapshot,
          ) {
            if (snapshot.hasData) {
              final _userApp = UserApp.fromJson(
                  snapshot.data!.data() as Map<String, dynamic>);
              return ListView.builder(
                itemCount: _userApp.activitySessions.length,
                itemBuilder: (context, index) {
                  return _buildListTile(
                    context: context,
                    activitySession: _userApp.activitySessions[index],
                  );
                },
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }

  ListTile _buildListTile({
    required BuildContext context,
    required ActivitySession activitySession,
  }) {
    return ListTile(
      title: Text(DateFormat.yMMMMd().format(activitySession.startTime)),
      subtitle: Row(
        children: [
          Text(DateFormat.Hm().format(activitySession.startTime)),
          const SizedBox(width: 4),
          const Icon(
            Icons.arrow_forward,
            size: 16,
          ),
          const SizedBox(width: 4),
          Text(DateFormat.Hm().format(activitySession.endTime!)),
        ],
      ),
      leading: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            activitySession.minutesOfActivity.toString(),
            style: Theme.of(context).textTheme.headline5,
          ),
          const Text('mins'),
        ],
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            activitySession.steps.toString(),
            style: Theme.of(context).textTheme.headline5,
          ),
          const Text('steps'),
        ],
      ),
    );
  }
}
