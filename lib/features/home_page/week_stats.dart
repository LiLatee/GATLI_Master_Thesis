import 'dart:developer';

import 'package:charts_flutter/flutter.dart' hide Color;
import 'package:flutter/material.dart';
import 'package:health/health.dart';
import 'package:intl/intl.dart';
import 'package:master_thesis/features/home_page/home_screen.dart';
import 'package:master_thesis/service_locator.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String LAST_WEEK_DATE_KEY = 'lastWeekDate';

class WeekStatsArguments {
  final List<HealthDataPoint> data;
  final DateTime lastWeekDay;

  WeekStatsArguments({
    required this.data,
    required this.lastWeekDay,
  });
}

class WeekStats extends StatefulWidget {
  const WeekStats({
    Key? key,
    required this.args,
  }) : super(key: key);

  final WeekStatsArguments args;

  static const String routeName = '/weekStats';

  @override
  _WeekStatsState createState() => _WeekStatsState();
}

class _WeekStatsState extends State<WeekStats> {
  List<OneDayData> lastLastWeekDataSerie = [];
  List<OneDayData> lastWeekDataSerie = [];
  int stepsInLastLastWeek = 0;
  int stepsInLastWeek = 0;

  @override
  void initState() {
    super.initState();
    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);
    final DateTime lastWeekDate =
        today.subtract(Duration(days: today.weekday - 1));

    sl<SharedPreferences>()
        .setString(LAST_WEEK_DATE_KEY, lastWeekDate.toString());
    log('NOWA DATA: ${lastWeekDate.toString()}');

    log(widget.args.lastWeekDay.toString());
    final List<DateTime> lastLastWeekDays = [
      widget.args.lastWeekDay.subtract(const Duration(days: 7)),
      widget.args.lastWeekDay.subtract(const Duration(days: 6)),
      widget.args.lastWeekDay.subtract(const Duration(days: 5)),
      widget.args.lastWeekDay.subtract(const Duration(days: 4)),
      widget.args.lastWeekDay.subtract(const Duration(days: 3)),
      widget.args.lastWeekDay.subtract(const Duration(days: 2)),
      widget.args.lastWeekDay.subtract(const Duration(days: 1)),
    ];

    final List<DateTime> lastWeekDays = [
      widget.args.lastWeekDay,
      widget.args.lastWeekDay.add(const Duration(days: 1)),
      widget.args.lastWeekDay.add(const Duration(days: 2)),
      widget.args.lastWeekDay.add(const Duration(days: 3)),
      widget.args.lastWeekDay.add(const Duration(days: 4)),
      widget.args.lastWeekDay.add(const Duration(days: 5)),
      widget.args.lastWeekDay.add(const Duration(days: 6)),
    ];

    for (final day in lastLastWeekDays) {
      final steps = _statOfOneDay(datetime: day);
      lastLastWeekDataSerie.add(OneDayData(
          dayOfWeek: DateFormat(DateFormat.ABBR_WEEKDAY).format(day),
          lastLastWeekValue: steps));
      stepsInLastLastWeek += steps;
    }

    for (final day in lastWeekDays) {
      final steps = _statOfOneDay(datetime: day);
      lastWeekDataSerie.add(OneDayData(
          dayOfWeek: DateFormat(DateFormat.ABBR_WEEKDAY).format(day),
          lastWeekValue: steps));
      stepsInLastWeek += steps;
    }

    for (int i = 0; i < 7; i++) {
      lastWeekDataSerie[i].lastLastWeekValue =
          lastLastWeekDataSerie[i].lastLastWeekValue;

      lastLastWeekDataSerie[i].lastWeekValue =
          lastWeekDataSerie[i].lastWeekValue;
    }
    log('stepsInLastWeek: ${stepsInLastWeek.toString()}');
    log('stepsInLastLastWeek: ${stepsInLastLastWeek.toString()}');
  }

  @override
  Widget build(BuildContext context) {
    final DateTime date = widget.args.lastWeekDay;
    final double changeWeekToWeekInPercent =
        (stepsInLastWeek / stepsInLastLastWeek) * 100;

    log(changeWeekToWeekInPercent.toString());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Weekly summary'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 8, top: 16, bottom: 16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Steps',
                  style: Theme.of(context).textTheme.headline5,
                )
              ],
            ),
            Row(
              children: [
                const Icon(
                  Icons.stop,
                  color: Color(0xfff44336),
                ),
                Text(
                  ' ${DateFormat.yMd().format(date.subtract(const Duration(days: 7)))} - ${DateFormat.yMd().format(date.subtract(const Duration(days: 1)))}',
                  style: Theme.of(context).textTheme.subtitle2,
                )
              ],
            ),
            Row(
              children: [
                const Icon(
                  Icons.stop,
                  color: Color(0xff2196f3),
                ),
                Text(
                  ' ${DateFormat.yMd().format(date)} - ${DateFormat.yMd().format(date.add(const Duration(days: 6)))}',
                  style: Theme.of(context).textTheme.subtitle2,
                )
              ],
            ),
            Container(
              height: 300,
              child: BarChart(
                _createSampleData(),
                animate: true,
                vertical: true,
                barRendererDecorator: BarLabelDecorator<String>(
                    labelPosition: BarLabelPosition.outside),
                barGroupingType: BarGroupingType.stacked,
                domainAxis: const OrdinalAxisSpec(),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Overall:',
              style: Theme.of(context).textTheme.headline6,
            ),
            if (changeWeekToWeekInPercent < 100)
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text:
                          '${(100 - changeWeekToWeekInPercent).toStringAsFixed(0)}%',
                      style: Theme.of(context)
                          .textTheme
                          .headline6!
                          .copyWith(color: Colors.red),
                    ),
                    TextSpan(
                        text: ' less steps. Try to improve that!',
                        style: Theme.of(context).textTheme.headline6),
                  ],
                ),
              )
            else if (changeWeekToWeekInPercent >= 100)
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text:
                          '${(changeWeekToWeekInPercent - 100).toStringAsFixed(0)}%',
                      style: Theme.of(context)
                          .textTheme
                          .headline6!
                          .copyWith(color: Colors.green),
                    ),
                    TextSpan(
                        text: ' more steps. Keep it up!',
                        style: Theme.of(context).textTheme.headline6),
                  ],
                ),
              )
          ],
        ),
      ),
    );
  }

  int _statOfOneDay({
    required DateTime datetime,
    HealthDataType dataType = HealthDataType.STEPS,
  }) {
    final DateTime dayOnly =
        DateTime(datetime.year, datetime.month, datetime.day);

    int value = 0;
    widget.args.data
        .where((element) => element.type == dataType)
        .where((element) {
      final DateTime dateTimeOnlyDay = DateTime(
        element.dateFrom.year,
        element.dateFrom.month,
        element.dateFrom.day,
      );
      return dayOnly.compareTo(dateTimeOnlyDay) == 0;
    }).forEach((element) {
      value += element.value.round();
    });

    return value;
  }

  List<Series<OneDayData, String>> _createSampleData() {
    return [
      Series<OneDayData, String>(
          id: 'LastWeekSteps',
          domainFn: (OneDayData oneDayStats, _) => oneDayStats.dayOfWeek,
          measureFn: (OneDayData oneDayStats, _) => oneDayStats.lastWeekValue,
          data: lastWeekDataSerie,
          colorFn: (_, __) => MaterialPalette.blue.shadeDefault,
          labelAccessorFn: (OneDayData oneDayData, _) {
            final double changeDayToDayInPercent =
                (oneDayData.lastWeekValue! / oneDayData.lastLastWeekValue!) *
                    100;

            if (changeDayToDayInPercent < 100) {
              return '-${(100 - changeDayToDayInPercent).toStringAsFixed(0)}%';
              // return '${oneDayData.lastLastWeekValue} --> ${oneDayData.lastWeekValue} -${(100 - changeDayToDayInPercent).toStringAsFixed(2)}%';
            } else if (changeDayToDayInPercent > 100) {
              return '+${(changeDayToDayInPercent - 100).toStringAsFixed(0)}%';
              // return '${oneDayData.lastLastWeekValue} --> ${oneDayData.lastWeekValue}  +${(changeDayToDayInPercent - 100).toStringAsFixed(2)}%';

            } else {
              return '${changeDayToDayInPercent.toStringAsFixed(0)}%';
            }
          }),
      Series<OneDayData, String>(
        id: 'LastLastWeekSteps',
        domainFn: (OneDayData oneDayStats, _) => oneDayStats.dayOfWeek,
        measureFn: (OneDayData oneDayStats, _) => oneDayStats.lastLastWeekValue,
        data: lastLastWeekDataSerie,
        colorFn: (_, __) => MaterialPalette.red.shadeDefault,
        labelAccessorFn: (OneDayData oneDayData, _) => '',
      ),
    ];
  }
}

class OneDayData {
  final String dayOfWeek;
  int? lastWeekValue;
  int? lastLastWeekValue;

  OneDayData({
    required this.dayOfWeek,
    this.lastWeekValue,
    this.lastLastWeekValue,
  });
}
