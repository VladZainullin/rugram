import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/home/home_page.dart';
import '../../features/navigation/main_screen.dart';
import '../../features/profile/profile_page.dart';
import 'app_routes.dart';

class AppRouterConfiguration {
  static GoRouter createRouter(BuildContext appContext) {
    return GoRouter(
      initialLocation: AppRoutes.home.path,
      routes: [
        ShellRoute(
          builder: (context, state, pageWidget) =>
              MainScreen(child: pageWidget),
          routes: [
            GoRoute(
              name: AppRoutes.home.fullName,
              path: AppRoutes.home.path,
              builder: (context, state) => const MyHomePage(),
            ),
            GoRoute(
              name: AppRoutes.search.fullName,
              path: AppRoutes.search.path,
              builder: (context, state) => const Center(child: Text('search')),
            ),
            GoRoute(
              name: AppRoutes.video.fullName,
              path: AppRoutes.video.path,
              builder: (context, state) => const Center(child: Text('video')),
            ),
            GoRoute(
              name: AppRoutes.cart.fullName,
              path: AppRoutes.cart.path,
              builder: (context, state) => const Center(child: Text('cart')),
            ),
            GoRoute(
              name: AppRoutes.profile.fullName,
              path: AppRoutes.profile.path,
              builder: (context, state) => const ProfilePage(),
            ),
          ],
        ),
      ],
    );
  }
}
