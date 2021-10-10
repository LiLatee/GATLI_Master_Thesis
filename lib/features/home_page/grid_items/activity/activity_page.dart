import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:master_thesis/features/home_page/grid_items/activity/activity_cubit.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timeline_tile/timeline_tile.dart';

class MyActivityDuration extends MyActivity {
  int durationInMinutes;

  MyActivityDuration({
    required MyActivity myActivity,
    required this.durationInMinutes,
  }) : super(
          confidence: myActivity.confidence,
          isActive: myActivity.isActive,
          timestamp: myActivity.timestamp,
          type: myActivity.type,
          isEnd: myActivity.isEnd,
          isStart: myActivity.isStart,
        );
  @override
  List<Object?> get props => super.props + [durationInMinutes];
}

class ActivityPage extends StatefulWidget {
  @override
  _ActivityPageState createState() => _ActivityPageState();

  static const String routeName = '/activityPage';
}

class _ActivityPageState extends State<ActivityPage> {
  late final ActivityCubit cubit;

  @override
  void initState() {
    super.initState();
    cubit = ActivityCubit();
    askPermission();
  }

  Future<void> askPermission() async {
    if (Platform.isAndroid) {
      if (await Permission.activityRecognition.request().isGranted) {}
    }
  }

  @override
  void dispose() {
    cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: cubit,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Activity Recognition Demo'),
        ),
        body: BlocBuilder<ActivityCubit, ActivityState>(
          builder: (context, state) {
            if (state is ActivityStateLoaded) {
              final events = state.activities;
              final List<MyActivityDuration> activitiesWithDuration = [];

              events.asMap().forEach((int index, MyActivity myActivity) {
                if (index == 0) {
                  activitiesWithDuration.add(MyActivityDuration(
                    myActivity: myActivity,
                    durationInMinutes: 0,
                  ));
                } else {
                  final int indexToModify = activitiesWithDuration.length == 1
                      ? 0
                      : activitiesWithDuration.length - 1;
                  activitiesWithDuration[indexToModify].durationInMinutes =
                      myActivity.timestamp
                          .difference(
                              activitiesWithDuration[indexToModify].timestamp)
                          .inMinutes;

                  if (activitiesWithDuration[indexToModify].isEnd) {
                    activitiesWithDuration.add(MyActivityDuration(
                        myActivity: myActivity, durationInMinutes: 0));
                  } else if (activitiesWithDuration[indexToModify].isActive !=
                          myActivity.isActive ||
                      activitiesWithDuration[indexToModify].isStart) {
                    if (activitiesWithDuration[indexToModify]
                                .durationInMinutes <
                            1 &&
                        activitiesWithDuration[indexToModify].isStart ==
                            false) {
                      activitiesWithDuration.removeAt(indexToModify);
                    }
                    activitiesWithDuration.add(MyActivityDuration(
                        myActivity: myActivity, durationInMinutes: 0));
                  }
                }
              });
              log(activitiesWithDuration.length.toString());
              return Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(onPressed: cubit.start, child: Text('Start')),
                  TextButton(onPressed: cubit.pause, child: Text('Pause')),
                  Text('Steps: ${state.steps}'),
                  Container(
                    height: 300,
                    child: ListView.builder(
                        itemCount: activitiesWithDuration.length,
                        reverse: true,
                        itemBuilder: (BuildContext context, int idx) {
                          return _buildTimelineTile(
                            context: context,
                            currentActivity: activitiesWithDuration[idx],
                          );
                        }),
                  ),
                ],
              ));
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }

  TimelineTile _buildTimelineTile({
    required BuildContext context,
    required MyActivityDuration currentActivity,
  }) {
    if (currentActivity.isStart) {
      return _startTimelineTile(currentActivity);
    } else if (currentActivity.isEnd) {
      return _endTimelineTile(currentActivity);
    } else {
      return _inProgressTimelineTile(currentActivity);
    }
  }

  TimelineTile _inProgressTimelineTile(MyActivityDuration current) {
    return TimelineTile(
      alignment: TimelineAlign.manual,
      lineXY: 0.3,
      indicatorStyle: IndicatorStyle(
        indicatorXY: 1,
        drawGap: true,
        height: 40,
        width: 40,
        color: Theme.of(context).colorScheme.secondary,
        padding: const EdgeInsets.all(8),
        iconStyle: IconStyle(
          color: Colors.white,
          iconData: current.isActive ? Icons.directions_walk : Icons.block,
        ),
      ),
      endChild: Container(
        constraints: const BoxConstraints(
          minHeight: 100,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 14,
            ),
            Text('${current.durationInMinutes} minutes'),
          ],
        ),
      ),
      startChild: Container(
        constraints: const BoxConstraints(
          minHeight: 100,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              DateFormat.Hm().format(current.timestamp),
              textAlign: TextAlign.center,
            ),
            Text(
              DateFormat.yMEd().format(current.timestamp),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  TimelineTile _endTimelineTile(MyActivityDuration current) {
    return TimelineTile(
      isFirst: true,
      alignment: TimelineAlign.manual,
      lineXY: 0.3,
      indicatorStyle: IndicatorStyle(
        indicatorXY: 1,
        drawGap: true,
        height: 40,
        width: 40,
        color: Theme.of(context).colorScheme.error,
        padding: const EdgeInsets.all(8),
        iconStyle: IconStyle(
          color: Colors.white,
          iconData: Icons.stop,
        ),
      ),
      startChild: Container(
        constraints: const BoxConstraints(
          minHeight: 100,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              DateFormat.Hm().format(current.timestamp),
              textAlign: TextAlign.center,
            ),
            Text(
              DateFormat.yMEd().format(current.timestamp),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  TimelineTile _startTimelineTile(MyActivityDuration current) {
    return TimelineTile(
      isLast: true,
      alignment: TimelineAlign.manual,
      lineXY: 0.3,
      indicatorStyle: IndicatorStyle(
        indicatorXY: 1,
        drawGap: true,
        height: 40,
        width: 40,
        color: Colors.green,
        padding: const EdgeInsets.all(8),
        iconStyle: IconStyle(
          color: Colors.white,
          iconData: Icons.play_arrow,
        ),
      ),
      startChild: Container(
        constraints: const BoxConstraints(
          minHeight: 100,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              DateFormat.Hm().format(current.timestamp),
              textAlign: TextAlign.center,
            ),
            Text(
              DateFormat.yMEd().format(current.timestamp),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
