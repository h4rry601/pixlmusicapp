// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/di/injection_container.dart' as di;
import 'core/constants/app_colors.dart';
import 'core/constants/app_strings.dart';
import 'presentation/pages/splash/splash_page.dart';
import 'presentation/pages/home/home_page.dart';
import 'presentation/pages/auth/login_page.dart';
import 'presentation/pages/player/player_page.dart';
import 'presentation/pages/playlist/playlist_page.dart';
import 'package:nes_ui/nes_ui.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependencies
  await di.setupDependencies();

  // Set system UI overlay style for 8-bit theme
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: AppColors.background,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(PIXLApp());
}

class PIXLApp extends StatelessWidget {
  const PIXLApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,

      // Theme configuration
      theme: flutterNesTheme(primaryColor: const Color(0xFFFF8800)).copyWith(
        scaffoldBackgroundColor: AppColors.background,
        textTheme: GoogleFonts.pressStart2pTextTheme(
          Theme.of(context).textTheme.copyWith(
            displayLarge: const TextStyle(fontSize: 32),
            displayMedium: const TextStyle(fontSize: 28),
            displaySmall: const TextStyle(fontSize: 24),
            headlineLarge: const TextStyle(fontSize: 22),
            headlineMedium: const TextStyle(fontSize: 20),
            headlineSmall: const TextStyle(fontSize: 18),
            titleLarge: const TextStyle(fontSize: 16),
            titleMedium: const TextStyle(fontSize: 14),
            titleSmall: const TextStyle(fontSize: 12),
            bodyLarge: const TextStyle(fontSize: 14),
            bodyMedium: const TextStyle(fontSize: 12),
            bodySmall: const TextStyle(fontSize: 10),
            labelLarge: const TextStyle(fontSize: 12),
            labelMedium: const TextStyle(fontSize: 10),
            labelSmall: const TextStyle(fontSize: 8),
          ),
        ).apply(
          bodyColor: AppColors.textPrimary,
          displayColor: AppColors.textPrimary,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.background,
          elevation: 0,
          iconTheme: IconThemeData(color: AppColors.textPrimary),
          titleTextStyle: GoogleFonts.pressStart2p(
            color: AppColors.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          systemOverlayStyle: SystemUiOverlayStyle.light,
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: AppColors.surface,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.textSecondary,
          type: BottomNavigationBarType.fixed,
          elevation: 8,
        ),
      ),

      // Routes
      initialRoute: SplashPage.routeName,
      routes: {
        SplashPage.routeName: (context) => SplashPage(),
        HomePage.routeName: (context) => HomePage(),
        LoginPage.routeName: (context) => LoginPage(),
        PlayerPage.routeName: (context) => PlayerPage(),
      },

      // Route generator for dynamic routes
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/playlist':
            // Handle playlist route with arguments
            final args = settings.arguments as Map<String, dynamic>?;
            return MaterialPageRoute(
              builder: (context) => PlaylistPage(
                playlistId: args?['playlistId'] ?? '',
                playlistName: args?['playlistName'] as String?,
                accentColor: args?['accentColor'] != null
                    ? Color(args!['accentColor'] as int)
                    : null,
              ),
            );
          default:
            return MaterialPageRoute(
              builder:
                  (context) => Scaffold(
                    body: Center(
                      child: Text(
                        'Page not found',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontFamily: 'Monospace',
                        ),
                      ),
                    ),
                  ),
            );
        }
      },
    );
  }
}
