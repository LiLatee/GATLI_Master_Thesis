import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:activity_recognition_flutter/activity_recognition_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:master_thesis/features/data/points_entry.dart';
import 'package:master_thesis/features/data/users_repository.dart';
import 'package:master_thesis/features/home_page/grid_items/thai_chi/thai_chi_intervention.dart';
import 'package:master_thesis/features/home_page/grid_items/thai_chi/thai_chi_interventions_repository.dart';
import 'package:master_thesis/features/home_page/grid_items/thai_chi/thai_chi_lesson.dart';
import 'package:master_thesis/features/widgets/badges.dart';
import 'package:master_thesis/service_locator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

enum ActivityEnum {
  ACTIVE,
  INACTIVE,
}

class Activity {
  final ActivityEnum activityEnum;
  final DateTime dateTime;

  Activity({
    required this.activityEnum,
    required this.dateTime,
  });
}

class ThaiChiPageArguments {
  ThaiChiPageArguments({
    required this.thaiChiLesson,
    required this.thaiChiIntervention,
  });

  final ThaiChiLesson thaiChiLesson;
  final ThaiChiIntervention thaiChiIntervention;
}

class ThaiChiPage extends StatefulWidget {
  const ThaiChiPage({
    Key? key,
    required this.thaiChiLesson,
    required this.thaiChiIntervention,
  }) : super(key: key);

  static const routeName = '/thaiChi';

  final ThaiChiLesson thaiChiLesson;
  final ThaiChiIntervention thaiChiIntervention;

  @override
  State<ThaiChiPage> createState() => _ThaiChiPageState();
}

class _ThaiChiPageState extends State<ThaiChiPage> {
  late final YoutubePlayerController _controller;
  late final StopWatchTimer _stopWatchTimer;
  int _watchedTimeInSeconds = 0;
  bool _isWatchedVideo = false;
  bool fullscreen = false;

  // late Stream<Activity> activityStream;
  // List<Activity> _events = [];
  // ActivityRecognition activityRecognition = ActivityRecognition.instance;
  // late final StreamSubscription subscription;

  // void _initActivityMonitoring() async {
  //   /// Android requires explicitly asking permission
  //   if (Platform.isAndroid) {
  //     if (await Permission.activityRecognition.request().isGranted) {
  //       _startTracking();
  //     }
  //   }

  //   /// iOS does not
  //   else {
  //     _startTracking();
  //   }
  // }

  // static const activeActivityTypes = [
  //   ActivityType.ON_FOOT,
  //   ActivityType.RUNNING,
  //   ActivityType.TILTING,
  //   ActivityType.WALKING,
  // ];

  // void _startTracking() {
  //   activityStream = activityRecognition
  //       .startStream(runForegroundService: false)
  //       .map<Activity>((event) {
  //     if (activeActivityTypes.contains(event.type)) {
  //       return Activity(activityEnum: ActivityEnum.ACTIVE, dateTime: event.timeStamp,);
  //     } else {
  //       return Activity(activityEnum: ActivityEnum.INACTIVE, dateTime: event.timeStamp,);
  //     }
  //   });
  //   subscription = activityStream.listen(onData);
  // }

  // void onData(Activity activityEvent) {
  //   log(activityEvent.toString());
  //   setState(() {
  //     _events.add(activityEvent);
  //   });
  // }

  @override
  void initState() {
    super.initState();

    _stopWatchTimer = StopWatchTimer(
      mode: StopWatchMode.countUp,
      // onChange: (value) => log('onChange $value'),
      onChangeRawSecond: (value) {
        log('onChangeRawSecond $value');
        _watchedTimeInSeconds = value;
        final bool isWatchedVideo = 5 < _watchedTimeInSeconds;

        // TODO for tests

        // final bool isWatchedVideo =
        //     _controller.metadata.duration.inSeconds * 0.9 <
        //         _watchedTimeInSeconds;

        if (isWatchedVideo && !_isWatchedVideo) {
          setState(() {
            _isWatchedVideo = true;
          });

          final List<String> lessonsDone;
          if (!widget.thaiChiIntervention.lessonsDone
              .contains(widget.thaiChiLesson.id)) {
            lessonsDone = widget.thaiChiIntervention.lessonsDone +
                [widget.thaiChiLesson.id];
          } else {
            lessonsDone = widget.thaiChiIntervention.lessonsDone;
          }

          final lessonsToDo = widget.thaiChiIntervention.lessonsToDo;
          lessonsToDo.remove(widget.thaiChiLesson.id);

          final ThaiChiIntervention newThaiChiIntervention =
              widget.thaiChiIntervention.copyWith(
            lessonsDone: lessonsDone,
            lessonsToDo: lessonsToDo,
          );
          sl<ThaiChiInterventionsRepository>().updateThaiChiIntervention(
              newThaiChiIntervention: newThaiChiIntervention);
          if (lessonsToDo.isEmpty &&
              widget.thaiChiIntervention.lessonsToDo.isNotEmpty) {
            sl<UserRepository>().addBadge(BadgesKeys.thaiChiLevel1);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                    'Well done! A whole Thai Chi course performed! Earned ${PredefinedEntryPoints.thaiChiWholeCourse.points.toString()} points')));

            sl<UserRepository>().addUserPointsEntry(PredefinedEntryPoints
                .thaiChiWholeCourse
                .copyWith(datetime: DateTime.now()));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                    'Well done! Exercise performed. Earned ${PredefinedEntryPoints.thaiChiSingleVideo.points.toString()} points')));

            sl<UserRepository>().addUserPointsEntry(PredefinedEntryPoints
                .thaiChiSingleVideo
                .copyWith(datetime: DateTime.now()));
          }
        }
      },
      // onChangeRawMinute: (value) => log('onChangeRawMinute $value'),
    );

    _controller = YoutubePlayerController(
      initialVideoId: widget.thaiChiLesson.ytVideoId,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );
    _controller.addListener(() {
      if (_controller.value.playerState == PlayerState.playing) {
        _stopWatchTimer.onExecute.add(StopWatchExecute.start);
      } else {
        _stopWatchTimer.onExecute.add(StopWatchExecute.stop);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: fullscreen
          ? null
          : AppBar(
              title: Text(widget.thaiChiLesson.title),
            ),
      // floatingActionButton: fullscreen
      //     ? null
      //     : FloatingActionButton.extended(
      //         label: const Text('Done'),
      //         icon: const Icon(Icons.done),
      //         onPressed: () {
      //           // final bool isWatchedVideo =
      //           //     _controller.metadata.duration.inSeconds * 0.9 <
      //           //         _watchedTimeInSeconds;

      //           // TODO for tests
      //           final bool isWatchedVideo = 5 < _watchedTimeInSeconds;

      //           if (isWatchedVideo == false) {
      //             ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      //                 content: Text('Please perform whole video')));
      //           } else {
      //             ScaffoldMessenger.of(context)
      //                 .showSnackBar(const SnackBar(content: Text('well done')));
      //             final lessonsDone = widget.thaiChiIntervention.lessonsDone +
      //                 [widget.thaiChiLesson.id];
      //             final lessonsToDo = widget.thaiChiIntervention.lessonsToDo;
      //             lessonsToDo.remove(widget.thaiChiLesson.id);

      //             final ThaiChiIntervention newThaiChiIntervention =
      //                 widget.thaiChiIntervention.copyWith(
      //               lessonsDone: lessonsDone,
      //               lessonsToDo: lessonsToDo,
      //             );
      //             sl<ThaiChiInterventionsRepository>()
      //                 .updateThaiChiIntervention(
      //                     newThaiChiIntervention: newThaiChiIntervention);
      //           }
      //         },
      //       ),
      body: YoutubePlayerBuilder(
        onEnterFullScreen: () {
          setState(() {
            fullscreen = true;
          });
        },
        onExitFullScreen: () {
          setState(() {
            fullscreen = false;
          });
        },
        player: YoutubePlayer(
          controller: _controller,
          showVideoProgressIndicator: true,
          progressIndicatorColor: Colors.red,
          bottomActions: [
            const SizedBox(width: 14.0),
            CurrentPosition(),
            const SizedBox(width: 8.0),
            ProgressBar(
              isExpanded: true,
              colors: const ProgressBarColors(
                handleColor: Colors.red,
                backgroundColor: Colors.black,
                playedColor: Colors.red,
              ),
            ),
            RemainingDuration(),
            FullScreenButton(),
          ],
        ),
        builder: (context, player) => SafeArea(
          child: Column(
            children: [
              player,
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: ListView(
                    children: [
                      SelectableText(
                        widget.thaiChiLesson.title,
                        style: Theme.of(context)
                            .textTheme
                            .headline5!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      SelectableText(
                        widget.thaiChiLesson.description,
                      ),
                      const SizedBox(height: 48),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    _stopWatchTimer.dispose();
  }
}
