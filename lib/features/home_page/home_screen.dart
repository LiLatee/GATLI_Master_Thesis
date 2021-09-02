import 'dart:math';

import 'package:flutter/material.dart';
import 'package:master_thesis/core/constants/app_constants.dart';
import 'package:master_thesis/features/home_page/achievements_page/achievements_page.dart';
import 'package:master_thesis/features/home_page/actions_gird_view/actions_grid_view.dart';
import 'package:master_thesis/features/home_page/profile_page_header.dart';
import 'package:master_thesis/features/widgets/custom_bottom_navigation_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  static const String routeName = '/homeScreen';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  static const List<Widget> _options = [
    ActionsGridView(),
    AchievementsPage(),
    SliverToBoxAdapter(child: Center(child: LinearProgressIndicator())),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: CustomBottomNavigationBar(
          selectedIndex: _selectedIndex,
          onItemTapped: (int selected) {
            setState(() {
              _selectedIndex = selected;
            });
          },
        ),
        body: CustomScrollView(
          slivers: [
            SliverPersistentHeader(
              pinned: true,
              // floating: true,
              delegate: ProfilePageHeader(
                // minExtent: AppConstants.homePageAvatarRadius * 2 + 8 * 2,
                minExtent: 185,
                maxExtent: 185,
              ),
            ),
            _options[_selectedIndex],
          ],
        ),
      ),
    );
  }
}
