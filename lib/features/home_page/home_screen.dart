import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:app_install_date/app_install_date.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:health/health.dart';
import 'package:master_thesis/features/data/user_app.dart';
import 'package:master_thesis/features/data/users_repository.dart';
import 'package:master_thesis/features/home_page/achievements_page/achievements_page.dart';
import 'package:master_thesis/features/home_page/actions_gird_view/actions_grid_view.dart';
import 'package:master_thesis/features/home_page/profile_page_header.dart';
import 'package:master_thesis/features/home_page/settings_page/settings_page.dart';
import 'package:master_thesis/features/home_page/week_stats.dart';
import 'package:master_thesis/features/widgets/badges.dart';
import 'package:master_thesis/features/widgets/custom_bottom_navigation_bar.dart';
import 'package:master_thesis/service_locator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  static const String routeName = '/homeScreen';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  static const List<Widget> _options = [
    ActionsGridView(),
    AchievementsPage(),
    SettingsPage(),
  ];

  late final Timer timer;
  late UserApp userApp;

  @override
  void initState() {
    super.initState();
    fetchFitData().then((value) {
      checkIfShowSummary();
    });
    timer = Timer.periodic(
      const Duration(minutes: 1),
      (Timer t) => fetchFitData(),
    );
  }

  List<HealthDataPoint> _healthDataList = [];
  int stepsToday = 0;
  // int minutesOfMove = 0;
  int metersOfMoveToday = 0;
  late int lastLastWeekSteps;
  late int lastWeekSteps;
  bool showSummaryDialog = false;

  DateTime? checkIfNewWeek() {
    final prefs = sl<SharedPreferences>();
    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);
    final DateTime lastWeekDate;

    if (prefs.containsKey(LAST_WEEK_DATE_KEY)) {
      lastWeekDate = DateTime.parse(prefs.getString(LAST_WEEK_DATE_KEY)!);
    } else {
      lastWeekDate = today.subtract(Duration(days: today.weekday - 1));
      sl<SharedPreferences>()
          .setString(LAST_WEEK_DATE_KEY, lastWeekDate.toString());
    }

    log('lastWeekDate: ${lastWeekDate.toString()}');
    if (today.difference(lastWeekDate).inHours > 7 * 24) {
      return lastWeekDate;
    } else {
      return null;
    }
  }

  void checkIfShowSummary() {
    final DateTime? lastWeekDay = checkIfNewWeek();

    if (lastWeekDay != null) {
      Navigator.pushNamed(
        context,
        WeekStats.routeName,
        arguments:
            WeekStatsArguments(data: _healthDataList, lastWeekDay: lastWeekDay),
      );
      return;
    }
  }

  Future fetchFitData() async {
    late final String installDate;
    try {
      final DateTime date = await AppInstallDate().installDate;
      installDate = date.toString();
    } catch (_) {
      log('HomeScreen - Failed to load install date');
      throw Exception('Failed to load install date');
    }

    final DateTime now = DateTime.now();
    final DateTime todayDateStart =
        DateTime(now.year, now.month, now.day, 0, 0, 0);
    final DateTime installedDate = DateTime.parse(installDate);
    // final DateTime installedDate =
    // DateTime.parse(installDate).subtract(const Duration(days: 14));

    final DateTime todayDateEnd =
        DateTime(now.year, now.month, now.day, 23, 59, 59);
    log('installedDate: $installedDate');

    final HealthFactory health = HealthFactory();

    // define the types to get
    final List<HealthDataType> types = [HealthDataType.STEPS];

    if (Platform.isIOS) {
      types.add(HealthDataType.DISTANCE_WALKING_RUNNING);
    } else if (Platform.isAndroid) {
      types.add(HealthDataType.MOVE_MINUTES);
    }

    // you MUST request access to the data types before reading them
    if (Platform.isAndroid) {
      final permissionStatus = Permission.activityRecognition.request();
      if (await permissionStatus.isDenied ||
          await permissionStatus.isPermanentlyDenied) {
        log('Fit - activityRecognition permission required to fetch your steps count');
        return;
      } else {
        log('Fit - Permissions granted');
      }
    }

    final bool accessWasGranted = await health.requestAuthorization(types);

    if (accessWasGranted) {
      try {
        // fetch new data
        _healthDataList = await health.getHealthDataFromTypes(
            installedDate, todayDateEnd, types);

        // save all the new data points
        // _healthDataList.addAll(healthData);
      } catch (e) {
        log('Fit - Caught exception in getHealthDataFromTypes: $e');
      }

      int newStepsToday = 0;
      _healthDataList
          .where((element) => element.type == HealthDataType.STEPS)
          .where((element) {
        final DateTime dateTimeOnlyDay = DateTime(
          element.dateFrom.year,
          element.dateFrom.month,
          element.dateFrom.day,
        );
        return dateTimeOnlyDay.compareTo(todayDateStart) == 0;
      }).forEach((element) {
        newStepsToday += element.value.round();
      });

      int stepsSinceInstalled = 0;
      _healthDataList
          .where((element) => element.type == HealthDataType.STEPS)
          .forEach((element) {
        stepsSinceInstalled += element.value.round();
      });

      // int newMinutesOfMoveToday = 0;
      // _healthDataList
      //     .where((element) => element.type == HealthDataType.MOVE_MINUTES)
      //     .where((element) {
      //   final DateTime dateTimeOnlyDay = DateTime(
      //     element.dateFrom.year,
      //     element.dateFrom.month,
      //     element.dateFrom.day,
      //   );
      //   return dateTimeOnlyDay.compareTo(todayDateStart) == 0;
      // }).forEach((element) {
      //   newMinutesOfMoveToday += element.value.round();
      // });

      log('newStepsToday: $newStepsToday');
      log('stepsSinceInstalled: $stepsSinceInstalled');
      // log('minutesOfMove: $minutesOfMove');

      int newMetersOfMoveToday = 0;
      if (Platform.isIOS) {
        _healthDataList
            .where((element) =>
                element.type == HealthDataType.DISTANCE_WALKING_RUNNING)
            .where((element) {
          final DateTime dateTimeOnlyDay = DateTime(
            element.dateFrom.year,
            element.dateFrom.month,
            element.dateFrom.day,
          );
          return dateTimeOnlyDay.compareTo(todayDateStart) == 0;
        }).forEach((element) {
          newMetersOfMoveToday += element.value.round();
        });
      }

      log('metersOfMove: $metersOfMoveToday');

      final failureOrUser = await sl<UserRepository>().getUser();
      failureOrUser.fold(
        (_) => log('Home screen - failed to get user'),
        (UserApp userApp) {
          if (userApp.badgesKeys.contains(BadgesKeys.stepsLevel3)) {
            return;
          } else if (userApp.badgesKeys.contains(BadgesKeys.stepsLevel2)) {
            if (stepsSinceInstalled > 1000000) {
              sl<UserRepository>().addBadge(BadgesKeys.stepsLevel3);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text(
                      'Wow! You had walked above 1 000 000 steps! New badge received.')));
            }
            return;
          } else if (userApp.badgesKeys.contains(BadgesKeys.stepsLevel1)) {
            if (stepsSinceInstalled > 100000) {
              sl<UserRepository>().addBadge(BadgesKeys.stepsLevel2);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text(
                      'Wow! You had walked above 100 000 steps! New badge received.')));
            }
            return;
          } else {
            if (stepsSinceInstalled > 10000) {
              sl<UserRepository>().addBadge(BadgesKeys.stepsLevel1);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text(
                      'Wow! You had walked above 10 000 steps! New badge received.')));
            }
          }
        },
      );

      // update the UI to display the results
      setState(() {
        stepsToday = newStepsToday;
        // minutesOfMove = newMinutesOfMoveToday;
        metersOfMoveToday = newMetersOfMoveToday;
      });
    } else {
      log('Fit - Authorization not granted');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: CustomBottomNavigationBar(
          selectedIndex: _selectedIndex,
          onItemTapped: (int selected) {
            setState(() {
              _selectedIndex = selected;
            });
          },
        ),
        body: StreamBuilder<DocumentSnapshot>(
            stream: sl<UserRepository>().getStream(),
            builder: (
              BuildContext context,
              AsyncSnapshot<DocumentSnapshot> snapshot,
            ) {
              if (snapshot.hasData) {
                userApp = UserApp.fromJson(
                    snapshot.data!.data() as Map<String, dynamic>);

                return CustomScrollView(
                  slivers: [
                    SliverPersistentHeader(
                      pinned: true,
                      // floating: true,
                      delegate: ProfilePageHeader(
                        // minExtent: AppConstants.homePageAvatarRadius * 2 + 8 * 2,
                        stepsToday: stepsToday,
                        metersOfMoveToday: metersOfMoveToday,
                        userApp: userApp,
                        minExtent: 160,
                        maxExtent: 160,
                      ),
                    ),
                    _options[_selectedIndex],
                  ],
                );
              } else {
                return const Center(
                  child: Text('No data'),
                );
              }
            }),
      ),
    );
  }
}
