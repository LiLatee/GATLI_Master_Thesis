import 'package:flutter/material.dart';
import 'package:fluttermoji/fluttermoji.dart';
import 'package:master_thesis/core/constants/AppConstants.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            actions: [IconButton(onPressed: () {}, icon: Icon(Icons.settings))],
            pinned: true,
            floating: true,
            snap: true,
            collapsedHeight: 160.0,
            expandedHeight: 160.0,
            flexibleSpace: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        FluttermojiCircleAvatar(
                          radius: 30.0,
                        ),
                        SizedBox(width: 8.0),
                        Text(
                          "Marcin",
                          style: Theme.of(context).textTheme.headline5,
                        ),
                      ],
                    ),
                    Divider(
                      thickness: 1.0,
                      color: Colors.black,
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return Container(
                  color: index.isOdd ? Colors.white : Colors.black12,
                  height: 100.0,
                  child: Center(
                    child: Text('$index', textScaleFactor: 5),
                  ),
                );
              },
              childCount: 20,
            ),
          ),
        ],
      ),
    );
  }
}
