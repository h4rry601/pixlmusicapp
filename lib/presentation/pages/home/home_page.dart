// lib/presentation/pages/home/home_page.dart
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../player/player_page.dart';
import '../auth/login_page.dart';

class HomePage extends StatefulWidget {
  static const String routeName = '/home';

  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    _HomeTab(),
    _SearchTab(),
    _LibraryTab(),
    _ProfileTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        items: [
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
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: AppStrings.profile,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, PlayerPage.routeName);
        },
        backgroundColor: AppColors.primary,
        child: Icon(Icons.play_arrow, color: Colors.white),
      ),
    );
  }
}

// Home Tab
class _HomeTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.home),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome section
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primary, AppColors.secondary],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Good morning!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'Monospace',
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Ready to discover new music?',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                      fontFamily: 'Monospace',
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 24),

            // Quick access
            Text(
              'Quick Access',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
                fontFamily: 'Monospace',
              ),
            ),

            SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: _QuickAccessCard(
                    icon: Icons.favorite,
                    title: AppStrings.favorites,
                    color: AppColors.accent,
                    onTap: () {},
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: _QuickAccessCard(
                    icon: Icons.playlist_play,
                    title: AppStrings.playlists,
                    color: AppColors.secondary,
                    onTap: () {},
                  ),
                ),
              ],
            ),

            SizedBox(height: 24),

            // Recent music
            Text(
              AppStrings.recent,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
                fontFamily: 'Monospace',
              ),
            ),

            SizedBox(height: 16),

            _MusicList(),
          ],
        ),
      ),
    );
  }
}

// Search Tab
class _SearchTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.search),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search music...',
                prefixIcon: Icon(Icons.search),
                suffixIcon: Icon(Icons.mic),
              ),
            ),
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search, size: 64, color: AppColors.textSecondary),
            SizedBox(height: 16),
            Text(
              'Search for your favorite music',
              style: TextStyle(
                fontSize: 18,
                color: AppColors.textSecondary,
                fontFamily: 'Monospace',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Library Tab
class _LibraryTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.library),
        actions: [IconButton(icon: Icon(Icons.sort), onPressed: () {})],
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          _LibraryItem(
            icon: Icons.music_note,
            title: AppStrings.songs,
            subtitle: '125 songs',
            onTap: () {},
          ),
          _LibraryItem(
            icon: Icons.album,
            title: AppStrings.albums,
            subtitle: '45 albums',
            onTap: () {},
          ),
          _LibraryItem(
            icon: Icons.person,
            title: AppStrings.artists,
            subtitle: '23 artists',
            onTap: () {},
          ),
          _LibraryItem(
            icon: Icons.playlist_play,
            title: AppStrings.playlists,
            subtitle: '8 playlists',
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

// Profile Tab
class _ProfileTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.profile),
        actions: [IconButton(icon: Icon(Icons.settings), onPressed: () {})],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // Profile info
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: AppColors.primary,
                    child: Icon(Icons.person, size: 50, color: Colors.white),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Music Lover',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                      fontFamily: 'Monospace',
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'music.lover@example.com',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                      fontFamily: 'Monospace',
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 24),

            // Profile options
            _ProfileOption(
              icon: Icons.favorite,
              title: 'My Favorites',
              onTap: () {},
            ),
            _ProfileOption(
              icon: Icons.download,
              title: 'Downloads',
              onTap: () {},
            ),
            _ProfileOption(
              icon: Icons.history,
              title: 'Listening History',
              onTap: () {},
            ),
            _ProfileOption(
              icon: Icons.settings,
              title: 'Settings',
              onTap: () {},
            ),
            _ProfileOption(
              icon: Icons.logout,
              title: AppStrings.logout,
              onTap: () {
                Navigator.pushReplacementNamed(context, LoginPage.routeName);
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Helper widgets
class _QuickAccessCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onTap;

  const _QuickAccessCard({
    required this.icon,
    required this.title,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, size: 32, color: color),
            SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
                fontFamily: 'Monospace',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MusicList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(5, (index) {
        return Container(
          margin: EdgeInsets.only(bottom: 12),
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.music_note, color: Colors.white),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Song ${index + 1}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                        fontFamily: 'Monospace',
                      ),
                    ),
                    Text(
                      'Artist ${index + 1}',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                        fontFamily: 'Monospace',
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(Icons.play_arrow, color: AppColors.primary),
                onPressed: () {
                  Navigator.pushNamed(context, PlayerPage.routeName);
                },
              ),
            ],
          ),
        );
      }),
    );
  }
}

class _LibraryItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _LibraryItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(
        title,
        style: TextStyle(
          color: AppColors.textPrimary,
          fontFamily: 'Monospace',
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: AppColors.textSecondary,
          fontFamily: 'Monospace',
        ),
      ),
      trailing: Icon(Icons.arrow_forward_ios, color: AppColors.textSecondary),
      onTap: onTap,
    );
  }
}

class _ProfileOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _ProfileOption({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(
        title,
        style: TextStyle(color: AppColors.textPrimary, fontFamily: 'Monospace'),
      ),
      trailing: Icon(Icons.arrow_forward_ios, color: AppColors.textSecondary),
      onTap: onTap,
    );
  }
}
