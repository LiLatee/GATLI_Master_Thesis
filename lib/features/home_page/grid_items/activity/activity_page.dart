// import 'dart:async';
// import 'dart:developer';
// import 'dart:io';

// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:health/health.dart';
// import 'package:master_thesis/service_locator.dart';
// import 'package:permission_handler/permission_handler.dart';

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await initServiceLocator();
//   await Firebase.initializeApp();
//   runApp(MyApp());
// }

// class MyApp extends StatefulWidget {
//   @override
//   _MyAppState createState() => _MyAppState();
// }

// enum AppState {
//   DATA_NOT_FETCHED,
//   FETCHING_DATA,
//   DATA_READY,
//   NO_DATA,
//   AUTH_NOT_GRANTED
// }

// class _MyAppState extends State<MyApp> {
//   List<HealthDataPoint> _healthDataList = [];
//   AppState _state = AppState.DATA_NOT_FETCHED;

//   @override
//   void initState() {
//     super.initState();
//   }

//   /// Fetch data from the health plugin and print it
//   Future fetchData() async {
//     // get everything from midnight until now
//     DateTime startDate = DateTime(2021, 10, 10, 0, 0, 0);
//     DateTime endDate = DateTime(2021, 10, 10, 23, 59, 59);

//     HealthFactory health = HealthFactory();

//     // define the types to get
//     List<HealthDataType> types = [
//       // HealthDataType.STEPS,
//       HealthDataType.MOVE_MINUTES
//       // HealthDataType.WEIGHT,
//       // HealthDataType.HEIGHT,
//       // HealthDataType.BLOOD_GLUCOSE,
//       // HealthDataType.ACTIVE_ENERGY_BURNED,
//     ];

//     setState(() => _state = AppState.FETCHING_DATA);

//     // you MUST request access to the data types before reading them
//     log('1');
//     if (Platform.isAndroid) {
//       final permissionStatus = Permission.activityRecognition.request();
//       if (await permissionStatus.isDenied ||
//           await permissionStatus.isPermanentlyDenied) {
//         log('activityRecognition permission required to fetch your steps count');
//         return;
//       } else {
//         log('jest git');
//       }
//     }

//     bool accessWasGranted = await health.requestAuthorization(types);
//     log('2: $accessWasGranted');

//     int steps = 0;

//     if (accessWasGranted) {
//       try {
//         // fetch new data
//         List<HealthDataPoint> healthData =
//             await health.getHealthDataFromTypes(startDate, endDate, types);

//         // save all the new data points
//         _healthDataList.addAll(healthData);
//       } catch (e) {
//         print("Caught exception in getHealthDataFromTypes: $e");
//       }

//       // filter out duplicates
//       _healthDataList = HealthFactory.removeDuplicates(_healthDataList);

//       // print the results
//       _healthDataList.forEach((x) {
//         print("Data point: $x");
//         steps += x.value.round();
//       });

//       print("Steps: $steps");

//       // update the UI to display the results
//       setState(() {
//         _state =
//             _healthDataList.isEmpty ? AppState.NO_DATA : AppState.DATA_READY;
//       });
//     } else {
//       print("Authorization not granted");
//       setState(() => _state = AppState.DATA_NOT_FETCHED);
//     }
//   }

//   Widget _contentFetchingData() {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: <Widget>[
//         Container(
//             padding: EdgeInsets.all(20),
//             child: CircularProgressIndicator(
//               strokeWidth: 10,
//             )),
//         Text('Fetching data...')
//       ],
//     );
//   }

//   Widget _contentDataReady() {
//     return ListView.builder(
//         itemCount: _healthDataList.length,
//         itemBuilder: (_, index) {
//           HealthDataPoint p = _healthDataList[index];
//           return ListTile(
//             title: Text("${p.typeString}: ${p.value}"),
//             trailing: Text('${p.unitString}'),
//             subtitle: Text('${p.dateFrom} - ${p.dateTo}'),
//           );
//         });
//   }

//   Widget _contentNoData() {
//     return Text('No Data to show');
//   }

//   Widget _contentNotFetched() {
//     return Text('Press the download button to fetch data');
//   }

//   Widget _authorizationNotGranted() {
//     return Text('''Authorization not given.
//         For Android please check your OAUTH2 client ID is correct in Google Developer Console.
//          For iOS check your permissions in Apple Health.''');
//   }

//   Widget _content() {
//     if (_state == AppState.DATA_READY)
//       return _contentDataReady();
//     else if (_state == AppState.NO_DATA)
//       return _contentNoData();
//     else if (_state == AppState.FETCHING_DATA)
//       return _contentFetchingData();
//     else if (_state == AppState.AUTH_NOT_GRANTED)
//       return _authorizationNotGranted();

//     return _contentNotFetched();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//           appBar: AppBar(
//             title: const Text('Plugin example app'),
//             actions: <Widget>[
//               IconButton(
//                 icon: Icon(Icons.file_download),
//                 onPressed: () {
//                   fetchData();
//                 },
//               )
//             ],
//           ),
//           body: Center(
//             child: _content(),
//           )),
//     );
//   }
// }

import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:master_thesis/features/home_page/grid_items/activity/activity_cubit.dart';
import 'package:master_thesis/features/home_page/grid_items/activity/my_activity.dart';
import 'package:master_thesis/features/widgets/whole_screen_width_button.dart';
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
          title: const Text('Activity Recognition Demo'),
        ),
        body: BlocBuilder<ActivityCubit, ActivityState>(
          builder: (context, state) {
            if (state is ActivityStateLoaded) {
              final events = state.activities;
              int minutesOfActivity = 0;
              state.activities.where((element) => element.isActive).forEach(
                  (MyActivity myActivity) =>
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
                      height: 110,
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
      label = 'End activity';
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
        onPressed: action,
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
      alignment: TimelineAlign.start,
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
      alignment: TimelineAlign.start,
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
      endChild: Container(
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
      alignment: TimelineAlign.start,
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
      endChild: Container(
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
