import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:master_thesis/features/data/points_entry.dart';
import 'package:master_thesis/features/data/users_repository.dart';
import 'package:master_thesis/features/home_page/grid_items/tai_chi/tai_chi_intervention.dart';
import 'package:master_thesis/features/home_page/grid_items/tai_chi/tai_chi_interventions_repository.dart';
import 'package:master_thesis/features/home_page/grid_items/tai_chi/tai_chi_lesson.dart';
import 'package:master_thesis/features/widgets/badges.dart';
import 'package:master_thesis/service_locator.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

class TaiChiPageArguments {
  TaiChiPageArguments({
    required this.taiChiLesson,
    required this.taiChiIntervention,
  });

  final TaiChiLesson taiChiLesson;
  final TaiChiIntervention taiChiIntervention;
}

class TaiChiPage extends StatefulWidget {
  static const String lastTaiChiDate = 'lastTaiChiDate';

  const TaiChiPage({
    Key? key,
    required this.taiChiLesson,
    required this.taiChiIntervention,
  }) : super(key: key);

  static const routeName = '/taiChi';

  final TaiChiLesson taiChiLesson;
  final TaiChiIntervention taiChiIntervention;

  @override
  State<TaiChiPage> createState() => _TaiChiPageState();
}

class _TaiChiPageState extends State<TaiChiPage> {
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
        _watchedTimeInSeconds = value;

        /// for tests
        // log('onChangeRawSecond $value');
        // final bool isWatchedVideo = 5 < _watchedTimeInSeconds;
        final bool isWatchedVideo =
            _controller.metadata.duration.inSeconds * 0.9 <
                _watchedTimeInSeconds;

        if (isWatchedVideo && !_isWatchedVideo) {
          setState(() {
            _isWatchedVideo = true;
          });

          final List<String> lessonsDone;
          if (!widget.taiChiIntervention.lessonsDone
              .contains(widget.taiChiLesson.id)) {
            lessonsDone = widget.taiChiIntervention.lessonsDone +
                [widget.taiChiLesson.id];
          } else {
            lessonsDone = widget.taiChiIntervention.lessonsDone;
          }

          final List<String> lessonsToDo =
              List.from(widget.taiChiIntervention.lessonsToDo);
          lessonsToDo.remove(widget.taiChiLesson.id);

          final TaiChiIntervention newTaiChiIntervention =
              widget.taiChiIntervention.copyWith(
            lessonsDone: lessonsDone,
            lessonsToDo: lessonsToDo,
          );
          sl<TaiChiInterventionsRepository>().updateTaiChiIntervention(
              newTaiChiIntervention: newTaiChiIntervention);

          if (lessonsToDo.isEmpty &&
              widget.taiChiIntervention.lessonsToDo.isNotEmpty) {
            var result = sl<UserRepository>().addBadge(BadgesKeys.taiChiLevel1);
            await result;

            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                    'Well done! A whole Tai Chi course performed! Earned ${PredefinedEntryPoints.taiChiWholeCourse.points.toString()} points')));

            result = sl<UserRepository>().addUserPointsEntry(
                PredefinedEntryPoints.taiChiWholeCourse
                    .copyWith(datetime: DateTime.now()));
            await result;

            result = sl<UserRepository>().doneTaiChiIntervention(
                taiChiInterventionId: widget.taiChiIntervention.id);
            await result;
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                    'Well done! Exercise performed. Earned ${PredefinedEntryPoints.taiChiSingleVideo.points.toString()} points')));

            sl<UserRepository>().addUserPointsEntry(PredefinedEntryPoints
                .taiChiSingleVideo
                .copyWith(datetime: DateTime.now()));
          }
          final DateTime now = DateTime.now().toUtc();
          sl<SharedPreferences>().setString(TaiChiPage.lastTaiChiDate,
              DateTime(now.year, now.month, now.day).toString());
        }
      },
      // onChangeRawMinute: (value) => log('onChangeRawMinute $value'),
    );

    _controller = YoutubePlayerController(
      initialVideoId: widget.taiChiLesson.ytVideoId,
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
              title: Text(widget.taiChiLesson.title),
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
                        widget.taiChiLesson.title,
                        style: Theme.of(context)
                            .textTheme
                            .headline5!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      SelectableText(
                        widget.taiChiLesson.description,
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
