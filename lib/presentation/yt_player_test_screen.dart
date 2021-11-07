import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YTPlayerTestScreen extends StatelessWidget {
  final String videoId;
  late final YoutubePlayerController _controller;

  YTPlayerTestScreen({
    Key? key,
    required this.videoId,
  }) : super(key: key) {
    _controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        disableDragSeek: true,
        hideControls: true,
        autoPlay: false,
        mute: false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
        progressIndicatorColor: Colors.red,
        progressColors: const ProgressBarColors(
          handleColor: Colors.red,
          backgroundColor: Colors.black,
          playedColor: Colors.red,
        ),
      ),
      builder: (context, player) => SafeArea(
        child: Scaffold(
          body: Column(
            children: [
              player,
              Container(width: 100, height: 100, color: Colors.red),
            ],
          ),
        ),
      ),
    );
  }
}
