import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:master_thesis/features/home_page/grid_items/thai_chi/thai_chi_lesson.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class ThaiChiPage extends StatefulWidget {
  ThaiChiPage({
    Key? key,
    required this.thaiChiLesson,
  }) : super(key: key);

  static const routeName = '/thaiChi';

  final ThaiChiLesson thaiChiLesson;

  @override
  State<ThaiChiPage> createState() => _ThaiChiPageState();
}

class _ThaiChiPageState extends State<ThaiChiPage> {
  late final YoutubePlayerController _controller;
  late final StopWatchTimer _stopWatchTimer;
  int _watchedTimeInSeconds = 0;

  bool fullscreen = false;
  @override
  void initState() {
    super.initState();

    _stopWatchTimer = StopWatchTimer(
      mode: StopWatchMode.countUp,
      // onChange: (value) => log('onChange $value'),
      onChangeRawSecond: (value) {
        log('onChangeRawSecond $value');
        _watchedTimeInSeconds = value;
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
              title: const Text('Module 1'),
            ),
      floatingActionButton: fullscreen
          ? null
          : FloatingActionButton.extended(
              label: Text('Done'),
              icon: const Icon(Icons.done),
              onPressed: () {
                // final bool isWatchedVideo =
                //     _controller.metadata.duration.inSeconds * 0.9 <
                //         _watchedTimeInSeconds;

                // TODO for tests
                final bool isWatchedVideo = 5 < _watchedTimeInSeconds;

                if (isWatchedVideo == false) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text('O Ty gnojku')));
                } else {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text('well done')));
                }
              },
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
