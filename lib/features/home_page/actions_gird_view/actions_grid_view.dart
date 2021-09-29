import 'package:flutter/material.dart';
import 'package:master_thesis/features/home_page/grid_items/thai_chi/thai_chi_lesson.dart';
import 'package:master_thesis/features/home_page/grid_items/thai_chi/thai_chi_page.dart';
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
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            crossAxisCount: 2,
          ),
          delegate: SliverChildListDelegate(
            [
              GestureDetector(
                child: const Card(
                  // color: Theme.of(context).colorScheme.primary,
                  elevation: 4,
                  child: GridTile(
                    child: Center(
                      child: Text("Sliver Grid item:\n"),
                    ),
                  ),
                ),
                onTap: () => Navigator.pushNamed(context, ThaiChiPage.routeName,
                    arguments: thaiChiLessons[0]),
              ),
            ],
          )
          // SliverChildBuilderDelegate(
          //   (BuildContext context, int index) {
          //     return Card(
          //       // color: Theme.of(context).colorScheme.primary,
          //       elevation: 4,
          //       child: GridTile(
          //           child: Center(
          //         child: Text("Sliver Grid item:\n$index"),
          //       )),
          //     );
          //   },
          //   childCount: 20,
          // ),
          ),
    );
  }
}
