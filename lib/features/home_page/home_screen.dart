import 'dart:math';

import 'package:flutter/material.dart';
import 'package:master_thesis/core/constants/app_constants.dart';
import 'package:master_thesis/features/home_page/profile_page_header.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  static const String routeName = '/homeScreen';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.emoji_events),
              label: 'Achievements',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
          currentIndex: 0,
          backgroundColor: Theme.of(context).colorScheme.primary,
          selectedItemColor: Colors.white,
          // selectedItemColor: Colors.amber[800],
          // onTap: _onItemTapped,
        ),

        // backgroundColor: Theme.of(context).colorScheme.primary,
        body: CustomScrollView(
          slivers: [
            SliverPersistentHeader(
                pinned: true,
                // floating: true,
                delegate: ProfilePageHeader(
                  // minExtent: AppConstants.homePageAvatarRadius * 2 + 8 * 2,
                  minExtent: 175,
                  maxExtent: 175,
                )),
            // SliverList(
            //   delegate: SliverChildBuilderDelegate(
            //     (BuildContext context, int index) {
            //       return Container(
            //         color: index.isOdd ? Colors.white : Colors.black12,
            //         height: 100.0,
            //         child: Center(
            //           child: Text('$index', textScaleFactor: 5),
            //         ),
            //       );
            //     },
            //     childCount: 20,
            //   ),
            // ),
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  crossAxisCount: 2,
                ),

                ///Lazy building of list
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    /// To convert this infinite list to a list with "n" no of items,
                    /// uncomment the following line:
                    /// if (index > n) return null;
                    // return listItem(Theme.of(context).colorScheme.secondary,
                    //     "Sliver Grid item:\n$index");
                    return Card(
                      // color: Theme.of(context).colorScheme.primary,
                      elevation: 4,
                      child: GridTile(
                          child: Center(
                        child: Text("Sliver Grid item:\n$index"),
                      )),
                    );
                  },

                  /// Set childCount to limit no.of items
                  /// childCount: 100,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  getRandomColor() =>
      Color((Random().nextDouble() * 0xFFFFFF).toInt() << 0).withOpacity(1.0);

  Widget listItem(Color color, String title) => Container(
        height: 100.0,
        color: color,
        child: Center(
          child: Text(
            "$title",
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
}
