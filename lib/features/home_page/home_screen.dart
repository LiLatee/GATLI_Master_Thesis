import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:health/health.dart';
import 'package:master_thesis/features/home_page/achievements_page/achievements_page.dart';
import 'package:master_thesis/features/home_page/actions_gird_view/actions_grid_view.dart';
import 'package:master_thesis/features/home_page/profile_page_header.dart';
import 'package:master_thesis/features/home_page/settings_page/settings_page.dart';
import 'package:master_thesis/features/widgets/custom_bottom_navigation_bar.dart';
import 'package:permission_handler/permission_handler.dart';

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

  @override
  void initState() {
    super.initState();
    fetchFitData();
    timer = Timer.periodic(
      const Duration(minutes: 1),
      (Timer t) => fetchFitData(),
    );
  }

  List<HealthDataPoint> _healthDataList = [];
  int stepsToday = 0;
  int minutesOfMove = 0;

  Future fetchFitData() async {
    final DateTime now = DateTime.now();
    final DateTime startDate = DateTime(now.year, now.month, now.day, 0, 0, 0);
    final DateTime endDate = DateTime(now.year, now.month, now.day, 23, 59, 59);

    final HealthFactory health = HealthFactory();

    // define the types to get
    final List<HealthDataType> types = [
      HealthDataType.STEPS,
      HealthDataType.MOVE_MINUTES
      // HealthDataType.WEIGHT,
      // HealthDataType.HEIGHT,
      // HealthDataType.BLOOD_GLUCOSE,
      // HealthDataType.ACTIVE_ENERGY_BURNED,
    ];

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
        _healthDataList =
            await health.getHealthDataFromTypes(startDate, endDate, types);

        // save all the new data points
        // _healthDataList.addAll(healthData);
      } catch (e) {
        log("Fit - Caught exception in getHealthDataFromTypes: $e");
      }

      int newStepsToday = 0;
      _healthDataList
          .where((element) => element.type == HealthDataType.STEPS)
          .forEach((element) {
        newStepsToday += element.value.round();
      });

      int newMinutesOfMoveToday = 0;
      _healthDataList
          .where((element) => element.type == HealthDataType.MOVE_MINUTES)
          .forEach((element) {
        newMinutesOfMoveToday += element.value.round();
      });
      log('minutesOfMove: $minutesOfMove');

      // update the UI to display the results
      setState(() {
        stepsToday = newStepsToday;
        minutesOfMove = newMinutesOfMoveToday;
      });
    } else {
      log("Fit - Authorization not granted");
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
        body: CustomScrollView(
          slivers: [
            SliverPersistentHeader(
              pinned: true,
              // floating: true,
              delegate: ProfilePageHeader(
                // minExtent: AppConstants.homePageAvatarRadius * 2 + 8 * 2,
                stepsToday: stepsToday,
                minExtent: 200,
                maxExtent: 200,
              ),
            ),
            _options[_selectedIndex],
          ],
        ),
      ),
    );
  }
}
