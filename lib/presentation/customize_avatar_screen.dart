import 'package:flutter/material.dart';
import 'package:fluttermoji/fluttermoji.dart';

class CustomizeAvatarScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Spacer(),
            FluttermojiCircleAvatar(),
            Spacer(),
            FluttermojiCustomizer(),
          ],
        ),
      ),
    );
  }
}
