import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../library/library_page.dart';
import '../search/search_page.dart';
import '../shell/mini_player.dart';
import 'home_feed_page.dart';

class HomePage extends StatefulWidget {
  static const String routeName = '/home';

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  static const _pages = [
    HomeFeedPage(),
    SearchPage(),
    LibraryPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const MiniPlayer(),
          BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) => setState(() => _currentIndex = index),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home),
                label: AppStrings.home,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search_outlined),
                activeIcon: Icon(Icons.search),
                label: AppStrings.search,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.library_music_outlined),
                activeIcon: Icon(Icons.library_music),
                label: AppStrings.library,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
