import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:master_thesis/features/home_page/grid_items/30x30_challange/challange_30x30_cubit.dart';
import 'package:master_thesis/features/home_page/grid_items/30x30_challange/challange_30x30_intervention.dart';
import 'package:master_thesis/features/home_page/grid_items/30x30_challange/challange_one_day_stats.dart';

enum DayStatus {
  DONE,
  FAILURE,
  IN_PROGRESS,
  FUTURE,
}

class Challange30x30Page extends StatefulWidget {
  const Challange30x30Page({Key? key}) : super(key: key);
  static const routeName = '/challange30x30';

  @override
  _Challange30x30State createState() => _Challange30x30State();
}

class _Challange30x30State extends State<Challange30x30Page> {
  late final Challange30x30Cubit cubit;

  @override
  void initState() {
    super.initState();
    cubit = Challange30x30Cubit();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('30x30 Challange Progress'),
      ),
      body: BlocBuilder<Challange30x30Cubit, Challange30x30State>(
        bloc: cubit,
        builder: (context, state) {
          if (state is Challange30x30StateLoaded) {
            final List<Widget> widgets = _buildListOfTiles(state.intervention);

            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Column(
                    children: [
                      Text(
                        'Nice to see you here!',
                        style: Theme.of(context).textTheme.headline5!.copyWith(
                              color:
                                  Theme.of(context).colorScheme.primaryVariant,
                            ),
                      ),
                      const SizedBox(height: 8),
                      RichText(
                        text: TextSpan(
                          text: 'Here you are able to see you progress in ',
                          style: Theme.of(context).textTheme.subtitle1,
                          children: [
                            TextSpan(
                              text: '30x30 Challange',
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1!
                                  .copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary),
                            ),
                            const TextSpan(
                                text:
                                    '. 30x30 means 30 minutes of activity for 30 days.'),
                            TextSpan(
                              text: ' Good luck!',
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1!
                                  .copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _getDayStatusWidget(dayStatus: DayStatus.DONE),
                          const SizedBox(width: 8),
                          const Expanded(
                            child: Text(
                              'Hooray! You have performed 30 mins of activity that day.',
                              maxLines: 2,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _getDayStatusWidget(dayStatus: DayStatus.IN_PROGRESS),
                          const SizedBox(width: 8),
                          const Expanded(
                            child: Text(
                              "It's not done yet, but it's today so you are still able to do it!",
                              maxLines: 2,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _getDayStatusWidget(dayStatus: DayStatus.FUTURE),
                          const SizedBox(width: 8),
                          const Expanded(
                            child: Text(
                              "Don't mind. It's a future thing. 😄",
                              maxLines: 2,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _getDayStatusWidget(dayStatus: DayStatus.FAILURE),
                          const SizedBox(width: 8),
                          const Expanded(
                            child: Text(
                              "Unfortunately, you didn't make it that day, but it's just a single day 😉.",
                              maxLines: 2,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: GridView(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        mainAxisSpacing: 4,
                        crossAxisSpacing: 4,
                        mainAxisExtent: 120,
                      ),
                      children: widgets,
                    ),
                  ),
                ],
              ),
            );
          } else if (state is Challange30x30StateLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is Challange30x30StateError) {
            return Center(child: Text(state.message));
          }

          throw Exception('Unexpected Error');
        },
      ),
    );
  }

  List<Widget> _buildListOfTiles(Challange30x30Intervention data) {
    final List<Widget> result = [];

    int dayNumber = 1;
    final List<String> sortedKeys = data.days!.keys.toList();
    sortedKeys.sort();

    for (final key in sortedKeys) {
      final value = data.days![key];

      final DateTime day = DateTime.parse(key);
      final Widget iconWidget = _getProgressWidget(value: value, day: day);

      final minsOfMoveString = value?.minutesOfMove.toString() ?? '0';

      result.add(Container(
        child: Card(
          child: GridTile(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Day $dayNumber',
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                Text(DateFormat.E('pl').format(day)),
                Text(DateFormat.MMMd('pl').format(day)),
                Expanded(
                    child: Column(
                  children: [
                    iconWidget,
                    Text(minsOfMoveString + ' mins'),
                  ],
                )),
              ],
            ),
          ),
        ),
      ));
      dayNumber += 1;
    }
    return result;
  }

  Widget _getProgressWidget({
    required ChallangeOneDayStats? value,
    required DateTime day,
  }) {
    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);

    final int daysComparison = day.compareTo(today);
    if (value == null) {
      if (daysComparison == -1) {
        return _getDayStatusWidget(dayStatus: DayStatus.FAILURE);
      } else if (daysComparison == 0) {
        return _getDayStatusWidget(dayStatus: DayStatus.IN_PROGRESS);
      } else {
        return _getDayStatusWidget(dayStatus: DayStatus.FUTURE);
      }
    } else {
      if (value.minutesOfMove >= 30) {
        if (daysComparison == 1) {
          return _getDayStatusWidget(dayStatus: DayStatus.FUTURE);
        } else {
          return _getDayStatusWidget(dayStatus: DayStatus.DONE);
        }
      } else {
        if (daysComparison == -1) {
          return _getDayStatusWidget(dayStatus: DayStatus.FAILURE);
        } else if (daysComparison == 0) {
          return _getDayStatusWidget(dayStatus: DayStatus.IN_PROGRESS);
        } else {
          return _getDayStatusWidget(dayStatus: DayStatus.FUTURE);
        }
      }
    }
  }

  Widget _getDayStatusWidget({required DayStatus dayStatus}) {
    final IconData iconData;
    final Color iconColor;

    if (dayStatus == DayStatus.DONE) {
      iconData = Icons.done;
      iconColor = Theme.of(context).colorScheme.primary;
    } else if (dayStatus == DayStatus.FAILURE) {
      iconData = Icons.close;
      iconColor = Theme.of(context).colorScheme.error;
    } else if (dayStatus == DayStatus.IN_PROGRESS) {
      iconData = Icons.directions_run;
      iconColor = Theme.of(context).colorScheme.secondary;
    } else {
      iconData = Icons.more_horiz;
      iconColor = Colors.grey;
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          iconData,
          size: 32,
          color: iconColor,
        ),
      ],
    );
  }
}
