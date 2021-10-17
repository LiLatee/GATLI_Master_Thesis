import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
              return _buildContent(context: context, userApp: _userApp);
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }

  Widget _buildContent({
    required BuildContext context,
    required UserApp userApp,
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(
                'Hello!',
                style: Theme.of(context).textTheme.headline5!.copyWith(
                      color: Theme.of(context).colorScheme.primaryVariant,
                    ),
              ),
              const SizedBox(height: 8),
              RichText(
                text: TextSpan(
                  text:
                      'Here you are able to monitor your physical activity, by pressing ',
                  style: Theme.of(context).textTheme.subtitle1,
                  children: [
                    TextSpan(
                      text: '+ Track activity',
                      style: Theme.of(context).textTheme.subtitle1!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.secondary),
                    ),
                    const TextSpan(
                        text: ' button and also see your past activities. 🚴'),
                  ],
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: userApp.activitySessions.length + 1,
            itemBuilder: (context, index) {
              if (index == userApp.activitySessions.length) {
                return const SizedBox(height: 64);
              } else {
                return _buildListTile(
                  context: context,
                  activitySession: userApp.activitySessions[index],
                );
              }
            },
          ),
        ),
      ],
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
