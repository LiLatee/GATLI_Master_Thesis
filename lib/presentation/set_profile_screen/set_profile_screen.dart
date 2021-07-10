import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttermoji/fluttermoji.dart';
import 'package:master_thesis/logic/cubit/launching_cubit.dart';

class SetProfileScreen extends StatelessWidget {
  const SetProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Set Profile :)"),
      ),
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextFormField(
            decoration: InputDecoration(
                labelText: "Your Name",
                focusedBorder: OutlineInputBorder(borderSide: BorderSide())),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FluttermojiCircleAvatar(),
                // Spacer(),
                FluttermojiCustomizer(),
              ],
            ),
          )
        ],
      ),
    );
  }
}
