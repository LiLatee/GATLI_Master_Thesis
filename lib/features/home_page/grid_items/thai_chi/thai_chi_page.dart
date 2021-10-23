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
import 'package:master_thesis/features/home_page/home_screen.dart';
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

  @override
  void initState() {
    super.initState();

    _stopWatchTimer = StopWatchTimer(
      mode: StopWatchMode.countUp,
      // onChange: (value) => log('onChange $value'),
      onChangeRawSecond: (value) async {
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

          final List<String> lessonsToDo =
              List.from(widget.thaiChiIntervention.lessonsToDo);
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
            var result =
                sl<UserRepository>().addBadge(BadgesKeys.thaiChiLevel1);
            await result;

            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                    'Well done! A whole Thai Chi course performed! Earned ${PredefinedEntryPoints.thaiChiWholeCourse.points.toString()} points')));

            result = sl<UserRepository>().addUserPointsEntry(
                PredefinedEntryPoints.thaiChiWholeCourse
                    .copyWith(datetime: DateTime.now()));
            await result;

            result = sl<UserRepository>().doneThaiChiIntervention(
                thaiChiInterventionId: widget.thaiChiIntervention.id);
            await result;
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
