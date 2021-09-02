import 'package:flutter/material.dart';
import 'package:master_thesis/core/constants/app_constants.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({
    Key? key,
    required this.onItemTapped,
    required this.selectedIndex,
  }) : super(key: key);
  final Function(int) onItemTapped;
  final int selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(AppConstants.cornersRoundingRadius),
          topLeft: Radius.circular(AppConstants.cornersRoundingRadius),
        ),
        boxShadow: [
          BoxShadow(
              color: Colors.black38,
              spreadRadius: 0,
              blurRadius: AppConstants.cornersRoundingRadius),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppConstants.cornersRoundingRadius),
          topRight: Radius.circular(AppConstants.cornersRoundingRadius),
        ),
        child: BottomNavigationBar(
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
          currentIndex: selectedIndex,
          backgroundColor: Theme.of(context).colorScheme.primary,
          selectedItemColor: Colors.white,
          onTap: onItemTapped,
        ),
      ),
    );
  }
}
