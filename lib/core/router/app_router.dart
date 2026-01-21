import 'package:go_router/go_router.dart';
import 'package:ecommerce_app/features/search/presentation/pages/search_page.dart';
import 'package:ecommerce_app/features/product/presentation/pages/product_page.dart';
import 'package:ecommerce_app/features/home/presentation/pages/home_page.dart';
import 'package:ecommerce_app/features/profile/presentation/pages/profile_page.dart';
import 'package:ecommerce_app/features/main/presentation/pages/main_wrapper.dart';

final router = GoRouter(
  initialLocation: '/home',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return MainWrapper(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => const HomePage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/search',
              builder: (context, state) => const SearchPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profile',
              builder: (context, state) => const ProfilePage(),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: '/product',
      builder: (context, state) {
        // Will pass product object or ID later
        return const ProductPage();
      },
    ),
  ],
);
