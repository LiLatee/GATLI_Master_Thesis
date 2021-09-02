import 'package:flutter/material.dart';
import 'package:master_thesis/features/home_page/profile_page_header.dart';

class ActionsGridView extends StatelessWidget {
  const ActionsGridView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          crossAxisCount: 2,
        ),
        delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
          return Card(
            // color: Theme.of(context).colorScheme.primary,
            elevation: 4,
            child: GridTile(
                child: Center(
              child: Text("Sliver Grid item:\n$index"),
            )),
          );
        }, childCount: 20),
      ),
    );
  }
}
