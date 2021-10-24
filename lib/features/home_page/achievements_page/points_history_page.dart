import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:master_thesis/features/data/points_entry.dart';

import 'package:master_thesis/features/data/user_app.dart';

class PointsHistoryPage extends StatelessWidget {
  const PointsHistoryPage({
    Key? key,
    required this.userApp,
  }) : super(key: key);

  final UserApp userApp;

  static const String routeName = '/pointsHistory';

  @override
  Widget build(BuildContext context) {
    final List<PointsEntry> pointsEntries = userApp.pointsEntries
        .where((pointsEntry) => pointsEntry.points != 0)
        .toList();

    return Scaffold(
        appBar: AppBar(title: const Text('Points history')),
        body: ListView.builder(
          reverse: true,
          itemCount: pointsEntries.length,
          itemBuilder: (context, index) {
            final PointsEntry pointsEntry = pointsEntries[index];
            return ListTile(
              leading: Text(
                pointsEntry.points.toString(),
                style: Theme.of(context)
                    .textTheme
                    .headline6!
                    .copyWith(color: Theme.of(context).colorScheme.secondary),
              ),
              title: Text(pointsEntry.title),
              trailing: Text(DateFormat.yMd().format(pointsEntry.datetime!)),
            );
          },
        ));
  }
}
