import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:master_thesis/features/data/points_entry.dart';
import 'package:master_thesis/features/data/users_repository.dart';
import 'package:master_thesis/features/home_page/grid_items/activity/activity_cubit.dart';
import 'package:master_thesis/features/home_page/grid_items/activity/my_activity.dart';
import 'package:master_thesis/features/widgets/whole_screen_width_button.dart';
import 'package:master_thesis/service_locator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timeline_tile/timeline_tile.dart';

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
          title: const Text('Activity Tracking'),
        ),
        body: BlocBuilder<ActivityCubit, ActivityState>(
          builder: (context, state) {
            if (state is ActivityStateLoaded) {
              final events = state.activitySession.activities;
              int minutesOfActivity = 0;
              state.activitySession.activities
                  .where((element) => element.isActive)
                  .forEach((MyActivity myActivity) =>
                      minutesOfActivity += myActivity.durationInMinutes);

              return Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildTimer(context, state),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStopStartButton(context, state),
                        Column(
                          children: [
                            Text(
                              'Steps:',
                              style: Theme.of(context).textTheme.headline4,
                            ),
                            Text(
                              state.steps.toString(),
                              style: Theme.of(context).textTheme.headline4,
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      height: 200,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: events
                            .map((e) => _buildTimelineTile(
                                context: context, currentActivity: e))
                            .toList(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (state.exerciseState == ExerciseState.FINISHED)
                      _buildFinishedWidgets(
                          minutesOfActivity: minutesOfActivity),
                  ],
                ),
              );
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

  Widget _buildFinishedWidgets({required int minutesOfActivity}) {
    return Column(
      children: [
        Text(
          'Minutes of activity:',
          style: Theme.of(context).textTheme.headline5,
        ),
        Text(
          minutesOfActivity.toString(),
          style: Theme.of(context).textTheme.headline4,
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: WholeScreenWidthButton(
            label: 'Back',
            color: Theme.of(context).colorScheme.secondary,
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ],
    );
  }

  Container _buildStopStartButton(
      BuildContext context, ActivityStateLoaded state) {
    late final VoidCallback? action;
    late final IconData iconData;
    late final String label;

    if (state.exerciseState == ExerciseState.NOT_STARTED) {
      action = cubit.start;
      iconData = Icons.play_arrow;
      label = 'Start activity';
    } else if (state.exerciseState == ExerciseState.RUNNING) {
      action = cubit.finish;
      iconData = Icons.pause;
      label = 'Finish activity';
    } else if (state.exerciseState == ExerciseState.FINISHED) {
      iconData = Icons.done;
      action = null;
      label = 'Finished activity';
    }

    return Container(
      width: 100,
      height: 100,
      child: TextButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color>((state) {
            if (state.contains(MaterialState.disabled)) {
              return Colors.grey;
            } else {
              return Theme.of(context).colorScheme.secondary;
            }
          }),
          shape: MaterialStateProperty.all<OutlinedBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
          ),
        ),
        onPressed: () {
          action!();
          if (state.minutes >= 30) {
            sl<UserRepository>().addUserPointsEntry(
              PredefinedEntryPoints.activityAbove30Mins
                  .copyWith(datetime: DateTime.now()),
            );
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text(
                    'Well done! Got additional 50 points for activity above 30 mins!')));
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Column(
            children: [
              Icon(
                iconData,
                size: 36,
              ),
              const Spacer(),
              Text(
                label,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row _buildTimer(BuildContext context, ActivityStateLoaded state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(30)),
          child: Center(
            child: Column(
              children: [
                Text(
                  state.hours.toString(),
                  style: Theme.of(context).textTheme.headline2,
                ),
                const Text(
                  'hours',
                ),
              ],
            ),
          ),
        ),
        Text(
          ':',
          style: Theme.of(context).textTheme.headline2,
        ),
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(30)),
          child: Center(
            child: Column(
              children: [
                Text(
                  state.minutes.toString(),
                  style: Theme.of(context).textTheme.headline2,
                ),
                const Text(
                  'minutes',
                ),
              ],
            ),
          ),
        ),
        Text(
          ':',
          style: Theme.of(context).textTheme.headline2,
        ),
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Center(
            child: Column(
              children: [
                Text(
                  state.seconds.toString(),
                  style: Theme.of(context).textTheme.headline2,
                ),
                const Text(
                  'seconds',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  TimelineTile _buildTimelineTile({
    required BuildContext context,
    required MyActivity currentActivity,
  }) {
    if (currentActivity.isStart) {
      return _startTimelineTile(currentActivity);
    } else if (currentActivity.isEnd) {
      return _endTimelineTile(currentActivity);
    } else {
      return _inProgressTimelineTile(currentActivity);
    }
  }

  TimelineTile _inProgressTimelineTile(MyActivity current) {
    return TimelineTile(
      axis: TimelineAxis.horizontal,
      alignment: TimelineAlign.center,
      indicatorStyle: IndicatorStyle(
        indicatorXY: 0.5,
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
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              DateFormat.Hm().format(current.timestamp),
              textAlign: TextAlign.center,
            ),
            Text(
              DateFormat.yMd().format(current.timestamp),
              textAlign: TextAlign.center,
            ),
            Text(
              DateFormat.EEEE().format(current.timestamp),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  TimelineTile _endTimelineTile(MyActivity current) {
    return TimelineTile(
      isLast: true,
      axis: TimelineAxis.horizontal,
      alignment: TimelineAlign.center,
      indicatorStyle: IndicatorStyle(
        indicatorXY: 0.5,
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
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              DateFormat.Hm().format(current.timestamp),
              textAlign: TextAlign.center,
            ),
            Text(
              DateFormat.yMd().format(current.timestamp),
              textAlign: TextAlign.center,
            ),
            Text(
              DateFormat.EEEE().format(current.timestamp),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  TimelineTile _startTimelineTile(MyActivity current) {
    return TimelineTile(
      isFirst: true,
      axis: TimelineAxis.horizontal,
      alignment: TimelineAlign.center,
      indicatorStyle: IndicatorStyle(
        indicatorXY: 0.5,
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
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              DateFormat.Hm().format(current.timestamp),
              textAlign: TextAlign.center,
            ),
            Text(
              DateFormat.yMd().format(current.timestamp),
              textAlign: TextAlign.center,
            ),
            Text(
              DateFormat.EEEE().format(current.timestamp),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
