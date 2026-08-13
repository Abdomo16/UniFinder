import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/scaffold_with_nav_bar.dart';

import '../../features/onboarding/screens/welcome_screen.dart';
import '../../features/university_search/screens/search_screen.dart';
import '../../features/university_search/screens/university_detail_screen.dart';

class AppRouter {
  static final GlobalKey<NavigatorState> _rootNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'root');

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/welcome',
    routes: [
      GoRoute(
        path: '/welcome',
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: '/university_detail',
        builder: (context, state) =>
            UniversityDetailScreen(id: state.extra as String? ?? ''),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return ScaffoldWithNavBar(navigationShell: navigationShell);
        },
        branches: [
          // Home
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                builder: (context, state) =>
                    const Scaffold(body: Center(child: Text('Home'))),
              ),
            ],
          ),
          // Discover
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/discover',
                builder: (context, state) => const SearchScreen(),
              ),
            ],
          ),
          // Apps
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/apps',
                builder: (context, state) =>
                    const Scaffold(body: Center(child: Text('Apps'))),
              ),
            ],
          ),
          // Saved
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/saved',
                builder: (context, state) =>
                    const Scaffold(body: Center(child: Text('Saved'))),
              ),
            ],
          ),
          // Profile
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                builder: (context, state) =>
                    const Scaffold(body: Center(child: Text('Profile'))),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
